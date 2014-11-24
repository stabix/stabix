% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function tau = resolved_shear_stress(eulers, d, n, T, testFlag, varargin)
%% Function used to calculate the resolved shear stress
% From C.N. Reid," Deformation Geometry for Materials Scientists, Pergamon Press, Oxford, United Kingdom, 1973 (p.115-133).
% eulers: Bunge Euler angles in degrees
% d: slip direction
% n: slip plane normal
% T: stress in sample coordinate system
% author: c.zambaldi@mpie.de

tol = 1e-9; % tolerance for tests and for checking if normals and directions are perpendicular;

if nargin < 5
    testFlag = false;
end
if nargin < 4
    T = unitstress(3); % Tension along Z
end
if nargin < 2
    d = [1,0,1];
    n = [1,1,-1];
end
if nargin < 1
    eulers = randBunges();
    testFlag = true;
end

n = n/norm(n);
d = d/norm(d);

if dot(n,d) > tol
    warning_commwin('n,b not perpendicular');
end

g = eulers2g(eulers)';
S = schmidmatrix(d,n);

schmid = g * S * g';

% Resolved shear stress
tau = 0;
for ii = 1:3
    for jj = 1:3
        tau = tau + T(ii,jj) * schmid(jj,ii);
    end
end

if testFlag
    fprintf('Euler angles = [%.3f %.3f %.3f]\n', eulers);
    fprintf('Resolved Shear Stress = %.4f\n', tau);
end

end 