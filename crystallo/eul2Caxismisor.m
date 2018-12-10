% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function  caxis_misor = eul2Caxismisor(euler1, euler2, varargin )
%% Function used to calculate c-axis misorientation for HCP material
% euler1 : Euler angles of grain 1 in degrees
% euler2 : Euler angles of grain 2 in degrees

% author: suyang@egr.msu.edu

caxis = [0 0 1];
if nargin < 2
    euler1 = randBunges; disp(euler1);
    euler2 = randBunges; disp(euler2);
end

g1 = eulers2g(euler1);  %rotation matrix of grain 1
g2 = eulers2g(euler2);  %rotation matrix of grain 2

caxis1 = caxis*g1;
caxis2 = caxis*g2;

caxis_misor = acos(dot(caxis1, caxis2)/(norm(caxis1)*norm(caxis2)));

caxis_misor = caxis_misor*180/pi;  % rad2deg

% Wrong if mod is used
if caxis_misor > 90
    caxis_misor = 180 - caxis_misor;
end

end