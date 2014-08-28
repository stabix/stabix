% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_load_YAML_material_file(interface)
%% Function to import material config file from YAML config. file
% interface: type of interface (1 for SX or 2 for BX meshing interface)
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if gui.GB.number_phase == 1
    configmatYAML = sprintf('config_CPFEM_material_%s.yaml', gui.config_Matlab.username);
    
    if exist(configmatYAML,'file') == 0
        warndlg('YAML file for material config not found ! Default values are used', '!! Warning !!');
        configmatdefYAML = sprintf('config_CPFEM_material_example.yaml');
        gui.config_material  = ReadYaml(configmatdefYAML);
        
    else
        gui.config_material  = ReadYaml(configmatYAML);
        
    end
    
elseif gui.GB.number_phase == 2
    configmatA_YAML = sprintf('config_CPFEM_materialA_%s.yaml', gui.config_Matlab.username);
    configmatB_YAML = sprintf('config_CPFEM_materialB_%s.yaml', gui.config_Matlab.username);
    
    if exist(configmatA_YAML, 'file') == 0 || exist(configmatB_YAML, 'file') == 0
        warndlg('YAML file for material config not found ! Default values are used', '!! Warning !!');
        configmatdefYAML = sprintf('config_CPFEM_material_example.yaml');
        gui.config_materialA = ReadYaml(configmatdefYAML);
        gui.config_materialB = ReadYaml(configmatdefYAML);
        
    else
        gui.config_materialA = ReadYaml(configmatA_YAML);
        gui.config_materialB = ReadYaml(configmatB_YAML);
        
    end
end

if interface == 1
    gui_SX = gui;
    guidata(gcf, gui_SX);
elseif interface == 2
    gui_BX = gui;
    guidata(gcf, gui_BX);
end

end