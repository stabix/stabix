% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: interface_map_custom_menu.m 1251 2014-08-20 18:12:08Z d.mercier $
function interface_map_custom_menu
%% Function to Add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

menu_map = uimenu('Label', 'EBSDmap');

uimenu(menu_map, 'Label', 'Load EBSD map config. file', 'Callback', 'interface_map_load_YAML_config_file');
uimenu(menu_map, 'Label', 'Save EBSD map picture', 'Callback', 'gui = guidata(gcf); save_figure; set(gui.handles.TSLinterfWindow, ''Color'', [1 1 1]*.9);', 'Separator', 'on');
uimenu(menu_map, 'Label', 'Save results', 'Callback', 'gui = guidata(gcf); save_data(pwd, gui.GBs);');
uimenu(menu_map, 'Label', 'Show GB conventions', 'Callback', 'gui = guidata(gcf); open_file_web(gui.config_map.path_picture_BXconv)', 'Separator', 'on');
uimenu(menu_map, 'Label', 'Edit this GUI', 'Callback', 'edit(''A_gui_plotmap'')', 'Separator', 'on');
uimenu(menu_map, 'Label', 'Help', 'Callback', 'gui = guidata(gcf); open_file_web(gui.config_Matlab.doc_path)','Separator','on');

guidata(gcf, gui);

end