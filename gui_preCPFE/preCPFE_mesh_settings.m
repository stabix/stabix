function [settings, variables] = preCPFE_mesh_settings(data, interface, fem_solver)
%PRECPFE_MESH_SETTINGS Validate and normalize structured or legacy mesh settings.
validateattributes(interface, {'numeric'}, {'scalar', 'integer', '>=', 1, '<=', 2});
if ~isstruct(data) || ~isscalar(data)
    error('STABiX:InvalidMeshSettings', 'Mesh settings must be a single mapping.');
end
models = {'SX', 'BX'};
model = models{interface};
if ~isempty(strfind(fem_solver, 'Abaqus'))
    solver = 'Abaqus';
elseif ~isempty(strfind(fem_solver, 'Mentat'))
    solver = 'Mentat';
else
    error('STABiX:UnsupportedMeshSolver', 'Unsupported mesh solver: %s.', fem_solver);
end

if interface == 1
    sample_fields = {'D_sample', 'h_sample', 'r_center_frac', 'box_xfrac', 'box_zfrac'};
    mesh_fields = {'sample_rep', 'box_elm_nx', 'box_elm_nz', 'radial_divi', 'mesh_quality_lvl'};
    bias_fields = {'box_bias_x', 'box_bias_z', 'box_bias_conv_x'};
else
    sample_fields = {'w_sample', 'h_sample', 'len_sample', 'ind_dist', 'inclination'};
    mesh_fields = {'box_elm_nx', 'box_elm_nz', 'box_elm_ny1', 'box_elm_ny2', ...
        'box_elm_ny3', 'mesh_quality_lvl'};
    bias_fields = {'box_bias_x', 'box_bias_z', 'box_bias_y1', 'box_bias_y2', 'box_bias_y3'};
end
mesh_fields = [mesh_fields bias_fields];
indenter_fields = {'coneAngle', 'tipRadius', 'pyramidTipRadius', ...
    'h_indent', 'frictionCoeff'};
if interface == 2
    indenter_fields = [indenter_fields {'scratchLength', 'scratchDirection'}];
end
groups = {'sample', 'mesh', 'indenter'};
fields_by_group = {sample_fields, mesh_fields, indenter_fields};

if isfield(data, 'schema_version')
    if ~isnumeric(data.schema_version) || ~isequal(data.schema_version, 1)
        error('STABiX:UnsupportedMeshSchema', 'Supported mesh schema_version is 1.');
    end
    if ~isfield(data, 'model') || ~ischar(data.model) || ...
            ~isrow(data.model) || ~strcmp(data.model, model)
        error('STABiX:MeshModelMismatch', 'Load %s settings in the matching GUI.', model);
    end
    if ~isfield(data, 'solver') || ~ischar(data.solver) || ...
            ~isrow(data.solver) || ~strcmp(data.solver, solver)
        error('STABiX:MeshSolverMismatch', 'Mesh settings must use the current solver, %s.', solver);
    end
    variables = struct();
    for group_index = 1:numel(groups)
        group = groups{group_index};
        if ~isfield(data, group) || ~isstruct(data.(group)) || ~isscalar(data.(group))
            error('STABiX:InvalidMeshSettings', '%s must be a mapping.', group);
        end
        names = fieldnames(data.(group));
        if ~all(ismember(names, fields_by_group{group_index}))
            error('STABiX:UnknownMeshSetting', 'Unrecognized setting in %s.', group);
        end
        for index = 1:numel(names)
            variables.(names{index}) = data.(group).(names{index});
        end
    end
else
    % Old defaults use solver suffixes; old saved files use unsuffixed names.
    variables = data;
    for index = 1:numel(bias_fields)
        field = bias_fields{index};
        legacy_field = [field '_' lower(solver)];
        if isfield(data, legacy_field)
            variables.(field) = data.(legacy_field);
        end
    end
end

if ~isfield(variables, 'pyramidTipRadius')
    variables.pyramidTipRadius = 0;
end

required = [sample_fields mesh_fields];
required(strcmp(required, 'inclination')) = [];
for index = 1:numel(required)
    if ~isfield(variables, required{index})
        error('STABiX:MissingMeshSetting', 'Missing mesh setting: %s.', required{index});
    end
end
settings.schema_version = 1;
settings.model = model;
settings.solver = solver;
normalized = struct();
for group_index = 1:numel(groups)
    group = groups{group_index};
    settings.(group) = struct();
    names = fields_by_group{group_index};
    for index = 1:numel(names)
        name = names{index};
        if isfield(variables, name)
            value = variables.(name);
            if ~isnumeric(value) || ~isreal(value) || ~isscalar(value) || ~isfinite(value)
                error('STABiX:InvalidMeshSetting', '%s must be a finite numeric scalar.', name);
            end
            if (~isempty(strfind(name, 'box_elm_')) || ...
                    ismember(name, {'sample_rep', 'radial_divi', 'mesh_quality_lvl', ...
                    'D_sample', 'w_sample', 'h_sample', 'len_sample', 'h_indent'})) && value <= 0
                error('STABiX:InvalidMeshSetting', '%s must be positive.', name);
            end
            if (~isempty(strfind(name, 'box_elm_')) || ...
                    ismember(name, {'sample_rep', 'radial_divi'})) && value ~= round(value)
                error('STABiX:InvalidMeshSetting', '%s must be an integer.', name);
            end
            if strcmp(name, 'pyramidTipRadius') && value < 0
                error('STABiX:InvalidMeshSetting', ...
                    '%s must be nonnegative.', name);
            end
            settings.(group).(name) = value;
            normalized.(name) = value;
        end
    end
end
variables = normalized;
end
