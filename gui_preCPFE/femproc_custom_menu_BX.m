% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_custom_menu_BX(parent)
%% Function used to add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

uimenu(parent, 'Label', 'Load CPFEM material config. file', ...
    'Callback', 'femproc_load_YAML_material_file(2)');
uimenu(parent, 'Label', 'Edit YAML material config. file', ...
    'Callback', 'gui_BX = guidata(gcf); edit(sprintf(''config_CPFEM_material_%s.yaml'', gui_BX.config_Matlab.username))');

uimenu(parent, 'Label', 'Load Bicrystal config. file', ...
    'Callback', 'femproc_load_YAML_BX_config_file(0,2)');
uimenu(parent, 'Label', 'Edit YAML Bicrystal config. file', ...
    'Callback', 'gui_BX = guidata(gcf); edit(gui_BX.config_map.imported_YAML_GB_config_file);');


%uimenu(parent, 'Label', 'Load indenter topography (AFM data)', 'Callback', 'femproc_load_indenter_topo_AFM');

uimenu(parent, 'Label', 'Save mesh picture', ...
    'Callback', 'gui_BX = guidata(gcf); save_figure; set(gui_BX.handles.gui_BX_win, ''Color'', [1 1 1]*.9);','Separator','on');
uimenu(parent, 'Label', 'Save mesh settings', ...
    'Callback', 'gui_BX = guidata(gcf); save_data(pwd, gui_BX.GB)');

uimenu(parent, 'Label', 'Show bicrystal conventions', ...
    'Callback', 'gui_BX = guidata(gcf); open_file_web(gui_BX.config_map.path_picture_BXind)', ...
    'Separator','on');


femproc_custom_menu_edit_gui(parent, 'A_femproc_windows_indentation_setting_BX');


end