clearvars;
close all;

p_d = struct;
p_d.F_max = 20;                     % Max force the motor can provide
p_d.v_max = 5;                      % Fastest motor velocity
p_d.d = 0.005;                      % Range of motion of motor

p_d.m = 1;                          % Mass of projectile to simulate
p_d.F_l = eps;                      % Force latch is pulled with
p_d.m_l = 9999999;                  % Mass of the latch
p_d.rho_spr = 1E6;                  % Mass density of the spring (per unit volume)
p_d.sigma_spr = 1E6;                % Max stress on spring (Force per area)
p_d.v0 = 5;                         % Initial velocity of the latch
p_d.R = 0.0002;                     % Radius of the latch

p_d.num_times = 100;                % How many times to run on
p_d.t_perc_above = 1;               % How far above t_to + t_l to find values for motion

p_d.E = logspace(4, 8, 250);        % Young's modulus of the spring
p_d.A = logspace(-6, -3, 250);      % Cross sectional area of the spring
p_d.L = 0.01;                       % Rest length of the spring

p_d.pic_width = 500;                % Width of outputted xva graph (number of data points)
p_d.pic_height = 500;               % Width of outputted xva graph (number of data points)

save('params_eak', '-struct', 'p_d');