% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function eulers = randRoe(N, varargin)
%% Function used to give random Euler angles in degrees (Roe notation)
% returns N rows of random Roe Euler angles in degrees

% author: d.mercier@mpie.de

if nargin == 0 
    N = 1;
end

eulers = randBunges(N);
eulers(1) = eulers(1) - 90; % Psi
eulers(2) = eulers(3); % Theta
eulers(2) = eulers(3) + 90; % Phi

return