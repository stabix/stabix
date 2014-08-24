% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: plotGB_Bicrystal_custom_menu.m 1251 2014-08-20 18:12:08Z d.mercier $
function menuBX = plotGB_Bicrystal_custom_menu
%% Add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

menuBX = uimenu('Label', 'Bicrystal');

uimenu(menuBX, 'Label', 'Load a new random bicrystal',       'Callback', 'plotGB_Bicrystal_random_bicrystal');
uimenu(menuBX, 'Label', 'Load bicrystal config. file',       'Callback', 'plotGB_Bicrystal_load_YAML_config_file');
uimenu(menuBX, 'Label', 'Save bicrystal pictures',           'Callback', 'gui = guidata(gcf); save_figure(gui.GB.pathnameRB_BC, gcf)','Separator','on');
uimenu(menuBX, 'Label', 'Save bicrystal data',               'Callback', 'gui = guidata(gcf); save_data(gui.GB.pathnameRB_BC, gui.GB)');
uimenu(menuBX, 'Label', 'Show bicrystal conventions',        'Callback', 'gui = guidata(gcf); open_file_web(gui.config_map.path_picture_BXconv)','Separator','on');
uimenu(menuBX, 'Label', 'Edit YAML bicrystal config. file',  'Callback', 'gui = guidata(gcf); if gui.GB.YAMLfilename edit(gui.GB.YAMLfilename); end','Separator','on');
uimenu(menuBX, 'Label', 'Edit this GUI',                     'Callback', 'edit(''A_gui_plotGB_Bicrystal'')');
uimenu(menuBX, 'Label', 'Help',                              'Callback', 'gui = guidata(gcf); open_file_web(gui.config_Matlab.doc_path)','Separator','on');

menuBX_CPFEM = uimenu('Label', 'CPFEM');

uimenu(menuBX_CPFEM, 'Label', 'Indentation test in a bicrystal', 'Callback', 'A_femproc_windows_indentation_setting_BX(guidata(gcf))');
uimenu(menuBX_CPFEM, 'Label', 'Indentation test in a Grain A',   'Callback', 'A_femproc_windows_indentation_setting_SX(guidata(gcf), 1)');
uimenu(menuBX_CPFEM, 'Label', 'Indentation test in a Grain B',   'Callback', 'A_femproc_windows_indentation_setting_SX(guidata(gcf), 2)');
uimenu(menuBX_CPFEM, 'Label', 'Bending test of a cantilever',    'Callback', 'warndlg(''Not yet implemented...!'')');
uimenu(menuBX_CPFEM, 'Label', 'Compression test of µ-pillar',    'Callback', 'warndlg(''Not yet implemented...!'')');

end