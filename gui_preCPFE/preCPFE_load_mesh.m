% Copyright 2013 Max-Planck-Institut fuer Eisenforschung GmbH
function preCPFE_load_mesh(interface, filename)
%PRECPFE_LOAD_MESH Load structured or legacy YAML mesh settings into the GUI.
%   interface is 1 for SX and 2 for BX. An optional filename skips the dialog.
if nargin < 2
    [name, folder] = uigetfile('*.yaml', 'Load mesh settings');
    if isequal(name, 0) || isequal(folder, 0)
        disp('User selected Cancel');
        return;
    end
    filename = fullfile(folder, name);
end

parent = gcf;
gui = guidata(parent);
[~, variables] = preCPFE_mesh_settings(read_yaml_struct(filename), ...
    interface, gui.config.CPFEM.fem_solver_used);
names = fieldnames(variables);
controls = cell(size(names));
% Resolve every control before changing any GUI state.
for index = 1:numel(names)
    name = [names{index} '_val'];
    if strcmp(names{index}, 'mesh_quality_lvl')
        controls{index} = gui.handles.other_setting.mesh_quality_lvl_val;
    elseif strcmp(names{index}, 'frictionCoeff')
        controls{index} = gui.handles.indenter.friction_coeff_val;
    elseif isfield(gui.handles.mesh, name)
        controls{index} = gui.handles.mesh.(name);
    elseif isfield(gui.handles.indenter, name)
        controls{index} = gui.handles.indenter.(name);
    else
        error('STABiX:MeshControlMismatch', ...
            'The current GUI does not support setting %s. Check the test type.', names{index});
    end
end
for index = 1:numel(names)
    set(controls{index}, 'String', num2str(variables.(names{index}), 17));
    gui.variables.(names{index}) = variables.(names{index});
end
guidata(parent, gui);
if interface == 1
    preCPFE_indentation_setting_SX;
else
    preCPFE_indentation_setting_BX;
end
end
