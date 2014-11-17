% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function test_GSF_RSS(eulers, d, n, T, testFlag, varargin)
%% Function used to test/compare "Generalized Schmid Factor" and "Resolved Shear Stress"
% eulers: Bunge Euler angles in degrees
% d: slip direction
% n: slip plane normal
% T: stress in sample coordinate system
% author: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin < 5
    testFlag = false;
end

if nargin < 4
    T = unitstress(3); % Tensile test in z direction
end

if nargin < 3
    slip_systems_indices = slip_systems('hcp', 9);
    testFlag = true;
end

if nargin == 0
    eulers = randBunges;
end

g = eulers2g(eulers); % Calculation of the rotation matrix

if testFlag
        lattice_parameters = latt_param('Ti', 'hcp');
        for ii = randi(size(slip_systems_indices,3))
            d = millerbravaisplane2cart(slip_systems_indices(1,:,ii), lattice_parameters(1))';
            n = millerbravaisdir2cart(slip_systems_indices(2,:,ii), lattice_parameters(1))';
        end
end

if dot(n,d) > 1e-9
    commandwindow;
    warning('n,b not perpendicular');
end

commandwindow;
fprintf('Euler angles = [%.3f %.3f %.3f]\n', eulers);

resolved_shear_stress(eulers, d, n, T)
generalized_schmid_factor(n, d, T, g)

end