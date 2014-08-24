% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: open_file_GF2.m 1228 2014-08-13 14:54:04Z d.mercier $
function open_file_GF2
%% Function used to open Grain File Type 2 (from TSL-OIM)
%% Grain File Type 2
% # Column 1: Integer identifying grain
% # Column 2-4: Average orientation (phi1, PHI, phi2) in degrees
% # Column 5-6: Average Position (x, y) in microns
% # Column 7: Average Image Quality (IQ)
% # Column 8: Average Confidence Index (CI)
% # Column 9: Average Fit (degrees)
% # Column 10: An integer identifying the phase ==> 0 -  Titanium (Alpha)
% # Column 11: Edge grain (1) or interior grain (0)
% # Column 12: Diameter of grain in microns

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

%% Get data from the GUI
gui = guidata(gcf);

%% FileGF2 loading
[filenameGF2, pathnameGF2] = uigetfile([gui.config_map.TSLOIM_data_path_GF2, '.txt'], 'Select the ''Grain File Type 2'' file');
% Handle canceled file selection
if filenameGF2 == 0
    filenameGF2 = '';
end
if pathnameGF2 == 0
    pathnameGF2 = '';
else
    gui.config_map.TSLOIM_data_path_GF2 = pathnameGF2;
end

if isequal(filenameGF2, 0) || isempty(filenameGF2)
    disp('User selected Cancel');
else
    disp(['User selected', fullfile(pathnameGF2, filenameGF2)]);
end

% Set the name of the data file in the text box
set(gui.handles.FileGF2, 'String', fullfile(filenameGF2));

gui.config_map.filename_grain_file_type2 = filenameGF2;
gui.config_map.pathname_grain_file_type2 = pathnameGF2;

gui.flag.newDataFlag = 1;

guidata(gcf, gui);

end