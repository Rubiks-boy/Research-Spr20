% get velocities
function v = getVto
    v = velFromDimless(1 - exp(calcTto .* -1));
end

% calculate takeoff time (dimensionless)
function tto = calcTto
    tto = fzero(@zerofunc, [0, 100]);
end

function zf = zerofunc(tto)
    dDl = distToDimless(d);
    zf = tto + exp(tto .* -1) - dDl;
end

% constants
function m = mass()
    m = logspace(-1, 2)
    m = 10;
end

function f = Fmax
    f = 20;
end

function d1 = d
    d1 = 600;
end

function v = vmax
    v = 5;
end

% constants that depend on those constants
function t = tau
    t = mass() * vmax / Fmax;
end

function t = invtau
    t = tau() .^ (-1);
end

% convert from dimension to dimensionless
function t = timeToDimless(time)
    t = (time) ./ tau;
end

function v = velToDimless(vel)
    v = vel ./ vmax;
end

function x = distToDimless(dist)
    x = dist ./ (vmax * tau);
end

% convert from dimensionless to dimension
function t = timeFromDimless(time)
    t = (time) .* tau;
end

function v = velFromDimless(vel)
    v = vel .* vmax;
end

function x = distFromDimless(dist)
    x = dist .* (vmax * tau);
end

% semilogx(mass, getTto);