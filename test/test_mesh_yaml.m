function tests = test_mesh_yaml
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.root = root;
testCase.TestData.original_path = path;
testCase.TestData.folder = tempname;
mkdir(testCase.TestData.folder);
addpath(fullfile(root, 'gui_preCPFE'), fullfile(root, 'yaml_functions'), ...
    fullfile(root, 'third_party_code', 'YAMLMatlab_0.4.3'));
for model = {'SX', 'BX'}
    name = ['preCPFE_indentation_setting_' model{1}];
    file = fopen(fullfile(testCase.TestData.folder, [name '.m']), 'w');
    fprintf(file, ['function %s\n' ...
        'gui = guidata(gcf);\n' ...
        'gui.refresh_count = gui.refresh_count + 1;\n' ...
        'guidata(gcf, gui);\nend\n'], name);
    fclose(file);
end
for name = {'uigetfile', 'uiputfile'}
    file = fopen(fullfile(testCase.TestData.folder, [name{1} '.m']), 'w');
    fprintf(file, 'function [name, folder] = %s(varargin)\nname = 0;\nfolder = 0;\nend\n', name{1});
    fclose(file);
end
addpath(testCase.TestData.folder, '-begin');
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
rmdir(testCase.TestData.folder, 's');
end

function testLegacyDefaultsAndStructuredRoundTrip(testCase)
models = {'SX', 'BX'};
solvers = {'Abaqus', 'Mentat'};
filename = fullfile(testCase.TestData.folder, 'round_trip.yaml');
for interface = 1:2
    legacy = read_yaml_struct(fullfile(testCase.TestData.root, 'yaml_config_files', ...
        ['config_mesh_' models{interface} '_defaults.yaml']));
    legacy.derived_coordinates = zeros(10, 3);
    for solver_index = 1:2
        solver = solvers{solver_index};
        [settings, variables] = preCPFE_mesh_settings(legacy, interface, [solver ' 2014']);
        verifyEqual(testCase, variables.box_bias_x, legacy.(['box_bias_x_' lower(solver)]));
        verifyFalse(testCase, isfield(variables, 'derived_coordinates'));
        write_yaml_struct(filename, settings);
        [actual, actual_variables] = preCPFE_mesh_settings(read_yaml_struct(filename), interface, solver);
        verifyEqual(testCase, actual, settings);
        verifyEqual(testCase, actual_variables, variables);
        % Unsuffixed legacy saves must retain their current-solver interpretation.
        verifyEqual(testCase, preCPFE_mesh_settings(variables, interface, solver), settings);
    end
end
end

function testNestedMappingsAndWriteFailures(testCase)
filename = fullfile(testCase.TestData.folder, 'nested.yaml');
data.mesh.counts = [2 3; 4 5];
data.mesh.enabled = true;
data.mesh.empty = struct();
data.label = 'mesh: nested settings';
write_yaml_struct(filename, data);
verifyEqual(testCase, read_yaml_struct(filename), data);
original = fileread(filename);
verifyError(testCase, @() write_yaml_struct(filename, [1 2]), 'STABiX:InvalidYamlRoot');
verifyEqual(testCase, fileread(filename), original);
invalid.callback = @sin;
failed = false;
try
    write_yaml_struct(filename, invalid);
catch exception
    failed = true;
    verifyEqual(testCase, exception.message, 'Cannot handle type: function_handle');
end
verifyTrue(testCase, failed);
verifyEqual(testCase, fileread(filename), original);
verifyError(testCase, @() write_yaml_struct(fullfile(testCase.TestData.folder, ...
    'missing_folder', 'mesh.yaml'), data), 'STABiX:InvalidYamlPath');
verifyError(testCase, @() read_yaml_struct(fullfile(testCase.TestData.folder, ...
    'missing.yaml')), 'STABiX:YamlFileNotFound');
WriteYaml(filename, {1 2});
verifyError(testCase, @() read_yaml_struct(filename), 'STABiX:InvalidYamlRoot');
end

function testValidationBeforeGuiChanges(testCase)
[fig, settings] = make_gui(testCase, 1);
cleanup = onCleanup(@() close(fig));
original = guidata(fig);
control = original.handles.mesh.D_sample_val;
before = get(control, 'String');
filename = fullfile(testCase.TestData.folder, 'invalid.yaml');
invalid = settings;
invalid.mesh.box_bias_x = 'not a number';
write_yaml_struct(filename, invalid);
verifyError(testCase, @() preCPFE_load_mesh(1, filename), 'STABiX:InvalidMeshSetting');
verifyEqual(testCase, get(control, 'String'), before);
verifyEqual(testCase, guidata(fig), original);
invalid = settings;
invalid.mesh = rmfield(invalid.mesh, 'box_elm_nx');
verifyError(testCase, @() preCPFE_mesh_settings(invalid, 1, 'Abaqus'), 'STABiX:MissingMeshSetting');
invalid = settings;
invalid.mesh.box_elm_nx = Inf;
verifyError(testCase, @() preCPFE_mesh_settings(invalid, 1, 'Abaqus'), 'STABiX:InvalidMeshSetting');
invalid = settings;
invalid.solver = 'Mentat';
write_yaml_struct(filename, invalid);
verifyError(testCase, @() preCPFE_load_mesh(1, filename), 'STABiX:MeshSolverMismatch');
verifyEqual(testCase, guidata(fig), original);
invalid = settings;
invalid.model = 'BX';
verifyError(testCase, @() preCPFE_mesh_settings(invalid, 1, 'Abaqus'), 'STABiX:MeshModelMismatch');
invalid = settings;
invalid.schema_version = 2;
verifyError(testCase, @() preCPFE_mesh_settings(invalid, 1, 'Abaqus'), 'STABiX:UnsupportedMeshSchema');
end

function testGuiSavesLiveInputsAndRestoresSettings(testCase)
for interface = 1:2
    [fig, settings] = make_gui(testCase, interface);
    cleanup = onCleanup(@() close(fig));
    gui = guidata(fig);
    set(gui.handles.mesh.h_sample_val, 'String', '8/2');
    set(gui.handles.other_setting.mesh_quality_lvl_val, 'String', '2');
    set(gui.handles.indenter.h_indent_val, 'String', '0.123456789012345');
    if interface == 2
        set(gui.handles.mesh.ind_dist_val, 'String', '-1');
        set(gui.handles.mesh.box_bias_y2_val, 'String', '4');
        gui.variables.box_bias_y2 = -4; % The BX preview can negate this value.
    end
    gui.variables.derived_coordinates = zeros(100, 3);
    guidata(fig, gui);
    filename = fullfile(testCase.TestData.folder, 'gui.yaml');
    preCPFE_save_mesh([], filename);
    saved = read_yaml_struct(filename);
    verifyEqual(testCase, saved.mesh.mesh_quality_lvl, 2);
    verifyEqual(testCase, saved.sample.h_sample, 4);
    verifyEqual(testCase, saved.indenter.h_indent, 0.123456789012345, 'AbsTol', 1e-15);
    verifyFalse(testCase, isfield(saved, 'derived_coordinates'));
    if interface == 2
        verifyEqual(testCase, saved.mesh.box_bias_y2, 4);
        verifyEqual(testCase, saved.sample.ind_dist, -1);
        verifyEqual(testCase, saved.sample.inclination, 80);
        verifyEqual(testCase, saved.indenter.scratchLength, 3);
    end
    set(gui.handles.mesh.h_sample_val, 'String', '999');
    set(gui.handles.indenter.h_indent_val, 'String', '999');
    set(gui.handles.other_setting.mesh_quality_lvl_val, 'String', '999');
    if interface == 2
        set(gui.handles.mesh.inclination_val, 'String', '60');
        set(gui.handles.indenter.scratchLength_val, 'String', '99');
    end
    preCPFE_load_mesh(interface, filename);
    actual = guidata(fig);
    verifyEqual(testCase, actual.refresh_count, 1);
    verifyEqual(testCase, str2double(get(actual.handles.mesh.h_sample_val, 'String')), ...
        settings.sample.h_sample);
    verifyEqual(testCase, actual.variables.mesh_quality_lvl, 2);
    verifyEqual(testCase, str2double(get(actual.handles.indenter.h_indent_val, 'String')), ...
        saved.indenter.h_indent, 'AbsTol', 1e-15);
    if interface == 2
        verifyEqual(testCase, str2double(get(actual.handles.mesh.inclination_val, 'String')), 80);
        verifyEqual(testCase, str2double(get(actual.handles.indenter.scratchLength_val, 'String')), 3);
    end
    clear cleanup;
end
end

function testUnsupportedScratchAndCancelledDialogsDoNotChangeGui(testCase)
[fig, settings] = make_gui(testCase, 2);
cleanup = onCleanup(@() close(fig));
gui = guidata(fig);
gui.handles.indenter = rmfield(gui.handles.indenter, 'scratchLength_val');
guidata(fig, gui);
filename = fullfile(testCase.TestData.folder, 'scratch.yaml');
write_yaml_struct(filename, settings);
before = get(gui.handles.mesh.w_sample_val, 'String');
verifyError(testCase, @() preCPFE_load_mesh(2, filename), 'STABiX:MeshControlMismatch');
verifyEqual(testCase, get(gui.handles.mesh.w_sample_val, 'String'), before);
verifyEqual(testCase, guidata(fig), gui);
preCPFE_load_mesh(2);
preCPFE_save_mesh;
verifyEqual(testCase, guidata(fig), gui);
end

function [fig, settings] = make_gui(testCase, interface)
models = {'SX', 'BX'};
legacy = read_yaml_struct(fullfile(testCase.TestData.root, 'yaml_config_files', ...
    ['config_mesh_' models{interface} '_defaults.yaml']));
legacy.coneAngle = 90;
legacy.tipRadius = 1;
legacy.h_indent = 0.3;
legacy.frictionCoeff = 0.25;
if interface == 2
    legacy.inclination = 80;
    legacy.scratchLength = 3;
    legacy.scratchDirection = 270;
end
[settings, variables] = preCPFE_mesh_settings(legacy, interface, 'Abaqus');
fig = figure('Visible', 'off');
set(groot, 'CurrentFigure', fig);
gui.config.CPFEM.fem_solver_used = 'Abaqus';
gui.variables = variables;
gui.refresh_count = 0;
names = fieldnames(variables);
for index = 1:numel(names)
    name = names{index};
    control = uicontrol(fig, 'Style', 'edit', 'String', num2str(variables.(name), 17));
    if strcmp(name, 'mesh_quality_lvl')
        gui.handles.other_setting.mesh_quality_lvl_val = control;
    elseif strcmp(name, 'frictionCoeff')
        gui.handles.indenter.friction_coeff_val = control;
    elseif isfield(settings.indenter, name)
        gui.handles.indenter.([name '_val']) = control;
    else
        gui.handles.mesh.([name '_val']) = control;
    end
end
guidata(fig, gui);
end
