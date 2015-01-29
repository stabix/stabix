% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function EY = youngs_modulus(struct, elast_const, euler, varargin)
%% Function used to calculate elastic modulus to find compliance mismatch in three principal directions
% struct: : hcp, bcc or fcc
% elast_const: [S11 S12 S13 S33 S44 S66] in 1/TPa;
% EY: Young's modulus in GPa

% From J.F. Nye, "Physical properties of crystals - Their representation by
% tensors and matrices." (1985) Oxford Univ. Presse (p. 144-145)
% ISBN-13: 978-0198511656  ISBN-10: 0198511655

% author: d.mercier@mpie.de

if nargin < 3
    euler = [0,0,0];
end

if nargin < 2
    elast_const = elastic_constants;
    struct = 'hcp';
end

% Calculation of rotation matrix from Euler angles
rot_mat = eulers2g(euler);

elast_const = elast_const*1e-3; % TPa to GPa

% Preallocation of EY variable
EY(1:3) = NaN;

if strcmp(struct, 'bcc') || strcmp(struct, 'fcc')
    % E(cube) = ( s11 - 2*(s11 - s12 - s44/2)*(x^2*y^2 + y^2*z^2 + z^2*x^2) )^-1
    for ii = 1:1:3
        EY(ii) = 1./(elast_const(1) - 2*(elast_const(1) - elast_const(2) - elast_const(5)/2) *...
            (rot_mat(1,ii)^2*rot_mat(2,ii)^2 + rot_mat(2,ii)^2*rot_mat(3,ii)^2 + rot_mat(3,ii)^2*rot_mat(1,ii)^2) );
    end
    
elseif strcmp(struct, 'hcp')
    % E(hex)  = ( s11 * (1-z^2)^2 + s33 * z^4 + (s44 + 2*s13)*(1-z^2)*z^2 )^-1
    for ii = 1:1:3
        EY(ii) = 1./(elast_const(1) * (1-rot_mat(3,ii)^2)^2 + elast_const(4) * rot_mat(3,ii)^4 +...
            (elast_const(5) + 2*elast_const(3))*(1-rot_mat(3,ii)^2)*rot_mat(3,ii)^2 );
    end
    
elseif strcmp(struct, 'orth')  % needs a different structure for the elast_const matrix - needs more terms, not working in this version.
    % E(orth) = ( s11*x^4 + 2s12*x^2*y^2 + 2s13*x^2*y^2 + s22*y^4 + 2s23*y^2*z^2 + s33*z^4 + s44*y^2*z^2 + s55*x^2*z^2 + s66*y^2*z^2 )^-1*100
    
elseif strcmp(struct, 'tet')
    % E(tetr) = ( s11 * (x^4 + y^4) + s33 * z^4 + (s66 + 2*s12)*x^2*y^2 + (2*s13 + s44) * z^2 * (y^2* + x^2) )^-1*100
    for ii = 1:1:3
        e1 = elast_const(1)*(rot_mat(1,ii)^4 + rot_mat(2,ii)^4) + elast_const(4)*rot_mat(3,ii)^4;
        e2 = (2*elast_const(2) + elast_const(6))*(rot_mat(1,ii)^2 * rot_mat(2,ii)^2);
        e3 = (2*elast_const(3) + elast_const(5))*rot_mat(3,ii)^2 * (rot_mat(1,ii)^2 + rot_mat(2,ii)^2);
        EY(ii) = 1./(e1+e2+e3);
    end
end

end