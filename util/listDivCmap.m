% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [RGB1, RGB2] = listDivCmap(numDivCmap)
% See http://www.kennethmoreland.com/color-advice/

if numDivCmap == 1
    RGB1 = [0.230 0.299 0.754];
    RGB2 = [0.706 0.016 0.150];
elseif numDivCmap == 2
    RGB1 = [0.436 0.308 0.631];
    RGB2 = [0.759 0.334 0.046];
elseif numDivCmap == 3
    RGB1 = [0.085 0.532 0.201];
    RGB2 = [0.436 0.308 0.631];
elseif numDivCmap == 4
    RGB1 = [0.217 0.525 0.910];
    RGB2 = [0.677 0.492 0.093];
elseif numDivCmap == 5
    RGB1 = [0.085 0.532 0.201];
    RGB2 = [0.758 0.214 0.233];
end

end