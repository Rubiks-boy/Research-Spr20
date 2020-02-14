clearvars;
close all;

p = struct;
p.m = logspace(-5, 5, 100);
% p.m = 5;
p.m_spr = 0.5;
p.v0 = 1;
p.F_l = 0;
p.m_l = 1000000;
p.R = 8;
p.t = linspace(0, 10, 1000);

save('params', '-struct', 'p');