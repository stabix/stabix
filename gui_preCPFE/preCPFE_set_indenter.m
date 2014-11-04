% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_set_indenter
%% Function to import topography from Gwyddion file

% author: d.mercier@mpie.de

gui = guidata(gcf);

indenter_type = get(gui.handles.indenter.pm_indenter, 'Value');

if indenter_type == 1
    gui.indenter_type = 'conical';
elseif indenter_type == 2
    gui.indenter_type = 'Berkovich';
elseif indenter_type == 3
    gui.indenter_type = 'Vickers';
elseif indenter_type == 4
    gui.indenter_type = 'cubeCorner';
elseif indenter_type == 5
    gui.indenter_type = 'flatPunch';
else
    gui.indenter_type = 'AFM';
    [file_AFM, dir_AFM, filterindex] = uigetfile('*.txt', 'Select a Gwyddion file');
    gui.indenter_topo = read_gwyddion_ascii(fullfile(dir_AFM,file_AFM));
    set(gui.handles.indenter.rotate_loaded_indenter, 'Value', 0);
end

guidata(gcf, gui);
preCPFE_gui_update_indenter;

end