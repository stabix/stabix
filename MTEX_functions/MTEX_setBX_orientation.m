% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function ori_grain = MTEX_setBX_orientation(phase, ca_ratio, eulers_angle, varargin)
%% Set orientation of a grain by using MTEX function
% phase = Crystal Structure (CS for MTEX)
% eulers_angle = Euler angles (Bunge) in degrees
% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

if nargin < 3
    eulers_angle = randBunges;
end

if nargin < 2
    ca_ratio = 1.5875; %for Ti
end

if nargin < 1
    phase = 'hcp';
end

% Grain symmetry
if strcmp (phase,'hcp') == 1
    CS = symmetry('hexagonal', [1 1 ca_ratio]);
    
elseif strcmp (phase, 'fcc') == 1
    CS = symmetry('cubic');
    
elseif strcmp (phase, 'bcc') == 1
    CS = symmetry('cubic');
    
end

% Set orientation of grain - MTEX function
ori_grain = orientation('Euler',...
    (eulers_angle(1)/180)*pi,...
    (eulers_angle(2)/180)*pi,...
    (eulers_angle(3)/180)*pi,...
    CS);

end