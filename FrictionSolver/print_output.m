file = fopen('output.txt', 'r');
disp(fgetl(file));
A = fscanf(file,'%f %f', [2 Inf])';
plot(A(:, 1), A(:, 2))
fclose(file);