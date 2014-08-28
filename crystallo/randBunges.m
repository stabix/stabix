% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function eulers = randBunges(N, varargin)
%% Function used to give random Euler angles in degrees (Bunge notation)
% returns N rows of random Bunge Euler angles in degrees
% author: c.zambaldi@mpie.de

if nargin == 0
    N = 1;
end

% unrestricted: 0...360°, 0°...180°, 0°...360°
eulers = [ rand(N,1) * 360, ...     % phi1
    acosd(rand(N,1)*2-1),...        % Phi
    rand(N,1) * 360 ];              % phi2

return
