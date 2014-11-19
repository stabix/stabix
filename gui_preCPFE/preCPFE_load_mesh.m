% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_load_mesh(interface)
%% Function to load CPFE model mesh as a YAML file
% See in http://code.google.com/p/yamlmatlab/
% mesh_to_load: Output variables from YAML config. file with all mesh parameters to load

% author: d.mercier@mpie.de

YAML_mesh_config_file = uigetfile('*.yaml', ...
    'Load mesh in a YAML config. file as');

% Handle canceled file selection
if YAML_mesh_config_file == 0
    YAML_mesh_config_file = '';
end

if isequal(YAML_mesh_config_file, 0) ...
        || strcmp(YAML_mesh_config_file, '') == 1
    disp('User selected Cancel');
else
    disp(['User selected :', fullfile(YAML_mesh_config_file)]);
    
    mesh_variables.variables = ReadYaml(YAML_mesh_config_file);
    
    if interface == 1
        gui_BX = guidata(gcf);
        set(gui_BX.handles.pm_mesh_quality, 'Value', 1);
        gui_BX.handles.mesh = preCPFE_mesh_parameters_BX(mesh_variables);
        guidata(gcf, gui_BX);
        preCPFE_indentation_setting_BX;
    elseif interface == 2
        gui_SX = guidata(gcf);
        set(gui_SX.handles.pm_mesh_quality, 'Value', 1);
        gui_SX.handles.mesh = preCPFE_mesh_parameters_SX(mesh_variables);
        guidata(gcf, gui_SX);
        preCPFE_indentation_setting_SX;
    end
    
end

end