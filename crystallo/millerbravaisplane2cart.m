% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: millerbravaisplane2cart.m 1198 2014-08-05 09:13:00Z d.mercier $
function normal = millerbravaisplane2cart(hkil, c_over_a, varargin)
%% Function used to transform 4 Bravais-Miller indices of slip plane into cartesian notation
% from Hosford, "The Mechanics of Crystals and Textured Polycrystals", (1993), p. 207.
% hkil : Miller-Bravais indices of the plane
% c_over_a  : c/a ratio
% author: c.zambaldi@mpie.de

if nargin < 2
    c_over_a = latt_param('Ti', 'hcp');
    c_over_a = c_over_a(1);
end

if nargin < 1
    display('Give at least a direction in Miller-Bravais notation');
    return
end

a_hcp = 1;
c_hcp = c_over_a;

%---- Calculate 3-digits form from d_hcp and n_hcp:
%         a2     CONVENTION USED HERE
%         |
%      *--|--*
%     /   | / \
%    /    |/   \
%   *-----*-----*----a1
%    \         /
%     \       /
%      *-----*
%

h_hcp = hkil(1);
k_hcp = hkil(2);
i_hcp = hkil(3);
l_hcp = hkil(4);
% Calculate cartesian normals for hcp
x1 = h_hcp/a_hcp;
x2 = (2.0*k_hcp+h_hcp)/(sqrt(3.0)*a_hcp);
x3 = l_hcp/c_hcp;
normal = [x1, x2, x3]';

% x_abs = sqrt(x1^2+x2^2+x3^2);
% normal = [x1, x2, x3]'./x_abs;

end
