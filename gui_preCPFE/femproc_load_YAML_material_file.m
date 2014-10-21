% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_load_YAML_material_file(interface)
%% Function to import material config file from YAML config. file
% interface: type of interface (1 for SX or 2 for BX meshing interface)
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);
gui.config.username = get_username;

if gui.GB.number_phase == 1
    configmatYAML = sprintf('config_CPFEM_material_%s.yaml', gui.config.username);
    
    if ~exist(configmatYAML, 'file')
        %warndlg('YAML file for material configation not found ! Default values are used...', 'Warning');
        warning('YAML file for material configation not found ! Default values are used...');
        configmatdefYAML = sprintf('config_CPFEM_material_defaults.yaml');
        gui.config_material  = ReadYaml(configmatdefYAML);
        
    else
        gui.config_material  = ReadYaml(configmatYAML);
        
    end
    
elseif gui.GB.number_phase == 2
    configmatA_YAML = sprintf('config_CPFEM_materialA_%s.yaml', gui.config.username);
    configmatB_YAML = sprintf('config_CPFEM_materialB_%s.yaml', gui.config.username);
    
    if ~exist(configmatA_YAML, 'file') || ~exist(configmatB_YAML, 'file')
        %warndlg('YAML file for material A configation not found ! Default values are used...', '!! Warning !!');
        warning('YAML file for material A or B configuration not found ! Default values are used...');
        configmatdefYAML_A = sprintf('config_CPFEM_materialA_defaults.yaml');
        configmatdefYAML_B = sprintf('config_CPFEM_materialB_defaults.yaml');
        gui.config_materialA = ReadYaml(configmatdefYAML_A);
        gui.config_materialB = ReadYaml(configmatdefYAML_B);
        
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