% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: femproc_custom_menu_SX.m 1251 2014-08-20 18:12:08Z d.mercier $
function menuFEM_mesh = femproc_custom_menu_SX
%% Function used to add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

menuFEM_mesh = uimenu('Label', 'FEM');

uimenu(menuFEM_mesh, 'Label', 'Load CPFEM config. file', 'Callback', 'femproc_load_YAML_CPFEM_config_file(0,1)');
uimenu(menuFEM_mesh, 'Label', 'Load CPFEM material config. file', 'Callback', 'femproc_load_YAML_material_file(1)');
uimenu(menuFEM_mesh, 'Label', 'Load Single Crystal config. file', 'Callback', 'femproc_load_YAML_BX_config_file(0,1)');
%uimenu(menuFEM_mesh, 'Label', 'Load indenter topography (AFM data)', 'Callback', 'femproc_load_indenter_topo_AFM');

uimenu(menuFEM_mesh, 'Label', 'Save mesh picture',     'Callback', 'gui_SX = guidata(gcf); save_figure; set(gui_SX.handles.gui_SX_win, ''Color'', [1 1 1]*.9);','Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Save mesh settings',    'Callback', 'gui_SX = guidata(gcf); save_data(pwd, gui_SX.GB)');

uimenu(menuFEM_mesh, 'Label', 'Show single crystal conventions',   'Callback', 'gui_SX = guidata(gcf); open_file_web(gui_SX.config_map.path_picture_SXind)','Separator','on');

uimenu(menuFEM_mesh, 'Label', 'Edit this GUI',   'Callback', 'edit(''A_femproc_windows_indentation_setting_SX'')','Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML CPFEM config. file', 'Callback', 'gui_SX = guidata(gcf); edit(gui_SX.config_CPFEM.filename)');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML material config. file', 'Callback', 'gui_SX = guidata(gcf); edit(sprintf(''config_CPFEM_material_%s.yaml'', gui_SX.config_Matlab.username))');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML Single Crystal config. file', 'Callback', 'gui_SX = guidata(gcf); edit(gui_SX.config_map.imported_YAML_GB_config_file)');

uimenu(menuFEM_mesh, 'Label', 'Help', 'Callback', 'gui = guidata(gcf); open_file_web(gui.config_Matlab.doc_path)','Separator','on');

end
