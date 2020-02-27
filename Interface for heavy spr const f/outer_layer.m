clearvars;
close all;

%% params for slowly removed rounded latch (like pg 6 supplemental)
p = struct;
p.m = logspace(-5, 5, 500);
p.m_spr = 0.5;
p.v0 = 0.25;
p.F_l = 0;
p.m_l = 1000000;
p.R = 1;
p.num_times = 1000;
p.t = linspace(0, 10, p.num_times); % MUST start at 0
p.t_perc_above = 1.2; % How far above t_to + t_l to find values for projectile motion

results = find_movement_dl(p);

plot_xva(results);

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
    
    [X, V] = meshgrid(linspace(0, 1.5, 500), linspace(0, 1.5, 1000));
    inter = griddata(x, v, f, X, V);
    imagesc([min(X(1, :)), max(X(1, :))], [min(V(:, 1)), max(V(:, 1))], inter);
    set(gca,'YDir','normal');
    % TODO: Plot different masses
    % TODO: cut off plot
    colorbar;
end