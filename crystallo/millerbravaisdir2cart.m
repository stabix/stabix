% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function vec = millerbravaisdir2cart(uvtw, c_over_a, varargin)
%% Function used to transform 4 Bravais-Miller indices of slip direction into cartesian notation
% from Hosford, "The Mechanics of Crystals and Textured Polycrystals", (1993), p. 207.
% uvtw : Indices of the direction
% c_over_a  : c/a ratio
% author: c.zambaldi@mpie.de

if nargin < 2
    c_over_a = latt_param('Ti', 'hcp');
    c_over_a = c_over_a(1);
end

if nargin < 1
    disp('Give at least a direction in Miller-Bravais notation');
    return
end

a_hcp = 1;
c_hcp = c_over_a;

%---- Calculate 3-digits form from d_hcp and n_hcp:
%         a2     CONVENTION USED HERE
%         |
%     Al--|--*
%     /   | / \
%    /    |/   \
%   *-----*-----*----a1
%    \         /
%     \       /
%      *-----Al
%
%       write(6,*) 'Calculating schmid_hcp...'
%       call flush(6)

u_hcp = uvtw(1);
v_hcp = uvtw(2);
t_hcp = uvtw(3);
w_hcp = uvtw(4);
% Calculate cartesian directions for hcp
x1 = (3.0/2.0)*u_hcp*a_hcp;
x2 = (sqrt(3.0)/2)*(2*v_hcp+u_hcp)*a_hcp;
x3 = w_hcp*c_hcp;
vec = [x1, x2, x3]';

% x_abs = a_hcp*sqrt(3.0*(u_hcp^2+u_hcp*v_hcp+v_hcp^2)+...
%     (c_hcp/a_hcp)^2*w_hcp^2);
% % 	  write(6,*) 'x_abs_hcp: ', x_abs,'; nsys:', i_sys
% % 	  write(6,*) 'x_abs should be: ', sqrt(x1**2+x2**2+x3**2)
% vec = [x1, x2, x3]'./x_abs;

end
