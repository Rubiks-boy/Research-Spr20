clearvars;
close all;

%% params for ideal latch, constant velocity (like pg 4 supplemental)
p1 = struct;
p1.m = logspace(-5, 5, 500);
p1.m_spr = 0.5;
p1.v0 = 1;
p1.F_l = 0;
p1.m_l = 1000000;
p1.R = 0.0001;
p1.num_times = 1000;
p1.t = linspace(0, 10, p1.num_times); % MUST start at 0
p1.t_perc_above = 1.2; % How far above t_to + t_l to find values for p1rojectile motion

%% params for slowly removed rounded latch (like pg 6 sup1p1lemental)
p2 = struct;
p2.m = logspace(-5, 5, 500);
p2.m_sp2r = 0.5;
p2.v0 = 0.2;
p2.F_l = 0;
p2.m_l = 1000000;
p2.R = 0.5;
p2.num_times = 1000;
p2.t = linspace(0, 10, p2.num_times); % MUST start at 0
p2.t_perc_above = 1.2; % How far above t_to + t_l to find values for p1rojectile motion

save('params', '-struct', 'p1');