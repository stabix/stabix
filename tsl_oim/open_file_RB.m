% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: open_file_RB.m 1200 2014-08-05 09:52:15Z d.mercier $
function open_file_RB
%% Function used to open Reconstructed Boundaries file (from TSL-OIM)
%% Reconstructed Boundaries file                                                         x axis or TD Direction (Transverse)
% # Column 1-3:    right hand average orientation (phi1, PHI, phi2 in radians)       ---->
% # Column 4-6:    left hand average orientation (phi1, PHI, phi2 in radians)      y |
% # Column 7:      length (in microns)                                         or RD |
% # Column 8:      trace angle (in degrees)                                Reference v
% Column 8 = angle alpha from [RANDLE 2006] --> 90° if vertical (// to y-axis) and 0° if horizontal (// to x-axis)
% # Column 9-12:   x,y coordinates of endpoints (in microns)
% # Column 13-14:  IDs of right hand and left hand grains
% In column 8, put the angle from the horizontal of the GB, e.g. 90deg if you want a vertical boundary.

% [RANDLE 2006] : DOI ==> 10.1111/j.1365-2818.2006.01575.x

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

%% Get data from the GUI
gui = guidata(gcf);

%% FileRB loading
[filenameRB, pathnameRB] = uigetfile([gui.config_map.TSLOIM_data_path_GF2, '.txt'], 'Select the ''Reconstructed Boundary'' file');
% Handle canceled file selection
if filenameRB == 0
    filenameRB = '';
end
if pathnameRB == 0
    pathnameRB = '';
else
    gui.config_map.TSLOIM_data_path_RB = pathnameRB;
end

if isequal(filenameRB, 0) || isempty(filenameRB)
   disp('User selected Cancel');
else
   disp(['User selected', fullfile(pathnameRB, filenameRB)]);
end

% Set the name of the data file in the text box
set(gui.handles.FileRB, 'String', fullfile(filenameRB));

gui.config_map.filename_reconstructed_boundaries_file = filenameRB;
gui.config_map.pathname_reconstructed_boundaries_file = pathnameRB;

gui.flag.newDataFlag = 1;


guidata(gcf, gui);

end