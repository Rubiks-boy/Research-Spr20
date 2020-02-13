clearvars;
close all;

%% input parameters
F_max = 1;          % maximum motor force
d = 5;             % motor range of motion
v_max = 5;          % maximum motor velocity

% mass of the projectile
mass = logspace(-5, 5, 100);
single_mass = 1;
m_spr = 0.1;

figure(1);
vto_plot(F_max, d, v_max, mass, m_spr);

times = linspace(0, 6, 1000);
figure(2);
x_vs_t_plot(times, F_max, d, v_max, single_mass, m_spr);
figure(3);
v_vs_t_plot(times, F_max, d, v_max, single_mass, m_spr);

function x_vs_t_plot(t, F_max, d, v_max, mass, m_spr)
    % calculate takeoff time
    t_to = calc_t_to(F_max, d, v_max, mass, m_spr);
    
    % plot these values
    x1 = t(t <= t_to);
    x2 = t(t > t_to);
    y1 = calc_X_lt_t_to(x1, F_max, d, v_max, mass, m_spr);
    y2 = calc_X_gt_t_to(x2, F_max, d, v_max, mass, m_spr);
    plot(x1, y1, 'b');
    hold on
    plot(x2, y2, 'b');
    title('Displacement vs. time');
    xlabel('t');
    ylabel('x');
    
    % add vertical line at t = t_to
    y_lim = get(gca,'ylim')
    plot([t_to t_to],y_lim, '--r');
end

function v_vs_t_plot(t, F_max, d, v_max, mass, m_spr)
    % calculate takeoff time
    t_to = calc_t_to(F_max, d, v_max, mass, m_spr)
    
    % plot these values
    x1 = t(t <= t_to);
    x2 = t(t > t_to);
    y1 = calc_V_lt_t_to(x1, F_max, d, v_max, mass, m_spr);
    y2 = x2 .* 0 + calc_Vto(F_max, d, v_max, mass, m_spr);
    plot(x1, y1, 'b');
    hold on
    plot(x2, y2, 'b');
    title('Velocity vs. time')
    xlabel('t');
    ylabel('v');
    
    % add vertical line at t = t_to
    y_lim = get(gca,'ylim')
    plot([t_to t_to],y_lim, '--r');
end

%% Make the plot for v_to
function vto_plot(F_max, d, v_max, mass, m_spr)
    x = mass;
    y = calc_Vto(F_max, d, v_max, mass, m_spr);
    plot(x, y);
    set(gca,'XScale', 'log');
    set(gca,'YScale', 'log');
    title('Linear Motor + Heavy Spr Proj Takeoff Vel')
    xlabel('mass');
    ylabel('takeoff velocity');
end

%% Calculates takeoff velocities from input parameters
function vto = calc_Vto(F_max, d, v_max, mass, m_spr)
    % convert arguments -> dimensionless motor ranges of motion
    mass_DL = mass .* (v_max)^2 / (F_max * d)
    m_spr_DL = m_spr .* (v_max)^2 / (F_max * d)
    
    % calculate dimenionless takeoff velocities
    vto_DL = calc_Vto_DL(mass_DL, m_spr_DL);
    
    % return dimension-ful takeoff velocities
    vto =  vto_DL .* v_max;
end

%% calculates dimensionless takeoff velocity
function v = calc_Vto_DL(mass, m_spr)
    v = sqrt(1 ./ (mass + (m_spr / 3)));
end

%% Calculates t_to, the takeoff time
function t_to = calc_t_to(F_max, d, v_max, mass, m_spr)
    % convert arguments -> dimensionless motor ranges of motion
    mass_DL = mass .* (v_max)^2 / (F_max * d);
    m_spr_DL = m_spr .* (v_max)^2 / (F_max * d);
    
    % calculate dimenionless takeoff time
    t_to_DL = calc_t_to_DL(mass_DL, m_spr_DL);
    
    % return dimension-ful takeoff time
    t_to =  t_to_DL .* d ./ v_max;
end

function t = calc_t_to_DL(mass, m_spr)
    t = pi() ./ 2 .* sqrt(mass + m_spr / 3);
end

%% Calculates position before t_to
function pos = calc_X_lt_t_to(t, F_max, d, v_max, mass, m_spr)
    % convert arguments -> dimensionless
    t_DL = t * v_max ./ d;
    mass_DL = mass .* (v_max)^2 / (F_max * d);
    m_spr_DL = m_spr * (v_max)^2 / (F_max * d);
    v_to_DL = calc_Vto_DL(mass_DL, m_spr_DL);
    
    % calculate dimenionless positions, from times
    x_DL = calc_X_DL_lt(v_to_DL, t_DL);
    
    % return dimension-ful positions array
    pos = x_DL .* d;
end

%% Calculates position after t_to
function pos = calc_X_gt_t_to(t, F_max, d, v_max, mass, m_spr)
    mass_DL = mass .* (v_max)^2 / (F_max * d);
    m_spr_DL = m_spr * (v_max)^2 / (F_max * d);
    v_to = calc_Vto_DL(mass_DL, m_spr_DL)
    t_to = calc_t_to_DL(mass_DL, m_spr_DL)
    x_to = calc_X_DL_lt(v_to, t_to)
    
    x_DL = calc_X_DL_gt(v_to, t, t_to, x_to);
    
    pos = x_DL .* d;
end

function x = calc_X_DL_lt(v_to, t)
    x = 1 - cos(v_to .* t);
end

function x = calc_X_DL_gt(v_to, t, t_to, x_to)
    x = x_to + (t - t_to) .* v_to;
end

%% Calculates position before t_to
function vel = calc_V_lt_t_to(t, F_max, d, v_max, mass, m_spr)
    % convert arguments -> dimensionless
    t_DL = t * v_max ./ d;
    mass_DL = mass .* (v_max)^2 / (F_max * d);
    m_spr_DL = m_spr * (v_max)^2 / (F_max * d);
    v_to_DL = calc_Vto_DL(mass_DL, m_spr_DL);
    
    % calculate dimenionless positions, from times
    v_DL = calc_V_DL_lt(v_to_DL, t_DL);
    
    % return dimension-ful positions array
    vel = v_DL .* v_max;
end

function v = calc_V_DL_lt(v_to, t)
    v = v_to * sin(v_to .* t);
end