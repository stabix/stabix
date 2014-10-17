% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = femproc_init
%% Initialization of preCPFE GUIs

% author: c.zambaldi@mpie.de

get_stabix_root;

%% Set the GUI
gui.config = load_YAML_config_file;
gui.config.username = get_username;

gui.version_str = num2str(gui.config.version_toolbox);
gui.module_name = 'preCPFE';

config_files_dir = fullfile(get_stabix_root, 'YAML_config_files', ''); %in the same folder as default config. files
gui.config_CPFEM_user = sprintf('config_CPFEM_%s.yaml', gui.config.username);
gui.config_CPFEM_user_full = fullfile(config_files_dir, gui.config_CPFEM_user);
%gui.config_CPFEM_user_full = fullfile(config_files_dir, gui.config.username, gui.config_CPFEM_user);

config_CPFEM_file = 'config_CPFEM_defaults.yaml';
gui.defaults = ReadYaml(config_CPFEM_file);
gui.defaults.config_files_dir = config_files_dir;

% if user config exists update defined fields with the user settings
% leave unchanged fields untouched
if exist(gui.config_CPFEM_user_full, 'file')
    gui.defaults.user_config = ReadYaml(gui.config_CPFEM_user_full);
    %femproc_config_CPFEM_check_user_config(gui.defaults.user_config);
    fns = fieldnames(gui.defaults.user_config);
    for fn_idx = 1:numel(fns)
        fn = fns{fn_idx};
        if isfield(gui.defaults, fn)
            % update fields with user config
            % only fields that exist in the defaults can be changed by the
            % user
            gui.defaults.(fn) = gui.defaults.user_config.(fn);
        else
            warning('User config field "%s" not found\n', fn);
        end
    end
end

gui.config_CPFEM_dir = config_files_dir;
gui.config_CPFEM_file = config_CPFEM_file;
gui.config_CPFEM_full = fullfile(gui.config_CPFEM_dir, gui.config_CPFEM_file);

gui.config_CPFEM = gui.defaults;

gui.config_CPFEM.python4fem_module_path = femproc_get_python4fem_module_path;

%gui.config_CPFEM.pythons_all

gui.config_CPFEM.python = femproc_python_check;
%gui.config_CPFEM.pythonpath = [];

end