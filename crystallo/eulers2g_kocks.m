% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function g_mat = eulers2g_kocks(euler, varargin)
% from the book "Introduction to Texture Analysis: Macrotexture, 
% Microtexture and Orientation Mapping", by Randle and Engler (2000), p.27.

% euler: Euler Angles ([<Psi>, <Theta>, <phi>] - Kocks notation) in degrees.

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0 
    euler = randKocks;
end

euler = euler/180*pi; % deg2rad
Psi = euler(1);
Theta  = euler(2);
phi = euler(3);

c1 = cos(Psi);
c  = cos(Theta);
c2 = cos(phi);
s1 = sin(Psi);
s  = sin(Theta);
s2 = sin(phi);
g_mat(1,1) = c1*c2*c-s1*s2;
g_mat(1,2) = s1*c2*c+c1*s2;
g_mat(1,3) = -c2*s;
g_mat(2,1) = -c1*s2*c-s1*c2;
g_mat(2,2) = -s1*s2*c+c1*c2;
g_mat(2,3) = s2*s;
g_mat(3,1) = c1*s;
g_mat(3,2) = s1*s;
g_mat(3,3) = c;

if isrot(g_mat) == true
    return
else
    warning_commwin('Not a rotation matrix');
end

% Note : obtain transpose by exchanging phi and Psi

end