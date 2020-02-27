clearvars;
close all;

p_d = struct;
p_d.F_max = 20;                  % Max force the motor can provide
p_d.v_max = 5;                  % Fastest motor velocity
p_d.d = 0.005;                      % Range of motion of motor

p_d.m = logspace(-7, 3, 1000);   % Mass range of projectiles to simulate
p_d.F_l = eps;                    % Force latch is pulled with
p_d.m_l = 9999999;                    % Mass of the latch
p_d.m_spr = 0.0001;                  % Mass of the spring
p_d.v0 = 0.25;                     % Initial velocity of the latch
p_d.R = 0.002;                      % Radius of the latch

p_d.num_times = 1000;           % How many times to run on
p_d.t_perc_above = 1;         % How far above t_to + t_l to find values for motion

p_d.pic_size = 500;             % Size (width + height) of outputting xva graph
p_d.x_range = 0.006;            % Max position for x axis of xva graph
p_d.v_range = 30;               % Max velocity for y axis of xva graph

save('params', '-struct', 'p_d');