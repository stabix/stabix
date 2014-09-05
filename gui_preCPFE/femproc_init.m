function gui = femproc_init
get_stabix_root;

%% Set Matlab
gui.config_Matlab = load_YAML_config_file;

gui.toolbox_name = 'STABiX';
gui.version_str = num2str(gui.config_Matlab.version_toolbox);
gui.module_name = 'preCPFE';

gui.doc_local = fullfile(get_stabix_root, 'doc', '');

gui.defaults = struct;
gui.defaults.config_files_dir = fullfile(get_stabix_root,'YAML_config_files');
gui.defaults.config_CPFEM_file = 'config_CPFEM_default.yaml';
gui.defaults.config_CPFEM_full = fullfile(gui.defaults.config_files_dir,...
    gui.defaults.config_CPFEM_file);
gui.defaults.fem_solvers = {'Mentat_2008'; ...
    'Mentat_2010'; ...
    'Mentat_2012'; ...
    'Mentat_2013'; ...
    'Mentat_2013.1'};
