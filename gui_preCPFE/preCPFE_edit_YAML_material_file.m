% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_edit_YAML_material_file
%% Function to edit YAML material config. file
% See in http://code.google.com/p/yamlmatlab/

% author: d.mercier@mpie.de

gui = guidata(gcf);

if gui.GB.number_phase == 1
    if exist(sprintf('config_CPFEM_material_%s.yaml', gui.config.username))
        edit(sprintf('config_CPFEM_material_%s.yaml', gui.config.username));
    else
        edit('config_CPFEM_material_defaults.yaml');
    end
elseif gui.GB.number_phase == 2
    if exist(sprintf('config_CPFEM_materialA_%s.yaml', gui.config.username))
        edit(sprintf('config_CPFEM_materialA_%s.yaml', gui.config.username));
    end
    if exist(sprintf('config_CPFEM_materialB_%s.yaml', gui.config.username))
        edit(sprintf('config_CPFEM_materialB_%s.yaml', gui.config.username));
    end
    if ~exist(sprintf('config_CPFEM_materialA_%s.yaml', gui.config.username)) ...
            && ~exist(sprintf('config_CPFEM_materialB_%s.yaml', gui.config.username))
        edit('config_CPFEM_materialA_defaults.yaml');
        edit('config_CPFEM_materialB_defaults.yaml');
    end
end

guidata(gcf, gui);
end