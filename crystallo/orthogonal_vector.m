% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function ov = orthogonal_vector(vIn, varargin)
% after MTEX geometry/orth
% an arbitrary (normalized) orthogonal vector
%
% convention:
% (x,y,z) -> (-y,x,0)
% (0,y,z) -> (1,0,0)

% author: c.zambaldi@mpie.de

%v.y(isnull(v.x)) = -1;
%ov = vector3d(-v.y,v.x,zeros(size(v)));
%ov = ov ./norm(ov);

if nargin == 0
    vIn = [1,0,0]; display(vIn);
end

if vIn(1) == 0
    vIn(2) = -1;
end

ov = [-vIn(2),vIn(1),0];
ov = ov./norm(ov);

return