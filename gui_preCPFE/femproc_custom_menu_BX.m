% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function menuFEM_mesh = femproc_custom_menu_BX
%% Function used to add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

menuFEM_mesh = uimenu('Label', 'FEM');

uimenu(menuFEM_mesh, 'Label', 'Load CPFEM config. file', 'Callback', 'femproc_load_YAML_CPFEM_config_file(0,2)');
uimenu(menuFEM_mesh, 'Label', 'Load CPFEM material config. file', 'Callback', 'femproc_load_YAML_material_file(2)');
uimenu(menuFEM_mesh, 'Label', 'Load Bicrystal config. file', 'Callback', 'femproc_load_YAML_BX_config_file(0,2)');
%uimenu(menuFEM_mesh, 'Label', 'Load indenter topography (AFM data)', 'Callback', 'femproc_load_indenter_topo_AFM');

uimenu(menuFEM_mesh, 'Label', 'Save mesh picture',     'Callback', 'gui_BX = guidata(gcf); save_figure; set(gui_BX.handles.gui_BX_win, ''Color'', [1 1 1]*.9);','Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Save mesh settings',    'Callback', 'gui_BX = guidata(gcf); save_data(pwd, gui_BX.GB)');

uimenu(menuFEM_mesh, 'Label', 'Show bicrystal conventions',   'Callback', 'gui_BX = guidata(gcf); open_file_web(gui_BX.config_map.path_picture_BXind)','Separator','on');

uimenu(menuFEM_mesh, 'Label', 'Edit this GUI',   'Callback', 'edit(''A_femproc_windows_indentation_setting_BX'')','Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML CPFEM config. file', 'Callback', 'gui_BX = guidata(gcf); edit(gui_BX.config_CPFEM.filename)');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML material config. file', 'Callback', 'gui_BX = guidata(gcf); edit(sprintf(''config_CPFEM_material_%s.yaml'', gui_BX.config_Matlab.username))');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML Bicrystal config. file', 'Callback', 'gui_BX = guidata(gcf); edit(gui_BX.config_map.imported_YAML_GB_config_file);');

uimenu(menuFEM_mesh, 'Label', 'Help', 'Callback', 'gui = guidata(gcf); open_file_web(gui.config_Matlab.doc_path)','Separator','on');

end