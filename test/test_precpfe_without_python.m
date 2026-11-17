function tests = test_precpfe_without_python
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'gui_preCPFE'), fullfile(root, 'util_gui'), ...
    fullfile(root, 'util'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function setup(testCase)
fig = figure('Visible', 'off');
testCase.TestData.figure = fig;
gui.config.CPFEM.python = preCPFE_check_python('');
gui.config.CPFEM.python_executables = ...
    {fullfile(tempname, 'missing python one'), fullfile(tempname, 'missing python two')};
gui.handles.other_setting.pb_CPFEM_model = ...
    uicontrol(fig, 'Style', 'pushbutton');
guidata(fig, gui);
end

function teardown(testCase)
close(testCase.TestData.figure);
end

function testMissingInterpreterAllowsPreviewState(testCase)
gui = guidata(testCase.TestData.figure);
verifyWarning(testCase, @() check_interpreter(testCase, ...
    gui.config.CPFEM.python_executables{1}), 'STABiX:PythonUnavailable');
verifyFalse(testCase, testCase.TestData.python.exists);
verifyFalse(testCase, testCase.TestData.python.works);
end

function testGenerationIsDisabledWithoutPython(testCase)
fig = testCase.TestData.figure;
preCPFE_config_CPFEM_updated;
gui = guidata(fig);
button = gui.handles.other_setting.pb_CPFEM_model;
verifyEqual(testCase, get(button, 'Enable'), 'off');
verifyError(testCase, @preCPFE_generate_CPFE_model, 'STABiX:PythonUnavailable');
verifyError(testCase, @preCPFE_export_ansys_geometry, 'STABiX:PythonUnavailable');
gui.config.CPFEM.python.works = true;
guidata(fig, gui);
preCPFE_config_CPFEM_updated;
verifyEqual(testCase, get(button, 'Enable'), 'on');
end

function testPopupPersistsUnavailableInterpreterSelection(testCase)
fig = testCase.TestData.figure;
gui = guidata(fig);
popup = preCPFE_python_popup([0.1 0.1 0.5 0.1]);
set(popup, 'Value', 2);
callback = get(popup, 'Callback');
verifyWarning(testCase, @() callback(popup, []), 'STABiX:PythonUnavailable');
updated = guidata(fig);
verifyEqual(testCase, updated.config.CPFEM.python_executable, ...
    gui.config.CPFEM.python_executables{2});
verifyFalse(testCase, updated.config.CPFEM.python.works);
verifyEqual(testCase, get(gui.handles.other_setting.pb_CPFEM_model, 'Enable'), 'off');
end

function check_interpreter(testCase, executable)
testCase.TestData.python = preCPFE_check_python(executable);
end
