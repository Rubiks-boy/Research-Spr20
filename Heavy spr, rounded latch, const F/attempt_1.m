clearvars;
close all;

mass = logspace(-5, 5, 100);
m = 5;
m_spr = 0.5;
v0 = 1;
F_l = 0;
m_l = 1000000;
R = 8;

figure(1);
% vto_plot(mass, m_spr, R, v0, F_l, m_l);
tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l)

times = linspace(0, 6, 1000);
% figure(2);
% x_vs_t_plot(times, m, m_spr, R, v0, F_l, m_l);
% figure(3);
% v_vs_t_plot(times, m, m_spr, R, v0, F_l, m_l);
figure(4);
test_plot(times, m, m_spr, R, v0, F_l, m_l);

function test()
    S = load('S');
    S.F_l
    F_l
end

% Make the plot for v_to
function vto_plot(m, m_spr, R, v0, F_l, m_l)
    tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l);
    size(tl)
    x = m;
    y = calc_vto_DL(tl, m, m_spr, R, v0, F_l, m_l);
    plot(x, tl);
    set(gca,'XScale', 'log');
%     set(gca,'YScale', 'log');
    title('Takeoff Velocity')
    xlabel('mass');
    ylabel('takeoff velocity');
end

function test_plot(t, m, m_spr, R, v0, F_l, m_l)
    test1 = (1 - calc_l_x_DL(t, R, v0, F_l, m_l));
    test2 = ((m + m_spr / 3) .* calc_l_a_DL(t, R, v0, F_l, m_l));
    hold on;
    plot(t, test1, 'g');
    hold on;
    plot(t, test2, 'r');
end

function x_vs_t_plot(t, m, m_spr, R, v0, F_l, m_l)
    % calculate latch release time and takeoff time
    t_l = calc_tl_DL(m, m_spr, R, v0, F_l, m_l);
    t_to = calc_tto_DL(t_l, m, m_spr, R, v0, F_l, m_l);
    
    % plot these values
    x1 = t(t <= t_l);
    x2 = t(t > t_l & t <= t_to);
    x3 = t(t > t_to);
    y1 = calc_l_x_DL(x1, R, v0, F_l, m_l);
    y2 = calc_r_x_DL(x2, m, m_spr, R, v0, F_l, m_l);
    y3 = calc_f_x_DL(x3, m, m_spr, R, v0, F_l, m_l);
    
    plot(x1, y1, 'b');
    hold on
    plot(x2, y2, 'b');
    plot(x3, y3, 'b');
    title('Position vs. time');
    xlabel('t');
    ylabel('x');
    
    % add vertical line at t = t_l and t = t_to
    y_lim = get(gca,'ylim');
    plot([t_l t_l],y_lim, '--r');
    plot([t_to t_to],y_lim, '--r');
end

function v_vs_t_plot(t, m, m_spr, R, v0, F_l, m_l)
    % calculate latch release time and takeoff time
    t_l = calc_tl_DL(m, m_spr, R, v0, F_l, m_l);
    t_to = calc_tto_DL(t_l, m, m_spr, R, v0, F_l, m_l);
    
    % plot these values
    x1 = t(t <= t_l);
    x2 = t(t > t_l & t <= t_to);
    x3 = t(t > t_to);
    y1 = calc_l_v_DL(x1, R, v0, F_l, m_l);
    y2 = calc_r_v_DL(x2, m, m_spr, R, v0, F_l, m_l);
    y3 = x3 .* 0 + calc_vto_DL(t_l, m, m_spr, R, v0, F_l, m_l);
    
    plot(x1, y1, 'b');
    hold on
    plot(x2, y2, 'b');
    plot(x3, y3, 'b');
    title('Velocity vs. time');
    xlabel('t');
    ylabel('x');
    
    % add vertical line at t = t_l and t = t_to
    y_lim = get(gca,'ylim');
    plot([t_l t_l],y_lim, '--r');
    plot([t_to t_to],y_lim, '--r');
end

%% (L)atched: DIMENSIONLESS, FOR t <= t_l
% Position of latch, wrt time
function y = calc_l_y_DL(t, R, v0, F_l, m_l)
    y = min(v0 * t + 0.5 * F_l / m_l * (t.^2), R - eps);
end

% Vel of latch, wrt time
function ydot = calc_l_ydot_DL(t, v0, F_l, m_l)
    ydot = v0 + F_l / m_l * t;
end

% Acc of latch, wrt time
function yddot = calc_l_yddot_DL(t, v0, F_l, m_l)
    yddot = F_l / m_l;
end

% position of projectile, while latched
function x = calc_l_x_DL(t, R, v0, F_l, m_l)
    y = calc_l_y_DL(t, R, v0, F_l, m_l);
    x = R .* (1 - sqrt(1 - (y ./ R).^2));
end

% vel of proj, while latched
function v = calc_l_v_DL(t, R, v0, F_l, m_l)
    y = calc_l_y_DL(t, R, v0, F_l, m_l);
    ydot = calc_l_ydot_DL(t, v0, F_l, m_l);
    v = y .* ydot ./ (R .* sqrt(1 - (y ./ R).^2));
end

% acc of proj, while latched
function a = calc_l_a_DL(t, R, v0, F_l, m_l)
    y = calc_l_y_DL(t, R, v0, F_l, m_l);
    ydot = calc_l_ydot_DL(t, v0, F_l, m_l);
    yddot = calc_l_yddot_DL(t, v0, F_l, m_l);
    a = (1 ./ (R .* sqrt(1 - (y ./ R).^2))) .* ...
        (ydot.^2 + y .* yddot + y.^2 .* ydot.^2 / (R^2 - y.^2));
end

% time at which latch releases 
function tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l)
    opt_start = 1.5;
    opt_vec = ones(size(m)) * opt_start;
    zerofunc = @(tl) (calc_l_x_DL(tl, R, v0, F_l, m_l) - 1 + ...
        ((m + m_spr / 3) .* calc_l_a_DL(tl, R, v0, F_l, m_l)));
    
%     options = optimoptions('fsolve','FunctionTolerance', 1E-8);
%     tl = max(fsolve(zerofunc, opt_vec, options), 0);
    
    tl = fzero(zerofunc, opt_vec);
end

%% (R)eleased: DL, FOR t_l <= t <= t_to 
% takeoff velocity upon release
function vto = calc_vto_DL(tl, m, m_spr, R, v0, F_l, m_l)
    xl = calc_l_x_DL(tl, R, v0, F_l, m_l);
    vl = calc_l_v_DL(tl, R, v0, F_l, m_l);
    vto = sqrt(vl + (1 ./ (m + m_spr / 3)) .* (1 - xl).^2);
end

% helper function to calc phase shift
function phi = helper_calc_phase(tl, m, m_spr, R, v0, F_l, m_l)
    xl = calc_l_x_DL(tl, R, v0, F_l, m_l);
    vl = calc_l_v_DL(tl, R, v0, F_l, m_l);
    
    phi = atan(sqrt(m + m_spr / 3) .* vl ./ (1 - xl)) - ...
        (tl ./ sqrt(m + m_spr / 3));
end

% x position of projectile
function x = calc_r_x_DL(t, m, m_spr, R, v0, F_l, m_l)
    tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l)
    vto = calc_vto_DL(tl, m, m_spr, R, v0, F_l, m_l)
    phase = helper_calc_phase(tl, m, m_spr, R, v0, F_l, m_l)
    
    x = 1 - (vto .* sqrt(m + m_spr / 3) .* ...
        cos((t ./ sqrt(m + m_spr / 3)) + phase));
end

% vel of projectile
function v = calc_r_v_DL(t, m, m_spr, R, v0, F_l, m_l)
    tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l);
    vto = calc_vto_DL(tl, m, m_spr, R, v0, F_l, m_l);
    phase = helper_calc_phase(tl, m, m_spr, R, v0, F_l, m_l);
    
    v = vto .* sin((t ./ sqrt(m + m_spr / 3)) + phase);
end

% accel of projectile
function a = calc_r_a_DL(t, m, m_spr, R, v0, F_l, m_l)
    tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l);
    vto = calc_vto_DL(tl, m, m_spr, R, v0, F_l, m_l);
    phase = helper_calc_phase(tl, m, m_spr, R, v0, F_l, m_l);
    
    a = (vto ./ sqrt(m + m_spr / 3)) .* ...
        cos((t ./ sqrt(m + m_spr / 3)) + phase);
end

function tto = calc_tto_DL(tl, m, m_spr, R, v0, F_l, m_l)
    phase = helper_calc_phase(tl, m, m_spr, R, v0, F_l, m_l);
    tto = sqrt(m + m_spr / 3) .* (pi / 2 - phase);
end

%% (F)ree: DL, FOR t > t_to
% x position of projectile
function x = calc_f_x_DL(t, m, m_spr, R, v0, F_l, m_l)
    tl = calc_tl_DL(m, m_spr, R, v0, F_l, m_l);
    vto = calc_vto_DL(tl, m, m_spr, R, v0, F_l, m_l);
    
    tto = calc_tto_DL(tl, m, m_spr, R, v0, F_l, m_l);
    xto = calc_r_x_DL(tto, m, m_spr, R, v0, F_l, m_l);
    
    x = xto + vto .* (t - tto);
end