clearvars;
close all;

tic;
p_d = load('params');
disp('Loaded params from file');
toc;

tic;
p_dl = convert_to_dl(p_d);
disp('non-dimensionalized parameters');
toc;

tic
results = find_movement_dl(p_dl);
disp('Ran calculations for motion of projectile');
toc

% tic
% results_d = convert_to_d(p_d, results);
% disp('Re-dimensionalized results');
% toc

plot_xva(p_d, results);

function p_dl = convert_to_dl(p_d)
    p_dl = struct;
    
    p_dl.t_perc_above = p_d.t_perc_above;
    p_dl.num_times = p_d.num_times;
    
    p_dl.F_max = p_d.F_max;
    p_dl.v_max = p_d.v_max;
    p_dl.d = p_d.d; 
    
    p_dl.k = (p_d.E * p_d.A / p_d.L) * p_d.d / p_d.F_max;
    
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

function plot_xva(p_d, results)
    tic;
    figure(1);
    x = results.x;
    v = results.v;
    f = results.f;
    f(1, :) = f(1, :);
    x = x(:);
    v = v(:);
    f = f(:);
    
    x = x + (0:size(x)-1)'*1E-14;
    v = v + (0:size(v)-1)'*1E-14;

    [x, i] = sort(x);
    v = v(i);
    f = f(i);
    
    x = x(x <= p_d.x_range / p_d.d);
    v = v(1:size(x));
    f = f(1:size(x));
    
    v(find(v == Inf)) = 0;
    
    disp('Prepared data for interpolation');
    toc;
    
    tic;
    % Performs the interpolation on the dimensionless data
    % For whatever reason, the dimensionless data leads to much smoother
    % graphs. We'll add dimensions back in after the interpolation
    [X, V] = meshgrid(linspace(0, p_d.x_range / p_d.d, p_d.pic_width), linspace(0, p_d.v_range / p_d.v_max, p_d.pic_height));
    inter = griddata(x, v, f, X, V);
    disp('Done with interpolation');
    toc
    
    tic
    % remove any indices too far right on the x axis to be in range
    num_in_range = floor(p_d.d / p_d.x_range * p_d.pic_width);
    in_range = [true(num_in_range, p_d.pic_height); false(p_d.pic_width - num_in_range, p_d.pic_height)]';
    inter = inter .* in_range;
    
    % use the lowest mass as a line for the upper-left corner of the graph
    % (any points left & up from this line should be removed)
    first_mass_X = linspace(0, 1, p_d.pic_width);
    first_mass_V = interp1(results.x(1, :), results.v(1, :), first_mass_X);
    
    for k=1:p_d.pic_width
        inter(V > first_mass_V(k) & X < first_mass_X(k)) = 0;
    end
    
    disp('Zeroed data outside logical range');
    toc

    tic
    X = X * p_d.d;
    V = V * p_d.v_max;
    inter = inter * p_d.F_max;
    disp('Added dimensions to interpolation');
    toc
    
    tic
    imagesc([min(X(1, :)), max(X(1, :))], [min(V(:, 1)), max(V(:, 1))], inter);
    set(gca,'YDir','normal');
    colorbar;
    title('Force on projectile');
    xlabel('Position (m)');
    ylabel('Velocity (m/s)');
    disp('Displaying plot');
    hold on;

    % Add lines for particular masses
    for i=1:size(p_d.mass_lines')
        plot(results.x(p_d.mass_lines(i), :) * p_d.d, results.v(p_d.mass_lines(i), :) * p_d.v_max, 'g', 'LineWidth', 2);
    end
    toc
end