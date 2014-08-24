% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: unitstress.m 1198 2014-08-05 09:13:00Z d.mercier $
function T = unitstress(ax)
%% Function used to return a 3x3 zero matrix with 1 for component(ax,ax)
% give negative "ax" for compressive stress
% author: c.zambaldi@mpie.de

if nargin == 0
    ax = 3;
end

if ax < 0
    sig = -1;
    ax = abs(ax);
else
    sig = 1;
end

T = zeros(3,3);
T(ax,ax) = 1;
T = T * sig; % tension or compression

return