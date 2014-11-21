% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function MTEX_plotEBSDdata(ebsdData)
%% Visualization of EBSD data (phase, EBSD map, IPF) with MTEX Toolbox
% ebsdData : Name of the structure variable created after importing EBSD data
% .ang file ('ebsd' is default name use by MTEX...)

% See in http://code.google.com/p/mtex/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

flagEBSDdata = 1;

if nargin < 1
    commandwindow;
    warning('No EBSD data to load !');
    flagEBSDdata = 0;
end

if flagEBSDdata   
    %% Orientation of Grains
    figure('Name', 'EBSDmap'); hold on;
    oM = ipdfHSVOrientationMapping(ebsdData);
    plot(ebsdData,oM.orientation2color(ebsdData.orientations))
    
    %% Phase
    figure('Name', 'Phase'); hold on;
    plot(ebsdData, 'property', 'phase');
    
    %% Plot Inverse Pole Figure
    v = vector3d(0, 0, 1); %zvector
    figure('Name', 'IPF');  hold on;
    plot(oM); hold on;
    plotIPDF(ebsdData.orientations, v, ...
        'markerSize', 3, ...
        'points', 500, ...
        'marker', 'o', ...
        'markerfacecolor', 'none', ...
        'markeredgecolor', 'k');
end

end