function results = find_movement_dl(p)
    results = struct;
    
    %% calculates t_l, time of latch release
    % do this for all masses (this is ok since previous expressions don't
    % depend on mass)
    num_times = p.num_times;
    [q, num_mass] = size(p.m);

    t_l = ones(size(p.m));
    
    for m=1:num_mass
        opt_start = -eps;
        opt_vec = ones(size(m)) * opt_start;
        zero_func = @(t) ((p.m(m) + p.m_spr/3) .* calc_a_latched_t(p, t) + p.k * (calc_x_latched_t(p, t) - 1));

        % checks if the latch is moving at greater than the philir velocity
        % (philir.pdf in posm g-drive)
        % note that curvature kappa = 1/R
        if p.v0^2 >= p.R / (p.m(m) + p.m_spr / 3) * p.k
            t_l(m) = 0;
        else
            t_l(m) = fzero(zero_func, opt_vec);
        end
    end
    
    results.t_l = abs(t_l);

    %% calculate v_to: velocity when projectile loses contact with spring
    xl = calc_x_latched_t(p, t_l);
    vl = calc_v_latched_t(p, t_l);
    v_to = sqrt(vl.^2 + p.k ./ (p.m + p.m_spr / 3) .* (1 - xl).^2);

    results.v_to = v_to;

    %% Calculates t_to, time of projectile release
    t_to = ones(1, num_mass);

    for i=1:num_mass
        m = p.m(i);
        m_sqrt = sqrt(m + p.m_spr / 3);

        phi = atan(m_sqrt * vl(i) / (1 - xl(i))) - (t_l(i)) ./ m_sqrt;

        t_to(i) = m_sqrt * (pi / 2 - phi);
    end

    results.t_to = t_to;

    %% use t_to to find time ranges for a given mass
    p.t = ones(num_mass, p.num_times);
    for i=1:num_mass
        p.t(i, :) = (linspace(0, (t_to(i)) * p.t_perc_above, p.num_times))';
    end

    %% y (horizontal) position of latch, wrt time
    y = struct();
    y.y = calc_y(p, p.t);
    y.y_dot = calc_y_dot(p, p.t);
    y.y_ddot = calc_y_ddot(p, p.t);

    results.y = y.y;

    %% x position of projectile while in contact w/latch
    x_latch = struct();
    x_latch.x = calc_x_latched(p, y);

    % v of projectile while in contact w/latch
    x_latch.v = calc_v_latched(p, y);

    % a of projectile while in contact w/latch
    x_latch.a = calc_a_latched(p, y);

    %% position after latch release
    x_r = (ones(1, num_times))' * (1 * ones(1, num_mass));
    v_r = x_r;
    a_r = x_r;

    for i=1:num_mass
        m = p.m(i);
        m_sqrt = sqrt((m + p.m_spr / 3) / p.k);

        phi = atan(m_sqrt * vl(i) / (1 - xl(i))) - (t_l(i)) ./ m_sqrt;
        x_r(:, i) = 1 - (v_to(i) * m_sqrt * cos(p.t(i, :) / m_sqrt + phi));
        v_r(:, i) = v_to(i) * sin(p.t(i, :) / m_sqrt + phi);
        a_r(:, i) = v_to(i) / m_sqrt * cos(p.t(i, :) / m_sqrt + phi);
    end

    % kinematics while in contact with latch
    % we will remove any values after t_l
    x_l = x_latch.x';
    v_l = x_latch.v';
    a_l = x_latch.a';

    for m=1:num_mass
        for t=1:num_times
            if p.t(m, t) >= t_l(m)
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
            curr_diff = abs(t_to(m) - p.t(m, t));
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
            if p.t(m, t) < t_l(m)
                x_r(t, m) = 0;
                v_r(t, m) = 0;
                a_r(t, m) = 0;
            end
            if p.t(m, t) > t_to(m)
                x_r(t, m) = xto(m) + vto(m) * (p.t(m, t) - t_to(m));
                v_r(t, m) = vto(m);
                a_r(t, m) = 0;
            end
        end
    end
    
    results.t = p.t;
    results.x = (x_l + x_r)';
    results.v = (v_l + v_r)';
    results.a = (a_l + a_r)';
    results.f = (repmat(p.m, [num_times 1]) .* (a_l + a_r))';
end

%% Calculations of latch movement
function y = calc_y(p, t)
    y = min(p.v0 * t + 0.5 * p.F_l / p.m_l * (t.^2), p.R - eps);
end

function y_dot = calc_y_dot(p, t)
    y_dot = p.v0 + p.F_l / p.m_l * t;
end

function y_ddot = calc_y_ddot(p, t)
    y_ddot = p.F_l / p.m_l;
end

%% Calculations of projectile movement while latched
% the following assume that the y struct has not ben run;
% it will calculate for a specific time
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

% the following assume that the y struct has been run for all times
% this is a small optimization so that we aren't repeatedly running latch
% movement
function x = calc_x_latched(p, y)
    x = p.R * (1 - sqrt(1 - (y.y / p.R).^2));
end

function v = calc_v_latched(p, y)
    v = y.y .* y.y_dot ./ (p.R * sqrt(1 - (y.y / p.R).^2));
end

function a = calc_a_latched(p, y)
    a = 1 ./ (p.R * sqrt(1 - (y.y / p.R).^2)) .* (y.y_dot.^2 + y.y .* y.y_ddot + y.y.^2 .* y.y_dot.^2 ./ (p.R^2 - y.y.^2));
end