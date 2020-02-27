clearvars;
close all;

p_d = load('params');

x = 1
tic
p_dl = convert_to_dl(p_d);
toc
x = 2
tic
results = find_movement_dl(p_dl);
toc
x = 3
tic
results_d = convert_to_d(p_d, results);
toc
x = 4
tic
plot_xva(p_d, results_d);
toc

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

function plot_xva(p_d, results)
    tic
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
    
    for i=1:size(v)
        if v(i) == Inf
            v(i) = 0;
        end
    end
    toc
    tic
    
    [X, V] = meshgrid(linspace(0, p_d.x_range, 500), linspace(0, p_d.v_range, 500));
    inter = griddata(x, v, f, X, V);
    
    toc
    x = 6
    tic
    
    for i=1:p_d.pic_size
        for j=1:p_d.pic_size
            if p_d.x_range / p_d.pic_size * j > p_d.d
                inter(i, j) = 0;
            end
            for k=1:1000
                if p_d.v_range / p_d.pic_size * j < results.x(1, k) && 30 / p_d.pic_size * i > results.v(1, k)
                    inter(i, j) = 0;
                    break;
                end
            end
        end
    end
    
    toc

    tic
    imagesc([min(X(1, :)), max(X(1, :))], [min(V(:, 1)), max(V(:, 1))], inter);
    set(gca,'YDir','normal');
    colorbar;
    toc
end