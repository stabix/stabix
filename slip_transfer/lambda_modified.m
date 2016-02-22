% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function lambdaValues = lambda_modified(l1, d1, l2, d2, theta_c, kappa_c, varargin)
%% Function used to calculate the geometric compatibility function lambd1,
% defined by Werner and Prantl (1990) modified by Beyerlein et al. (2012)
% DOI ==> 10.1016/0956-7151(90)90159-E / DOI ==> 10.1007/s11837-012-0431-0
%
% author: d.mercier@mpie.de
%
% l1 = slip plane intersection with the grain boundary
% d1 = Burgers vector of first slip system (= slip direction)
% l2 = slip plane intersection with the grain boundary
% d2 = Burgers vector of 2nd slip system (= slip direction)
%
% Beyerlein et al. (2012):
%     lambdaValues = cosd(90 * theta/theta_c) * cosd(90 * kappa/kappa_c);
%
% with
%     theta = angle between the two slip plane intersections with the grain boundary
%     kappa = angle between slip directions
%     theta_c = critical angle between the two slip plane intersections with the grain boundary (15°)
%     kappa_c = critical angle between slip directions (45°)
%
% author: d.mercier@mpie.de

if nargin < 6
    kappa_c = 45; % Given in Werner and Prantl (1990) paper
end

if nargin < 5
    theta_c = 15; % Given in Werner and Prantl (1990) paper
end

if nargin == 0 % run test cases if called without arguments
    l1 = random_direction();
    d1 = orthogonal_vector(l1);
    l2 = random_direction();
    d2 = orthogonal_vector(l2);
    lambdaValues = lambda(l1,d1,l2,d2)
    return
end

check_vectors_orthogonality(l1, d1);
check_vectors_orthogonality(l2, d2);

cos_theta = cos_from_vectors(l1, l2);
cos_kappa = cos_from_vectors(d1, d2);

% Next checks used to avoid complex values returned
% by acosd function for theta and kappa calculations

if cos_theta > 1
    cos_theta = 1;
end
if cos_kappa > 1
    cos_kappa = 1;
end
if cos_theta < -1
    cos_theta = -1;
end
if cos_kappa < -1
    cos_kappa = -1;
end

theta = round(acosd(abs(cos_theta)));
kappa = round(acosd(abs(cos_kappa)));

% mod ==> 180° = 0°
theta = mod(theta,180);
kappa = mod(kappa,180);

if theta < theta_c && kappa < kappa_c
    lambdaValues = cosd(90 * theta/theta_c) * cosd(90 * kappa/kappa_c);
else
    lambdaValues = 0;
end

end