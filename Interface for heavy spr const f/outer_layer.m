clearvars;
close all;

p_d = struct;
p_d.F_max = 20;                  % Max force the motor can provide
p_d.v_max = 5;                  % Fastest motor velocity
p_d.d = 0.005;                      % Range of motion of motor

p_d.m = logspace(-7, 3, 200) * (p_d.F_max * p_d.d / p_d.v_max^2);   % Mass range of projectiles to simulate
p_d.F_l = eps;                    % Force latch is pulled with
p_d.m_l = 9999999;                    % Mass of the latch
p_d.m_spr = 0.0001;                  % Mass of the spring
p_d.v0 = 0.25 * p_d.v_max;                     % Initial velocity of the latch
p_d.R = 0.002 * p_d.d;                      % Radius of the latch

p_d.num_times = 200;           % How many times to run on
p_d.t_perc_above = 1;         % How far above t_to + t_l to find values for motion


p_dl = convert_to_dl(p_d);

results = find_movement_dl(p_dl);

results_d = convert_to_d(p_d, results);

plot_xva(results_d);

function p_dl = convert_to_dl(p_d)
    p_dl = struct;
    
    p_dl.t_perc_above = p_d.t_perc_above;
    p_dl.num_times = p_d.num_times;
    
    p_dl.F_max = p_d.F_max;
    p_dl.v_max = p_d.v_max;
    p_dl.d = p_d.d; 
    
    p_dl.F_l = p_d.F_l / p_d.F_max;
    p_dl.m_l = p_d.m_l * p_d.v_max^2 / (p_d.F_max * p_d.d);
    p_dl.m_spr = p_d.m_spr * p_d.v_max^2 / (p_d.F_max * p_d.d);
    p_dl.m = p_d.m * p_d.v_max^2 / (p_d.F_max * p_d.d);
    p_dl.v0 = p_d.v0 / p_d.v_max;
    p_dl.R = p_d.R / p_d.d;
end

function results_d = convert_to_d(p_d, results)
    results_d = struct;
    
    results_d.t_l = results.t_l * p_d.d / p_d.v_max;
    results_d.v_to = results.v_to * p_d.v_max;
    results_d.t_to = results.t_to * p_d.d / p_d.v_max;
    results_d.y = results.y * p_d.d;
    results_d.t = results.t * p_d.d / p_d.v_max;
    results_d.x = results.x * p_d.d;
    results_d.v = results.v * p_d.v_max;
    results_d.a = results.a * p_d.v_max^2 / p_d.d;
    results_d.f = results.f * p_d.F_max;
end

function plot_xva(results)
    figure(1);
    x = results.x;
    v = results.v;
    f = results.f;
    x = x(:);
    v = v(:);
    f = f(:);
    
    x = x + (0:size(x)-1)'*1E-14;
    v = v + (0:size(v)-1)'*1E-14;

    [x, i] = sort(x);
    v = v(i);
    f = f(i);
    
    for i=1:size(v)
        if v(i) == Inf
            v(i) = 0;
        end
    end
    
    [X, V] = meshgrid(linspace(0, 1.5*0.005, 500), linspace(0, 10*5, 1000));
    inter = griddata(x, v, f, X, V);
    imagesc([min(X(1, :)), max(X(1, :))], [min(V(:, 1)), max(V(:, 1))], inter);
    set(gca,'YDir','normal');
    % TODO: Plot different masses
    % TODO: cut off plot
    colorbar;
end