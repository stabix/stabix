% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_set_CPFEM_solver
%% Function to set CPFEM solver used
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gdata = guidata(gcf);

%% Setting of the FEM interface
gdata.config.CPFEM.fem_interface_val = get(gdata.handles.other_setting.pm_FEM_interface, 'Value');
gdata.config.CPFEM.fem_interface_all_str = get(gdata.handles.other_setting.pm_FEM_interface, 'String');
gdata.config.CPFEM.fem_solver_str_cell = gdata.config.CPFEM.fem_interface_all_str(gdata.config.CPFEM.fem_interface_val);
gdata.config.CPFEM.fem_solver_used = gdata.config.CPFEM.fem_solver_str_cell{:};
if strcmp(strtok(gdata.config.CPFEM.fem_solver_used, '_'), 'Abaqus') == 1
    gdata.config.CPFEM.fem_solver_version = sscanf(gdata.config.CPFEM.fem_solver_used, 'Abaqus_%f');
elseif strcmp(strtok(gdata.config.CPFEM.fem_solver_used, '_'), 'Mentat') == 1
    gdata.config.CPFEM.fem_solver_version = sscanf(gdata.config.CPFEM.fem_solver_used, 'Mentat_%f');
end

guidata(gcf, gdata);

end