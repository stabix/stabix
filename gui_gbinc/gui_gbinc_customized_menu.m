% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_customized_menu
%% Function to Add a custom menu item in the GUI menubar
% author: d.mercier@mpie.de

menu_map = uimenu('Label', 'GBInc');

custom_menu_help(menu_map);

uimenu(menu_map, 'Label', 'Edit this GUI', ...
    'Callback', 'edit(''A_gui_gbinc'')', 'Separator', 'on');

end