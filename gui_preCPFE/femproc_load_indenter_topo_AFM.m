% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_load_indenter_topo_AFM(indenter_type, varargin)
%% Function to import topography from Gwyddion file
% indenter_type : 1 for default indenter and 2 for AFM topography

% Data format from Gwyddion
% - channel: 'Height'
% - width: 5
% - height: 5
% - FEM_mode: 0
% - data: [512x512 double]
% - nX: 512
% - nY: 512
% - resX: 0.0098
% - resY: 0.0098
% - linX: [1x512 double]
% - linY: [1x512 double]
% - max: 1.9029e-06
% - min: -7.2871e-07
% - data_range: 2.6316e-06
% - X: [512x512 double]
% - Y: [512x512 double]

% author: d.mercier@mpie.de

if nargin < 1
    indenter_type = 1;
end

gui = guidata(gcf);

if indenter_type == 1
    gui.indenter_type = 'default';
else
    gui.indenter_type = 'AFM';
    [file_AFM, dir_AFM, filterindex] = uigetfile('*.txt', 'Select a Gwyddion file');
    gui.indenter_topo = read_gwyddion_ascii(fullfile(dir_AFM,file_AFM));
    set(gui.handles.rotate_loaded_indenter, 'Value', 0);
end

guidata(gcf, gui);
femproc_gui_update;

if strcmp(gui.GB.active_data, 'SX') == 1
    femproc_indentation_setting_SX;
elseif strcmp(gui.GB.active_data, 'BX') == 1
    femproc_indentation_setting_BX;
end

end