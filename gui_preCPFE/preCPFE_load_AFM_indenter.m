% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function file_AFM = preCPFE_load_AFM_indenter
%% Function used to load AFM topography of an indenter

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if ~isfield(gui, 'AFM_indenter_path')
    gui.AFM_indenter_path = fullfile(get_stabix_root, 'gui_preCPFE', '');
end
[file_AFM, dir_AFM, filterindex] = ...
    uigetfile([gui.AFM_indenter_path, '/*.txt'], ...
    'Select a Gwyddion *.txt file');

if file_AFM
    try
        gui.indenter_topo = read_gwyddion_ascii(fullfile(dir_AFM, file_AFM));
        gui.AFM_indenter_path = dir_AFM; % only set after successful reading.
    catch err
        commandwindow;
        disp(err);
    end
end

guidata(gcf, gui);

end