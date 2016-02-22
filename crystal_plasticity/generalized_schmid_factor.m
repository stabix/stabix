% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function GSF = generalized_schmid_factor(g, d, n, sigma, testFlag, varargin)
%% Function used to calculate the generalized schmid factor
% Calculates the generalized Schmid factor from :
% From C.N. Reid," Deformation Geometry for Materials Scientists, Pergamon Press, Oxford, United Kingdom, 1973 (p.156).
% See in Y. S. Choi, H. R. Piehler, A. D. Rollett, "Formation of mesoscale
% roughening in 6022-T4 Al sheets deformed in plane-strain tension",
% Metallurgical and Materials Transactions A, February 2004, Volume 35, Issue 2, pp 513-524
% See in M. Battaini, E.V. Pereloma, C.H.J. Davies, "Orientation Effect on
% Mechanical Properties of Commercially Pure Titanium at Room Temperature"
% Metallurgical and Materials Transactions A, February 2007, Volume 38, Issue 2, pp 276-285
% See in T. R. Bieler et al., "Grain boundaries and interfaces in slip
% transfer.", Current Opinion in Solid State and Materials Science, July 2014.

% The Schmid factor is formally defined only for uniaxial tension. A generalized
% Schmid factor, which describes the shear stress on a given slip system, can be
% computed from any stress tensor based on the Frobenius norm of the tensor.

% n : normal of slip system
% d : slip direction
% sigma : stress tensor
% g : rotation matrix
%
% gsgT = g*sigma_n*g.' ==> rotated stress tensor
% GSF = b.gsgT.(n)^-1

% authors: d.mercier@mpie.de/bieler@egr.msu.edu

%% Setting if no argument or less than 5
if nargin < 5
    testFlag = false;
end

if nargin == 0
    fprintf('Generalized_schmid_factor called without arguments.\n')
    fprintf('Running some tests with random input ...\n')
    for ii = 1:1:1000
        ind = randi(57);
        hcp_slip_system = slip_systems;
        n_bravais_miller = hcp_slip_system(1,:,ind);
        d_bravais_miller = hcp_slip_system(2,:,ind);
        n = millerbravaisplane2cart(n_bravais_miller)'; % n = rand(1,3);
        d = millerbravaisdir2cart(d_bravais_miller)';   % d = cross(n,rand(1,3));
        sigma = randi(3,3);
        eulers = randBunges;
        g = eulers2g(eulers);
    end
    testFlag = true;
end

%% Normalize the input vectors - you never know...
n = n/norm(n);
d = d/norm(d);

sigma_n = sigma/norm(sigma,'fro');  % Frobenius normalization

tol = 1e-9; % tolerance for tests and for checking if normals and directions are perpendicular;
test_vectors_orthogonality(n, d, tol);

gsgT = g * sigma_n * g';

% GSF = d * gsgT * n';
GSF = dot(d * gsgT, n);

if testFlag
    fprintf('Euler angles = [%.3f %.3f %.3f]\n', eulers);
    fprintf(['Rotation matrix = ' ...
        '[%.3f %.3f %.3f\n %.3f %.3f %.3f\n %.3f %.3f %.3f]\n '], g);
    fprintf('Generalized Schmid Factor = %.4f\n', GSF);
end

tol_GSF = 0.5; % tolerance for tests and for checking if GSF<=0.5;

if abs(GSF) > tol_GSF
    % Generalized Schmid factors are greater than 0.5 in some instances because the
    % grain average stress tensor differs significantly from uniaxial tension.
    warning_commwin('Generalized Schmid Factor > 0.5 !');
end

end
