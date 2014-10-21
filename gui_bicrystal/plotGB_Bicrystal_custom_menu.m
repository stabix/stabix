% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function menuBX = plotGB_Bicrystal_custom_menu
%% Add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

menuBX = uimenu('Label', 'Bicrystal');

custom_menu_help(menuBX);

uimenu(menuBX, 'Label', 'Load a new random bicrystal',       'Callback', 'plotGB_Bicrystal_random_bicrystal', 'Separator','on');
uimenu(menuBX, 'Label', 'Load bicrystal config. file',       'Callback', 'plotGB_Bicrystal_load_YAML_config_file');
uimenu(menuBX, 'Label', 'Save bicrystal pictures',           'Callback', 'gui = guidata(gcf); save_figure(gui.GB.pathnameRB_BC, gcf)', 'Separator','on');
uimenu(menuBX, 'Label', 'Save bicrystal data',               'Callback', 'gui = guidata(gcf); save_data(gui.GB.pathnameRB_BC, gui.GB)');
uimenu(menuBX, 'Label', 'Show bicrystal conventions',        'Callback', 'gui = guidata(gcf); web(fullfile(gui.config.doc_path_root, gui.config.doc_path_BXconv_png))', 'Separator','on');
uimenu(menuBX, 'Label', 'Edit YAML bicrystal config. file',  'Callback', 'gui = guidata(gcf); if gui.GB.YAMLfilename edit(gui.GB.YAMLfilename); end', 'Separator','on');
uimenu(menuBX, 'Label', 'Edit this GUI',                     'Callback', 'edit(''A_gui_plotGB_Bicrystal'')');

menuBX_CPFEM = uimenu('Label', 'CPFEM');

uimenu(menuBX_CPFEM, 'Label', 'Indentation test in a bicrystal', 'Callback', 'A_femproc_windows_indentation_setting_BX(guidata(gcf))');
uimenu(menuBX_CPFEM, 'Label', 'Indentation test in a Grain A',   'Callback', 'A_femproc_windows_indentation_setting_SX(guidata(gcf), 1)');
uimenu(menuBX_CPFEM, 'Label', 'Indentation test in a Grain B',   'Callback', 'A_femproc_windows_indentation_setting_SX(guidata(gcf), 2)');
%uimenu(menuBX_CPFEM, 'Label', 'Bending test of a cantilever',    'Callback', 'beep; warndlg('''Bending test model not yet implemented...!'', ''Warning'')');
uimenu(menuBX_CPFEM, 'Label', 'Bending test of a cantilever',    'Callback', 'beep; warning(''Bending test model not yet implemented...!'')');
%uimenu(menuBX_CPFEM, 'Label', 'Compression test of µ-pillar',    'Callback', 'beep; warndlg(''Compression test of µ-pillar model not yet implemented...!'', ''Warning'')');
uimenu(menuBX_CPFEM, 'Label', 'Compression test of µ-pillar',    'Callback', 'beep; warning(''Compression test of µ-pillar model not yet implemented...!'')');

end