clearvars;
close all;

tic;
disp('Loading params from file');
p_d = load('params_eak');
toc;

tic;
disp('Non-dimensionalizing parameters');
p_dl = convert_to_dl(p_d);
toc;

tic
disp('Running calculations for motion of projectile');
max_vel_dl = ones(size(p_d.E, 2), size(p_d.A, 2));
% TODO: calculate max_vel literally any other way
for i=1:size(p_d.E, 2)
    if mod(i, 5) == 0
        fprintf('.');
    end
    
    for j=1:size(p_d.A, 2)
        p_dl_curr = p_dl;
        p_dl_curr.k = p_dl.k(i, j);
        max_vel_dl(i, j) = find_movement_dl(p_dl_curr).v(end);
    end
end
disp('')
toc

% tic
% results_d = convert_to_d(p_d, results);
% disp('Re-dimensionalized results');
% toc

plot_EAK(p_d, max_vel_dl);

function p_dl = convert_to_dl(p_d)
    p_dl = struct;
    
    p_dl.t_perc_above = p_d.t_perc_above;
    p_dl.num_times = p_d.num_times;
    
    p_dl.F_max = p_d.F_max;
    p_dl.v_max = p_d.v_max;
    p_dl.d = p_d.d; 
    
    [E, A] = meshgrid(p_d.E, p_d.A);
    p_dl.k = (E .* A / p_d.L) * p_d.d / p_d.F_max;
    
    p_dl.F_l = p_d.F_l / p_d.F_max;
    p_dl.m_l = p_d.m_l * p_d.v_max^2 / (p_d.F_max * p_d.d);
    p_dl.m_spr = p_d.m_spr * p_d.v_max^2 / (p_d.F_max * p_d.d);
    p_dl.m = p_d.m * p_d.v_max^2 / (p_d.F_max * p_d.d);
    p_dl.v0 = p_d.v0 / p_d.v_max;
    p_dl.R = p_d.R / p_d.d;
end

function results_d = convert_to_d(p_d, results)
    % NOT TESTED for eak - complete copy/pasta from xva
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

function plot_EAK(p_d, max_vel_dl)
    tic
    disp('displaying plot');
    KE = 0.5 * p_d.m * (max_vel_dl * p_d.v_max) .^ 2;
    figure(1);
    imagesc([p_d.E(1), p_d.E(end)], [p_d.A(1), p_d.A(end)], KE);
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    set(gca,'YDir','normal');
    colorbar;
    title('Projectile max KE');
    xlabel("Young's Modulus E [Pa]");
    ylabel('spring cross-sectional area [m^2]');
    toc
end