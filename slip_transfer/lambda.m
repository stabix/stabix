% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function lambdaValues = lambda(n1, d1, n2, d2, phi_c, kappa_c, varargin)
%% Function used to calculate the geometric compatibility function lambda,
% defined by Werner and Prantl (1990)
% DOI ==> 10.1016/0956-7151(90)90159-E
%
% author: d.mercier@mpie.de
%
% n1 = normal of first slip system
% d1 = Burgers vector of first slip system (= slip direction)
% n2 = normal of 2nd slip system
% d2 = Burgers vector of 2nd slip system (= slip direction)
%
% Werner and Prantl (1990):
%     lambdaValues = cosd(90 * phi/phi_c) * cosd(90 * kappa/kappa_c);
%
% with
%     phi = angle between normals
%     kappa = angle between slip directions
%     phi_c = critical angle between normals (15°)
%     kappa_c = critical angle between slip directions (45°)
%
% author: d.mercier@mpie.de

if nargin < 6
    kappa_c = 45; % Given in Werner and Prantl (1990) paper
end

if nargin < 5
    phi_c = 15; % Given in Werner and Prantl (1990) paper
end

if nargin == 0 % run test cases if called without arguments
    n1 = random_direction();
    d1 = orthogonal_vector(n1);
    n2 = random_direction();
    d2 = orthogonal_vector(n2);
    lambdaValues = lambda(n1,d1,n2,d2)
    return
end

check_vectors_orthogonality(n1, d1);
check_vectors_orthogonality(n2, d2);

cos_phi = cos_from_vectors(n1, n2);
cos_kappa = cos_from_vectors(d1, d2);

% Next checks used to avoid complex values returned
% by acosd function for phi and kappa calculations

if cos_phi > 1
    cos_phi = 1;
end
if cos_kappa > 1
    cos_kappa = 1;
end
if cos_phi < -1
    cos_phi = -1;
end
if cos_kappa < -1
    cos_kappa = -1;
end

phi = round(acosd(abs(cos_phi)));
kappa = round(acosd(abs(cos_kappa)));

% mod ==> 180° = 0°
phi = mod(phi,180);
kappa = mod(kappa,180);

if phi < phi_c && kappa < kappa_c
    lambdaValues = cosd(90 * phi/phi_c) * cosd(90 * kappa/kappa_c);
else
    lambdaValues = 0;
end

end