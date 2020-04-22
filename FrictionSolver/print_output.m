clearvars;
close all;

file = fopen('output.txt', 'r');
disp(fgetl(file));

% format = '%f %f';
% size = [2 Inf];

format = '%f %f %f';
data_size = [3 Inf];

A = fscanf(file, format, data_size)';
plot(A(:, 1), A(:, 2))
fclose(file);