clearvars;
close all;

do_plot_y = false;
do_plot_x = false;
do_plot_tl = true;
do_plot_vto = true;
do_plot_tto = true;
do_plot_xl = true;
do_plot_vl = true;
do_plot_al = true;
do_plot_xva = false;

%% Load all parameters from a file
p = load('params');

%% calculates t_l, time of latch release
% do this for all masses (this is ok since previous expressions don't
% depend on mass)
num_times = p.num_times;
[q, num_mass] = size(p.m);

t_l = ones(size(p.m));
    
for m=1:num_mass
    opt_start = 1;
    opt_vec = ones(size(m)) * opt_start;
    zero_func = @(t) ((p.m(m) + p.m_spr/3) .* calc_a_latched_t(p, t) + calc_x_latched_t(p, t) - 1);
    
    % if a root wasn't found, it'll default to t_l = 0
    t_l(m) = max(fzero(zero_func, opt_vec), 0);
end

if do_plot_tl
    plot_t_l(p, t_l, 3);
end

t_l_index = 1 * ones(1, num_mass);

for m=1:num_mass
    min_val = inf;
    for i=1:num_times
        cur_val = abs(p.t(i) - t_l(m));
        if(cur_val < min_val)
            t_l_index(m) = i;
            min_val = cur_val;
        end
    end
end

%% calculate v_to: velocity when projectile loses contact with spring
xl = calc_x_latched_t(p, t_l);
vl = calc_v_latched_t(p, t_l);
v_to = sqrt(vl.^2 + 1 ./ (p.m + p.m_spr / 3) .* (1 - xl).^2);

if do_plot_vto
    plot_vto(p, v_to, 4);
end

%% Calculates t_to, time of projectile release
% we'll use t_to to find time ranges for a given mass
t_to = ones(1, num_mass);

for i=1:num_mass
    m = p.m(i);
    m_sqrt = sqrt(m + p.m_spr / 3);
    
    phi = atan(m_sqrt * vl(i) / (1 - xl(i))) - (t_l(i)) ./ m_sqrt;
    
    t_to(i) = m_sqrt * (pi / 2 - phi);
end

if do_plot_tto
    plot_tto(p, t_to, 5);
end

p.t = ones(num_mass, p.num_times);
for i=1:num_mass
    p.t(i, :) = (linspace(0, (t_to(i) + t_l(i)) * p.t_perc_above, p.num_times))';
end

%% y (horizontal) position of latch, wrt time
y = struct();
y.y = calc_y(p, p.t);
y.y_dot = calc_y_dot(p, p.t);
y.y_ddot = calc_y_ddot(p, p.t);

if do_plot_y
    plot_y(p, y, 1);
end

%% x position of projectile while in contact w/latch
x_latch = struct();
x_latch.x = calc_x_latched(p, y);

% v of projectile while in contact w/latch
x_latch.v = calc_v_latched(p, y);

% a of projectile while in contact w/latch
x_latch.a = calc_a_latched(p, y);

if do_plot_x
    plot_x(p, x_latch, 2);
end

%% position after latch release
x_r = (ones(1, num_times))' * (1 * ones(1, num_mass));
v_r = x_r;
a_r = x_r;

for i=1:num_mass
    m = p.m(i);
    m_sqrt = sqrt(m + p.m_spr / 3);
    
    phi = atan(m_sqrt * vl(i) / (1 - xl(i))) - (t_l(i)) ./ m_sqrt;
    x_r(:, i) = 1 - (v_to(i) * m_sqrt * cos(p.t(i) / m_sqrt + phi));
    v_r(:, i) = v_to(i) * sin(p.t(i) / m_sqrt + phi);
    a_r(:, i) = v_to(i) / m_sqrt * cos(p.t(i) / m_sqrt + phi);
end

x_l = x_latch.x';
v_l = x_latch.v';
a_l = x_latch.a';

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

if do_plot_xl
    plot_xl(p, x_l + x_r, t_l, t_to, 6);
end

if do_plot_vl
    figure(7);
    vr_plot = pcolor(p.m, p.t(end, :), v_l + v_r);
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

if do_plot_al
    figure(8);
    ar_plot = pcolor(p.m, p.t(end, :), repmat(p.m, [num_times 1]) .* (a_l + a_r));
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

if do_plot_xva
    figure(9);
    x = x_l + x_r;
    v = v_l + v_r;
    f = repmat(p.m, [num_times 1]) .* (a_l + a_r);
    x = x(:);
    v = v(:);
    f = f(:);
    
    x = x + (0:size(x)-1)'*1E-14;
    v = v + (0:size(v)-1)'*1E-14;

    [x, i] = sort(x);
    v = v(i);
    f = f(i);
    
    [X, V] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100));
    inter = griddata(x, v, f, X, V);
    imagesc([min(X(1, :)), max(X(1, :))], [min(V(:, 1)), max(V(:, 1))], inter);
    set(gca,'YDir','normal')

end

%% Calculations
function y = calc_y(p, t)
    y = min(p.v0 * t + 0.5 * p.F_l / p.m_l * (t.^2), p.R - eps);
end

function y_dot = calc_y_dot(p, t)
    y_dot = p.v0 + p.F_l / p.m_l * t;
end

function y_ddot = calc_y_ddot(p, t)
    y_ddot = p.F_l / p.m_l;
end

function x = calc_x_latched(p, y)
    x = p.R * (1 - sqrt(1 - (y.y / p.R).^2));
end

function v = calc_v_latched(p, y)
    v = y.y .* y.y_dot ./ (p.R * sqrt(1 - (y.y / p.R).^2));
end

function a = calc_a_latched(p, y)
    a = 1 ./ (p.R * sqrt(1 - (y.y / p.R).^2)) .* (y.y_dot.^2 + y.y .* y.y_ddot + y.y.^2 .* y.y_dot.^2 ./ (p.R^2 - y.y.^2));
end

function x = calc_x_latched_t(p, t)
    y = calc_y(p, t);
    x = p.R * (1 - sqrt(1 - (y / p.R).^2));
end

function v = calc_v_latched_t(p, t)
    y = calc_y(p, t);
    y_dot = calc_y_dot(p, t);
    v = y .* y_dot ./ (p.R * sqrt(1 - (y / p.R).^2));
end

function a = calc_a_latched_t(p, t)
    y = calc_y(p, t);
    y_dot = calc_y_dot(p, t);
    y_ddot = calc_y_ddot(p, t);
    a = 1 ./ (p.R * sqrt(1 - (y / p.R).^2)) .* (y_dot.^2 + y .* y_ddot + y.^2 .* y_dot.^2 ./ (p.R^2 - y.^2));
end

%% Plotting functions
function plot_y(p, y, fig_num)
    figure(fig_num);
    hold on;
    plot(p.t, y.y, 'b');
    plot(p.t, y.y_dot, 'r');
    plot(p.t, y.y_ddot, 'g');
    title('y (horiz) kinematics of latch')
    xlabel('t');
    ylabel('pos (b), vel (r), acc (g)');
end

function plot_x(p, x, fig_num)
    figure(fig_num);
    hold on;
    plot(p.t, x.x, 'b');
    title('x kinematics of projectile in contact w/latch')
    xlabel('t');
    ylabel('pos (b), vel (r), acc (g)');
    
    plot(p.t, x.v, 'r');
    
%     plot(p.t, x.a, 'g');
end

function plot_t_l(p, t_l, fig_num)
    figure(fig_num);
    plot(p.m, t_l);
    set(gca,'XScale', 'log');
    title('unlatching time')
    xlabel('mass');
    ylabel('t_l');
end

function plot_vto(p, v_to, fig_num)
    figure(fig_num);
    plot(p.m, v_to);
    set(gca,'XScale', 'log');
    set(gca,'YScale', 'log');
    title('takeoff velocity')
    xlabel('mass');
    ylabel('v_{to}');
end

function plot_tto(p, t_to, fig_num)
    figure(fig_num);
    plot(p.m, t_to);
    set(gca,'XScale', 'log');
    set(gca,'YScale', 'log');
    title('takeoff time')
    xlabel('mass');
    ylabel('t_{to}');
end

function plot_xl(p, x, t_l, t_to, fig_num)
    figure(fig_num);
    xr_plot = pcolor(p.m, p.t(end, :), x);
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