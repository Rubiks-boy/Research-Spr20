clearvars;
close all;

plot_y = false;
plot_x = false;
plot_tl = true;
plot_vto = false;
plot_tto = true;
plot_xl = true;
plot_vl = true;
plot_al = true;
plot_xva = true;

%% Load all parameters from a file
p = load('params');

%% y (horizontal) position of latch, wrt time
y = min(p.v0 * p.t + 0.5 * p.F_l / p.m_l * (p.t.^2), p.R - eps);
y_dot = p.v0 + p.F_l / p.m_l * p.t;
y_ddot = p.F_l / p.m_l;

if plot_y
    figure(1);
    hold on;
    plot(p.t, y, 'b');
    plot(p.t, y_dot, 'r');
    plot(p.t, y_ddot, 'g');
    title('y (horiz) kinematics of latch')
    xlabel('t');
    ylabel('pos (b), vel (r), acc (g)');
end

%% x position of projectile while in contact w/latch
x = p.R * (1 - sqrt(1 - (y / p.R).^2));

if plot_x
    figure(2);
    hold on;
    plot(p.t, x, 'b');
    title('x kinematics of projectile in contact w/latch')
    xlabel('t');
    ylabel('pos (b), vel (r), acc (g)');
end

% v of projectile while in contact w/latch
v = y .* y_dot ./ (p.R * sqrt(1 - (y / p.R).^2));

if plot_x
    plot(p.t, v, 'r');
end

% a of projectile while in contact w/latch
a = 1 ./ (p.R * sqrt(1 - (y / p.R).^2)) .* (y_dot.^2 + y .* y_ddot + y.^2 .* y_dot.^2 ./ (p.R^2 - y.^2));

if plot_x
%     plot(p.t, a, 'g');
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
            t_l_index(m) = max(1, i - 1);
            min_val(m) = cur_val;
        end
    end
end

% change those into times
% if a root wasn't found, it'll default to t_l = 0

t_l = p.t(t_l_index);

if plot_tl
    figure(3);
    plot(p.m, t_l);
    set(gca,'XScale', 'log');
    title('unlatching time')
    xlabel('mass');
    ylabel('t_l');
end

%% calculate v_to: velocity when projectile loses contact with spring
xl = x(t_l_index);
vl = v(t_l_index);
v_to = sqrt(vl.^2 + 1 ./ (p.m + p.m_spr / 3) .* (1 - xl).^2);

if plot_vto
    figure(4);
    plot(p.m, v_to);
    set(gca,'XScale', 'log');
    set(gca,'YScale', 'log');
    title('takeoff velocity')
    xlabel('mass');
    ylabel('v_{to}');
end

%% position after latch release
x_r = (ones(1, num_times))' * (1 * ones(1, num_mass));
v_r = x_r;
a_r = x_r;
t_to = ones(1, num_mass);

for i=1:num_mass
    m = p.m(i);
    m_sqrt = sqrt(m + p.m_spr / 3);
    
    phi = atan(m_sqrt * vl(i) / (1 - xl(i))) - (t_l(i)) ./ m_sqrt;
    x_r(:, i) = 1 - (v_to(i) * m_sqrt * cos(p.t / m_sqrt + phi));
    v_r(:, i) = v_to(i) * sin(p.t / m_sqrt + phi);
    a_r(:, i) = v_to(i) / m_sqrt * cos(p.t / m_sqrt + phi);
    
    t_to(i) = m_sqrt * (pi / 2 - phi);
end

if plot_tto
    figure(5);
    plot(p.m, t_to);
    set(gca,'XScale', 'log');
    set(gca,'YScale', 'log');
    title('takeoff time')
    xlabel('mass');
    ylabel('t_{to}');
end

x_l = x' * ones(1, num_mass);
v_l = v' * ones(1, num_mass);
a_l = a' * ones(1, num_mass);

for m=1:num_mass
    for t=1:num_times
        if p.t(t) >= t_l(m)
            x_l(t, m) = 0;
            v_l(t, m) = 0;
            a_l(t, m) = 0;
        end
    end
end

t_to_index = ones(1, num_mass);
for m=1:num_mass
    min_diff = abs(t_to(m) - p.t(1));
    for t=2:num_times
        curr_diff = abs(t_to(m) - p.t(t));
        if curr_diff < min_diff
            t_to_index(m) = t;
            min_diff = curr_diff;
        end
    end
end

xto = 0 * ones(1, num_mass);
vto = 0 * ones(1, num_mass);

for m=1:num_mass
    xto(m) = x_r(t_to_index(m), m);
    vto(m) = v_r(t_to_index(m), m);
end

for m=1:num_mass
    for t=1:num_times
        if p.t(t) < t_l(m)
            x_r(t, m) = 0;
            v_r(t, m) = 0;
            a_r(t, m) = 0;
        end
        if p.t(t) > t_to(m)
            x_r(t, m) = xto(m) + vto(m) * (p.t(t) - t_to(m));
            v_r(t, m) = vto(m);
            a_r(t, m) = 0;
        end
    end
end

if plot_xl
    figure(6);
    xr_plot = pcolor(p.m, p.t, x_l + x_r);
    set(gca,'XScale', 'log');
    set(xr_plot, 'EdgeColor', 'none');
    colorbar;
    title('x position of projectile')
    xlabel('mass');
    ylabel('t');
    hold on;
    plot(p.m, t_l, 'r');
    plot(p.m, t_to, 'r');
end

if plot_vl
    figure(7);
    vr_plot = pcolor(p.m, p.t, v_l + v_r);
    set(gca,'XScale', 'log');
    set(vr_plot, 'EdgeColor', 'none');
    colorbar;
    title('vel of projectile')
    xlabel('mass');
    ylabel('t');
    hold on;
    plot(p.m, t_l, 'r');
    plot(p.m, t_to, 'r');
end

if plot_al
    figure(8);
    ar_plot = pcolor(p.m, p.t, a_l + a_r);
    set(gca,'XScale', 'log');
    set(ar_plot, 'EdgeColor', 'none');
    colorbar;
    title('accel of projectile')
    xlabel('mass');
    ylabel('t');
    hold on;
    plot(p.m, t_l, 'r');
    plot(p.m, t_to, 'r');
end

if plot_xva
    figure(9);
    xyz_plot = pcolor(x_l + x_r, v_l + v_r, a_l + a_r);
    set(xyz_plot, 'EdgeColor', 'none');
    colorbar;
    title('pos / vel / acc')
    xlabel('pos');
    ylabel('vel');
end