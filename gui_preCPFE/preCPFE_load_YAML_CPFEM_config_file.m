% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_load_YAML_CPFEM_config_file(...
    YAML_CPFEM_config_file_2_import)
%% Function to import YAML CPFEM config. file file

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

gui.config.CPFEM = ...
    configs_merge(gui.config.CPFEM, gui.config.CPFEM.defaults);
if exist(YAML_CPFEM_config_file_2_import, 'file')
    gui.config.CPFEM.user_config = ...
        ReadYaml(gui.config.CPFEM.config_file_user_full);
    gui.config.CPFEM = ...
        configs_merge(gui.config.CPFEM, gui.config.CPFEM.user_config);
end

gui.config.CPFEM = preCPFE_config_CPFEM_check(gui.config.CPFEM);

preCPFE_set_cpfem_interface_pm(gui.handles.other_setting.pm_FEM_interface, ...
    gui.config.CPFEM.fem_solvers, gui.config.CPFEM.fem_solver_used);

preCPFE_set_CPFEM_solver;

guidata(gcf, gui)

end