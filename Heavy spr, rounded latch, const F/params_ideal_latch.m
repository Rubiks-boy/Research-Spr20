clearvars;
close all;

%% params for ideal latch, constant velocity (like pg 4 supplemental)
p = struct;
p.m = logspace(-5, 5, 500);
p.m_spr = 0.5;
p.v0 = 0.25;
p.F_l = 0;
p.m_l = 1000000;
p.R = 0.0001;
p.num_times = 1000;
p.t = linspace(0, 10, p.num_times); % MUST start at 0
p.t_perc_above = 1.2; % How far above t_to + t_l to find values for projectile motion

save('params', '-struct', 'p');