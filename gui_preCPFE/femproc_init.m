% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = femproc_init
%% Initialization of preCPFE GUIs

% author: c.zambaldi@mpie.de

get_stabix_root;

%% Set the GUI
gui.config = load_YAML_config_file;

gui.version_str = num2str(gui.config.version_toolbox);
gui.module_name = 'preCPFE GUI';

config_CPFEM_YAML_file = sprintf('config_CPFEM_%s.yaml', gui.config.username);

if exist(config_CPFEM_YAML_file, 'file')
    gui.defaults = ReadYaml(config_CPFEM_YAML_file);
else
    gui.defaults = ReadYaml('config_CPFEM_defaults.yaml');
end

gui.defaults.config_files_dir = fullfile(get_stabix_root,'YAML_config_files');
gui.defaults.config_CPFEM_file = 'config_CPFEM_defaults.yaml';
gui.defaults.config_CPFEM_full = fullfile(gui.defaults.config_files_dir,...
    gui.defaults.config_CPFEM_file);

gui.config_CPFEM = gui.defaults;

gui.confog_CPFEM.msc_module_path = femproc_get_msc_module_path;

gui.config_CPFEM.python = femproc_python_check;
%gui.config_CPFEM.pythonpath = [];

end