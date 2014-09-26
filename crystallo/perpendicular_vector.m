% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function ov = perpendicular_vector(vec)
%% after MTEX/geometry/orth
% an arbitrary (normalized) orthogonal vector

% author: c.zambaldi@mpie.de

% convention:
% (x,y,z) -> (-y,x,0)
% (0,y,z) -> (1,0,0)

%v.y(isnull(v.x)) = -1;
%ov = vector3d(-v.y,v.x,zeros(size(v)));
%ov = ov ./norm(ov);

if vec(1) == 0
    vec(2) = -1;
end

ov = [-vec(2); vec(1); 0];
ov = ov ./ norm(ov);

return