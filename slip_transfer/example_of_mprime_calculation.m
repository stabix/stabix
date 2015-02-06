% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function example_of_mprime_calculation
%% Example of function used to calculate mprime parameter

% author: d.mercier@mpie.de

%% Data of user
euler_1 = [0 0 0]; % Bunge notation (in degrees)
euler_2 = [0 45 0]; % Bunge notation (in degrees)
incoming_slip = [0  0  0  1 ; 2 -1 -1  0];
outgoing_slip = [0  0  0  1 ; 2 -1 -1  0];
material = 'Mg';
phase = 'hcp';

%% Calculations
% Eulers angle to rotation matrix
rot_mat1 = eulers2g(euler_1);
rot_mat2 = eulers2g(euler_2);

% Lattice parameters
ca_ratio = latt_param(material, phase);

if strcmp(phase, 'hcp') == 1
    % Miller-Bravais to Cartesian coordinates
    n1_cart = millerbravaisplane2cart(incoming_slip(1,:), ca_ratio(1))';
    d1_cart = millerbravaisdir2cart(incoming_slip(2,:), ca_ratio(1))';
    n2_cart = millerbravaisplane2cart(outgoing_slip(1,:), ca_ratio(1))';
    d2_cart = millerbravaisdir2cart(outgoing_slip(2,:), ca_ratio(1))';
end

% Apply rotation matrix to slip systems
n1_cart_rot = rot_mat1.'*n1_cart';
d1_cart_rot = rot_mat1.'*d1_cart';
n2_cart_rot = rot_mat2.'*n2_cart';
d2_cart_rot = rot_mat2.'*d2_cart';

% Normalization of input vectors
n1 = n1_cart_rot ./ norm(n1_cart_rot);
n2 = n2_cart_rot ./ norm(n2_cart_rot);
d1 = d1_cart_rot ./ norm(d1_cart_rot);
d2 = d2_cart_rot ./ norm(d2_cart_rot);

% Check of orthogonality
check_vectors_orthogonality(n1, d1);
check_vectors_orthogonality(n2, d2);

% Get cosine from the dot product
cosine_n = cos_from_vectors(n1, n2);
cosine_d = cos_from_vectors(d1, d2);

% Get angle from cosine
phi = ang_from_vectors(n1, n2);
kappa = ang_from_vectors(d1, d2);

% m' calculation
mp = cosine_n * cosine_d;

%% Display
commandwindow;
display(euler_1');
display(euler_2');
display(incoming_slip);
display(outgoing_slip);
display(phi);
display(kappa);
display(mp);

end