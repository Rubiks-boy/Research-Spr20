clearvars;
close all;

plot_y = false;
plot_x = false;
plot_tl = false;
plot_vto = true;
plot_xr = true;
plot_vr = true;
plot_ar = true;

%% Load all parameters from a file
p = load('params');

%% y (horizontal) position of latch, wrt time
y = min(p.v0 * p.t + 0.5 * p.F_l / p.m_l * (p.t.^2), p.R - eps);
y_dot = p.v0 + p.F_l / p.m_l * p.t;
y_ddot = p.F_l / p.m_l;

if(plot_y)
    figure(1);
    hold on;
    plot(p.t, y);
    plot(p.t, y_dot);
    plot(p.t, y_ddot);
end

%% x position of projectile while in contact w/latch
x = p.R * (1 - sqrt(1 - (y / p.R).^2));

if(plot_x)
    figure(2);
    hold on;
    plot(p.t, x);
end

% v of projectile while in contact w/latch
v = y .* y_dot ./ (p.R * sqrt(1 - (y / p.R).^2));

if(plot_x)
    plot(p.t, v);
end

% a of projectile while in contact w/latch
a = 1 ./ (p.R * sqrt(1 - (y / p.R).^2)) .* (y_dot.^2 + y .* y_ddot + y.^2 .* y_dot.^2 ./ (p.R^2 - y.^2));

if(plot_x)
    plot(p.t, a);
end

%% calculates t_l, time of latch release
% do this for all masses (this is ok since previous expressions don't
% depend on mass)
[q, num_times] = size(p.t);
[q, num_mass] = size(p.m);
t_l_index = 1 * ones(1, num_mass);
min_val = inf * ones(1, num_mass);

% find the roots of the function that finds t_l
for m=1:num_mass
    for i=1:num_times
        cur_val = abs((p.m(m) + p.m_spr/3) .* a(i) + x(i) - 1);
        if(cur_val < min_val(m))
            t_l_index(m) = i;
            min_val(m) = cur_val;
        end
    end
end

% change those into times
% if a root wasn't found, it'll default to t_l = 0

t_l = p.t(t_l_index);

if(plot_tl)
    figure(3);
    plot(p.m, t_l);
    set(gca,'XScale', 'log');
end

%% calculate v_to: velocity when projectile loses contact with spring
x_l = v(t_l_index);
v_l = v(t_l_index);
v_to = sqrt(v_l.^2 + 1 ./ (p.m + p.m_spr / 3) .* (1 - x_l).^2);

if(plot_vto)
    figure(4);
    plot(p.m, v_to);
    set(gca,'XScale', 'log');
    set(gca,'YScale', 'log');
end

%% position after latch release
x_r = (ones(1, num_times))' * (1 * ones(1, num_mass));
v_r = x_r;
a_r = x_r;
for i=1:num_mass
    m = p.m(i);
    m_sqrt = sqrt(m + p.m_spr / 3);
    
    phi = atan(m_sqrt * v_l(i) / (1 - x_l(i))) - (t_l(i)) ./ m_sqrt;
    x_r(:, i) = 1 - v_to(i) * m_sqrt * cos(p.t / m_sqrt + phi);
    v_r(:, i) = v_to(i) * sin(p.t / m_sqrt + phi);
    a_r(:, i) = v_to(i) / m_sqrt * cos(p.t / m_sqrt + phi);
end

for m=1:num_mass
    for t=1:num_times
        if(p.t(t) < t_l(m))
            x_r(t, m) = 0;
            v_r(t, m) = 0;
            a_r(t, m) = 0;
        end
    end
end

if(plot_xr)
    figure(5);
    xr_plot = pcolor(p.m, p.t, x_r);
    set(gca,'XScale', 'log');
    set(xr_plot, 'EdgeColor', 'none');
    colorbar;
end

if(plot_vr)
    figure(6);
    vr_plot = pcolor(p.m, p.t, v_r);
    set(gca,'XScale', 'log');
    set(vr_plot, 'EdgeColor', 'none');
    colorbar;
end

if(plot_ar)
    figure(7);
    ar_plot = pcolor(p.m, p.t, a_r);
    set(gca,'XScale', 'log');
    set(ar_plot, 'EdgeColor', 'none');
    colorbar;
end