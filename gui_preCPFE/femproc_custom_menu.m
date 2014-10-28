% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function menuFEM_mesh = femproc_custom_menu(label)
%% Function used to add a custom menu item in the GUI menubar
% label: String used as a label in the menu
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 1
    label = 'FEM';
end

menuFEM_mesh = uimenu('Label', label);

custom_menu_help(menuFEM_mesh);

% --- Deactivated for now, should just reload config.CPFEM
%uimenu(menuFEM_mesh, 'Label', 'Load CPFEM config. file', ...
%    'Callback', 'preCPFE_select_config_CPFEM; preCPFE_config_CPFEM_updated;', ...
%    'Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Edit CPFEM config. file', ...
    'Callback', 'preCPFE_config_CPFEM_edit',...
    'Separator','on');

uimenu(menuFEM_mesh, 'Label', 'Load default indenter', ...
    'Callback', 'femproc_load_indenter_topo_AFM(1)',...
    'Separator','on');
uimenu(menuFEM_mesh, 'Label', 'Load indenter topography (AFM data)', ...
    'Callback', 'femproc_load_indenter_topo_AFM(2)');

end