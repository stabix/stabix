% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function mtex_plotEBSDdata(ebsdData)
%% Visualization of EBSD data (phase, EBSD map, IPF) with MTEX Toolbox
% ebsdData : Name of the structure variable created after importing EBSD data
% .ang file ('ebsd' is default name use by MTEX...)

% See in http://mtex-toolbox.github.io/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

flagEBSDdata = 1;

if nargin < 1
    warning_commwin('No EBSD data to load !');
    flagEBSDdata = 0;
end

if flagEBSDdata
    if max(ebsdData.phase) == 0 || max(ebsdData.phase) == 1
        %% Orientation of Grains
        figure('Name', 'EBSDmap'); hold on;
        oM = ipdfHSVOrientationMapping(ebsdData);
        plot(ebsdData,oM.orientation2color(ebsdData.orientations))
        
        %% Phase
        figure('Name', 'Phase'); hold on;
        plot(ebsdData, 'property', 'phase');
        
        %% Plot Inverse Pole Figure
        mtex_plotIPF(ebsdData.orientations);
    else
        disp('Only permitted for a single phase!');
    end
end

end