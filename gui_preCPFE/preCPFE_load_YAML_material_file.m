% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_load_YAML_material_file
%% Function to import material config file from YAML config. file
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if gui.GB.number_phase == 1
    configmatYAML = sprintf('config_CPFEM_material_%s.yaml', ...
        gui.config.username);
    
    if ~exist(configmatYAML, 'file')
        warning_commwin(['YAML file for material configation not found ! ' ...
            'Default values are used...']);
        configmatdefYAML = sprintf('config_CPFEM_material_defaults.yaml');
        gui.config_material  = ReadYaml(configmatdefYAML);
    else
        gui.config_material  = ReadYaml(configmatYAML);
    end
    
elseif gui.GB.number_phase == 2
    configmatA_YAML = sprintf('config_CPFEM_materialA_%s.yaml', ...
        gui.config.username);
    configmatB_YAML = sprintf('config_CPFEM_materialB_%s.yaml', ...
        gui.config.username);
    
    if ~exist(configmatA_YAML, 'file') || ~exist(configmatB_YAML, 'file')
        warning_commwin(['YAML file for material A or B configuration not ' ...
            'found ! Default values are used...']);
        configmatdefYAML_A = ...
            sprintf('config_CPFEM_materialA_defaults.yaml');
        configmatdefYAML_B = ...
            sprintf('config_CPFEM_materialB_defaults.yaml');
        gui.config_materialA = ReadYaml(configmatdefYAML_A);
        gui.config_materialB = ReadYaml(configmatdefYAML_B);
    else
        gui.config_materialA = ReadYaml(configmatA_YAML);
        gui.config_materialB = ReadYaml(configmatB_YAML);
    end
end

guidata(gcf, gui);
end