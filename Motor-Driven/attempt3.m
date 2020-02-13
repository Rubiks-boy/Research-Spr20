clearvars;
close all;

% input parameters
Fmax = 20;
d = 60;
vmax = 5;
% values can go from approx 0.50 to 48
mass = logspace(-.3, 1.68, 100);
% mass = 10;

% time constants that depend on those constants
tau = mass * (vmax / Fmax);
invtau = tau .^ (-1);

% make the plot
calcTto(d)
timeFromDimless(calcTto)
calcVto()

semilogx(mass, calcVto)

% get velocities
function v = calcVto
    v = velFromDimless(1 - exp(calcTto() .* -1));
end

% calculate takeoff time (dimensionless)
function tto = calcTto(d)
    zerofunc = @(ttoDl) (ttoDl + exp(ttoDl .* -1) - distToDimless(d));
    tto = fzero(zerofunc, [0, 100]);
end

% function zf = zerofunc(ttoDl)
%     zf = ttoDl + exp(ttoDl .* -1) - distToDimless(d);
% end

% convert from dimension to dimensionless
% function t = timeToDimless(time)
%     t = (time) ./ tau;
% end
% 
% function v = velToDimless(vel)
%     v = vel ./ vmax;
% end

function x = distToDimless(dist, vmax, tau)
    x = dist ./ (vmax * tau);
end

% convert from dimensionless to dimension
function t = timeFromDimless(time, tau)
    t = time .* tau;
end

function v = velFromDimless(vel, vmax)
    v = vel .* vmax;
end
% 
% function x = distFromDimless(dist)
%     x = dist .* (vmax * tau);
% end