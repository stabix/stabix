% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function eulers = randKocks(N, varargin)
%% Function used to give random Euler angles in degrees (Kocks notation)
% returns N rows of random Kocks Euler angles in degrees

% author: d.mercier@mpie.de

if nargin == 0 
    N = 1;
end

eulers = randBunges(N);
eulers(1) = eulers(1) - 90; % Psi
eulers(2) = eulers(2); % Theta
eulers(3) = 90 - eulers(3); % phi

return