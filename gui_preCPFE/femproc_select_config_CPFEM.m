function femproc_select_config_CPFEM
gui = guidata(gcf);
[config_CPFEM_file, config_CPFEM_path] = ...
    uigetfile(fullfile(gui.defaults.config_files_dir,'config_CPFEM*.yaml'), ...
    'Select CPFEM config. file');

if isempty(config_CPFEM_file)%isequal(YAML_CPFEM_config_file_2_import, 0) || strcmp(YAML_CPFEM_config_file_2_import, '') == 1
    disp('User selected Cancel');
    gui.config_CPFEM_file = gui.defaults.config_CPFEM_full;
    %YAML_CPFEM_config_file_2_import = sprintf('config_CPFEM_%s.yaml', ...
    %    gui.config_Matlab.username);
else
    gui.config_CPFEM_file = fullfile(config_CPFEM_path, config_CPFEM_file);
    disp(['User selected :', gui.config_CPFEM_file]);
end
guidata(gcf, gui);

femproc_load_YAML_CPFEM_config_file(gui.config_CPFEM_file);

end