% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_load_AFM_indenter

gui = guidata(gcf);

if ~isfield(gui, 'AFM_indenter_path')
    gui.AFM_indenter_path = fullfile(get_stabix_root, 'gui_preCPFE', '');
end
[file_AFM, dir_AFM, filterindex] = uigetfile([gui.AFM_indenter_path, '/*.txt'], ...
    'Select a Gwyddion *.txt file');
try
    gui.indenter_topo = read_gwyddion_ascii(fullfile(dir_AFM, file_AFM));
    gui.AFM_indenter_path = dir_AFM; % only set after successful reading.
catch id
    disp(id);
end

guidata(gcf, gui);

end