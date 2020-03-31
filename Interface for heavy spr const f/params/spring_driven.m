clearvars;
close all;

p_d = struct;
p_d.F_max = 20;                     % Max force the motor can provide
p_d.v_max = 5;                      % Fastest motor velocity
p_d.d = 0.005;                      % Range of motion of motor

p_d.m = logspace(-7, 1, 250);       % Mass range of projectiles to simulate
p_d.F_l = eps;                      % Force latch is pulled with
p_d.m_l = 9999999;                  % Mass of the latch
p_d.m_spr = 0.0001;                 % Mass of the spring
p_d.v0 = 5;                         % Initial velocity of the latch
p_d.R = 0.0002;                     % Radius of the latch

p_d.num_times = 100;                % How many times to run on
p_d.t_perc_above = 1;               % How far above t_to + t_l to find values for motion

p_d.E = 1 * p_d.F_max / p_d.d;      % Young's modulus of the spring
p_d.A = 1;                          % Cross sectional area of the spring
p_d.L = 1;                          % Rest length of the spring

p_d.pic_width = 500;                % Width of outputted xva graph (number of data points)
p_d.pic_height = 500;               % Width of outputted xva graph (number of data points)
p_d.x_range = 0.006;                % Max position for x axis of xva graph
p_d.v_range = 30;                   % Max velocity for y axis of xva graph

p_d.mass_lines = [90, 100, 150];     % Creates lines along certain masses corresponding to indices given

save('params', '-struct', 'p_d');