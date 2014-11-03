% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = preCPFE_init
%% Initialization of preCPFE GUIs

% author: c.zambaldi@mpie.de

get_stabix_root;

%% Set the GUI
gui.config = load_YAML_config_file;
gui.config.username = username_get;

gui.version_str = num2str(gui.config.version_toolbox);
gui.module_name = 'preCPFE';

config_files_dir = fullfile(get_stabix_root, 'YAML_config_files', ''); %in the same folder as default config. files
gui.config.CPFEM.config_file_user = sprintf('config_CPFEM_%s.yaml', gui.config.username);
gui.config.CPFEM.config_file_user_full = fullfile(config_files_dir, ...
    gui.config.username, gui.config.CPFEM.config_file_user);
% use the next line in case YAML user config. files are in the same folder
% as defaults YAML config files...
%gui.config_CPFEM_user_full = fullfile(config_files_dir, gui.config_CPFEM_user);

gui.config.CPFEM.config_file_defaults = 'config_CPFEM_defaults.yaml';
gui.config.CPFEM.defaults = ReadYaml(gui.config.CPFEM.config_file_defaults);
gui.config.CPFEM.config_files_dir = config_files_dir;
gui.config.CPFEM.config_file_defaults_full = fullfile(config_files_dir, ...
    gui.config.CPFEM.config_file_defaults)

% if user config exists update defined fields with the user settings
% leave unchanged fields untouched
gui.config.CPFEM = configs_merge(gui.config.CPFEM, gui.config.CPFEM.defaults);
if exist(gui.config.CPFEM.config_file_user_full, 'file')
    gui.config.CPFEM.user_config = ReadYaml(gui.config.CPFEM.config_file_user_full);
    gui.config.CPFEM = configs_merge(gui.config.CPFEM, gui.config.CPFEM.user_config);
end

gui.config.CPFEM = preCPFE_config_CPFEM_check(gui.config.CPFEM);

gui.config.CPFEM.python4fem_module_path = preCPFE_get_python4fem_module_path;

gui.config.CPFEM.pythons.which_all = sys_which('python');
% TODO make pythons unique
gui.config.CPFEM.python_executables = {gui.config.CPFEM.python_executables{:}, ...
    gui.config.CPFEM.pythons.which_all{:}};

gui.config.CPFEM.python = preCPFE_python_check;

end
