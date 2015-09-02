function grains = MTEX_calcGrains(ebsdData, segAngle, varargin)
%% Function for grains detection
% ebsdData : Name of the structure variable created after importing EBSD data
% .ang file ('ebsd' is default name use by MTEX...)
% segAngle: Array of threshold angles per phase of mis/disorientation in radians

% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

if nargin < 2
    segAngle = 10;
end

try
    segAngleDegree = segAngle * degree;
    grains = calcGrains(ebsdData, 'angle', segAngleDegree);
catch err
    grains = 0;
    commandwindow;
    display(err.message);
end

end