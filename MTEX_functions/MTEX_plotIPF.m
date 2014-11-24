% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function MTEX_plotIPF(orientations, xaxis_alignement, varargin)
%% Plot IPDF with MTEX
% orientations: Orientation of grains (at least 2 grains)

% author: d.mercier@mpie.de

if nargin < 2
    xaxis_alignement = 1;
end

if nargin < 1
    warning_commwin'Wrong dataset for orientations calculation !');
end

%% Specify how to align the x-axis in plots

switch(xaxis_alignement)
    case {1}
        plotx2east; %set the default plot direction of the xaxis
    case {2}
        plotx2north; %set the default plot direction of the xaxis
    case {3}
        plotx2south; %set the default plot direction of the xaxis
    case {4}
        plotx2west; %set the default plot direction of the xaxis
    case {5}
        plotzIntoPlane; %set the default plot direction of the zaxis
    case {6}
        plotzOutOfPlane; %set the default plot direction of the zaxis
end

%% Plot IPF for the bicrystal
v = vector3d(0, 0, 1); %zvector
figure('Name', 'IPF'); hold on;

oM = ipdfHSVOrientationMapping(orientations);
plot(oM); hold on;

plotIPDF(orientations, v, ...
    'markerSize', 3, ...
    'points', 500, ...
    'marker', 'o', ...
    'markerfacecolor', 'none', ...
    'markeredgecolor', 'k');

end