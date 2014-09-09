% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_config_CPFEM_init
%% Set the GUI with a YAML file

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

config_CPFEM_YAML_file = sprintf('config_CPFEM_%s.yaml', gui.config_Matlab.username);
config_CPFEM_user = fullfile(gui.defaults.config_files_dir, config_CPFEM_YAML_file);
if exist(config_CPFEM_user, 'file')
    femproc_load_YAML_CPFEM_config_file(config_CPFEM_user);
else
    config_CPFEM_default = fullfile(gui.defaults.config_files_dir, ...
        gui.defaults.config_CPFEM_file);
    femproc_load_YAML_CPFEM_config_file(config_CPFEM_default);
end

end