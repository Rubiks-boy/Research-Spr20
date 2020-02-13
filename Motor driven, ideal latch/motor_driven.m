clearvars;
close all;

%% input parameters
F_max = 5;         % maximum motor force
d = 60;             % motor range of motion
v_max = 5;          % maximum motor velocity
opt_start = 1;      % optimization start value

% mass of the projectile
% values can go up to 10^1.68 = 48 for parameters above
mass = logspace(-1, 1, 100);

%% Make the plot
x = mass;
y = calc_Vto(F_max, d, v_max, mass, opt_start);
plot(x, y);
set(gca,'XScale', 'log');
set(gca,'YScale', 'log');
title('Motor-Driven Projectile Takeoff Velocity')
xlabel('mass');
ylabel('takeoff velocity');

%% Calculates takeoff velocities from input parameters
function vto = calc_Vto(F_max, d, v_max, mass, opt_start)
    % convert arguments -> dimensionless motor ranges of motion
    tau = mass .* (v_max ./ F_max);
    d_DL = d ./ (v_max .* tau);
    
    % calculate dimenionless takeoff velocities
    vto_DL = calc_Vto_DL(d_DL, opt_start);
    
    % return dimension-ful takeoff velocities
    vto =  vto_DL .* v_max;
end

%% calculates dimensionless takeoff velocity, given a motor range
function v = calc_Vto_DL(d, opt_start)
    v = 1 - exp(calc_Tto_DL(d, opt_start) .* -1);
end

%% calculates dimensionless takeoff time, given motor range
function tto = calc_Tto_DL(d, opt_start)
    opt_vec(1:length(d)) = opt_start;
    zerofunc = @(tto) (tto + exp(tto .* -1) - d - 1);
    
    tto = fsolve(zerofunc, opt_vec);
end