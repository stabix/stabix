% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function mtex_plotIPF(ebsdData, xaxis_alignement, varargin)
%% Plot IPDF with MTEX
% ebsdData : Name of the structure variable created after importing EBSD data
% .ang file ('ebsd' is default name use by MTEX...)

% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

no_orientation = 0;

if nargin < 2
    xaxis_alignement = 1;
end

if nargin < 1
    warning_commwin('Wrong dataset for orientations calculation !');
    no_orientation = 1;
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

if ~no_orientation
    if isfield(ebsdData, 'phase') && isfield (ebsdData, 'orientations')
        if max(ebsdData.phase) == 0
            oM = ipdfHSVOrientationMapping(ebsdData.orientations);
            plot(oM); hold on;
            
            plotIPDF(ebsdData.orientations, v, ...
                'markerSize', 5, ...
                'points', length(ebsdData.orientations), ...
                'marker', 'o', ...
                'markerfacecolor', 'none', ...
                'markeredgecolor', 'k');
        else
            display('Only permitted for a single phase!');
        end
    else
        %% Plot IPF for the bicrystal
        oM = ipdfHSVOrientationMapping(ebsdData);
        plot(oM); hold on;
        
        plotIPDF(ebsdData, v, ...
            'markerSize', 5, ...
            'points', length(ebsdData), ...
            'marker', 'o', ...
            'markerfacecolor', 'none', ...
            'markeredgecolor', 'k');
    end
end
end