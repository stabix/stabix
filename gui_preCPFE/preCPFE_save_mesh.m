% Copyright 2013 Max-Planck-Institut fuer Eisenforschung GmbH
function preCPFE_save_mesh(mesh_to_save, filename)
%PRECPFE_SAVE_MESH Save editable settings as a versioned, grouped YAML mapping.
%   With no data argument (or []), read current GUI controls, not derived arrays.
%   The old preCPFE_save_mesh(variables) call remains supported.
gui = guidata(gcf);
if isfield(gui.handles.mesh, 'D_sample_val')
    interface = 1;
else
    interface = 2;
end
if nargin < 1 || isempty(mesh_to_save)
    mesh_to_save = struct();
    for group = {'mesh', 'indenter'}
        handles = gui.handles.(group{1});
        names = fieldnames(handles);
        for index = 1:numel(names)
            name = names{index};
            if length(name) > 4 && strcmp(name(end-3:end), '_val')
                field = name(1:end-4);
                if strcmp(field, 'friction_coeff')
                    field = 'frictionCoeff';
                end
                mesh_to_save.(field) = str2num(get(handles.(name), 'String'));
            end
        end
    end
    mesh_to_save.mesh_quality_lvl = str2num(...
        get(gui.handles.other_setting.mesh_quality_lvl_val, 'String'));
end
settings = preCPFE_mesh_settings(mesh_to_save, interface, ...
    gui.config.CPFEM.fem_solver_used);
if nargin < 2
    [name, folder] = uiputfile('*.yaml', 'Save mesh settings');
    if isequal(name, 0) || isequal(folder, 0)
        disp('User selected Cancel');
        return;
    end
    filename = fullfile(folder, name);
end
write_yaml_struct(filename, settings);
end
