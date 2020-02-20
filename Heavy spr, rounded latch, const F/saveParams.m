clearvars;
close all;

p = struct;
p.m = logspace(-5, 5, 1000);
% p.m = 5;
p.m_spr = 0.5;
p.v0 = 1;
p.F_l = 0;
p.m_l = 1000000;
p.R = 3;
p.num_times = 1000;
p.t = linspace(0, 10, p.num_times); % MUST start at 0
% TODO: find dynamically based on system parameters (find t_l and t_to, max
% is the max of both added together)

save('params', '-struct', 'p');