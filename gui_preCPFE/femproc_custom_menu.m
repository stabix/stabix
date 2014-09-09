% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function menuFEM_mesh = femproc_custom_menu
%% Function used to add a custom menu item in the GUI menubar
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

menuFEM_mesh = uimenu('Label', 'FEM');

femproc_custom_menu_help(menuFEM_mesh);

uimenu(menuFEM_mesh, 'Label', 'Load CPFEM config. file', ...
    'Callback', 'femproc_select_config_CPFEM; femproc_config_CPFEM_updated;', ...
    'Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Edit YAML CPFEM config. file', ...
    'Callback', 'gui = guidata(gcf); edit(gui.config_CPFEM.filename)');

end