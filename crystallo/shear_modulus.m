% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function G = shear_modulus(nu, E, varargin)
% E : Young's modulus in TPa
% nu: Poisson's coefficient
% G : Shear modulus in TPa

% author: d.mercier@mpie.de

if nargin < 2
    compliances = compliance_to_stiffnesse;
    C12 = compliances(2);
    C44 = compliances(5);
    E = C44*(3*C12 + 2*C44)/(C12 + C44);
    nu = coeff_poisson(C12, C44);
end

G = E/(2*(1+nu));

end