function tests = test_transparent_export
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'util'), fullfile(root, 'util_gui'));
fixture = tempname;
mkdir(fixture);
testCase.TestData.fixture = fixture;
write_function(fullfile(fixture, 'uiputfile.m'), sprintf([ ...
    'function [filename, folder] = uiputfile(varargin)\n' ...
    'setappdata(0, ''STABiXTestDialogArgs'', varargin);\n' ...
    'filename = getappdata(0, ''STABiXTestFilename'');\n' ...
    'folder = tempdir;\nend\n']));
write_function(fullfile(fixture, 'export_fig.m'), sprintf([ ...
    'function export_fig(varargin)\n' ...
    'setappdata(0, ''STABiXTestExportArgs'', varargin);\n' ...
    'if getappdata(0, ''STABiXTestExportError'')\n' ...
    '    error(''STABiXTest:ExportFailed'', ''Export failed'');\n' ...
    'end\nend\n']));
addpath(fixture, '-begin');
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
rmdir(testCase.TestData.fixture, 's');
end

function setup(testCase)
testCase.TestData.figure = figure('Visible', 'off', ...
    'Color', [0.2 0.3 0.4], 'ToolBar', 'none');
setappdata(0, 'STABiXTestFilename', 'transparent.png');
setappdata(0, 'STABiXTestExportArgs', {});
setappdata(0, 'STABiXTestExportError', false);
end

function teardown(testCase)
close(testCase.TestData.figure);
keys = {'STABiXTestFilename', 'STABiXTestExportArgs', ...
    'STABiXTestExportError', 'STABiXTestDialogArgs'};
for index = 1:numel(keys)
    if isappdata(0, keys{index})
        rmappdata(0, keys{index});
    end
end
end

function testToolbarExportsItsOwnFigure(testCase)
target = testCase.TestData.figure;
button = custom_export_toolbar(target);
other = figure('Visible', 'off');
cleanup = onCleanup(@() close(other));
setappdata(0, 'STABiXTestFilename', 'transparent');
callback = get(button, 'ClickedCallback');
callback(button, []);
args = getappdata(0, 'STABiXTestExportArgs');
verifyEqual(testCase, args{1}, fullfile(tempdir, 'transparent.png'));
verifyEqual(testCase, args{2}, target);
verifyEqual(testCase, args(3:4), {'-transparent', '-png'});
verifyEqual(testCase, get(target, 'Color'), [0.2 0.3 0.4]);
dialog = getappdata(0, 'STABiXTestDialogArgs');
verifyEqual(testCase, dialog{1}, {'*.png', 'PNG image (*.png)'});
verifyEqual(testCase, dialog{3}, fullfile(pwd, 'export_fig_out.png'));
end

function testCancelDoesNotExportOrChangeBackground(testCase)
setappdata(0, 'STABiXTestFilename', 0);
save_figure(pwd, testCase.TestData.figure, '-transparent', '-png');
verifyEmpty(testCase, getappdata(0, 'STABiXTestExportArgs'));
verifyEqual(testCase, get(testCase.TestData.figure, 'Color'), [0.2 0.3 0.4]);
end

function testRejectsNonPngTransparentExport(testCase)
setappdata(0, 'STABiXTestFilename', 'opaque.jpg');
verifyError(testCase, @() save_figure(pwd, testCase.TestData.figure, ...
    '-transparent', '-png'), 'STABiX:TransparentExportFormat');
verifyEmpty(testCase, getappdata(0, 'STABiXTestExportArgs'));
end

function testOrdinaryExportRestoresBackgroundOnFailure(testCase)
setappdata(0, 'STABiXTestExportError', true);
verifyError(testCase, @() save_figure(pwd, testCase.TestData.figure), ...
    'STABiXTest:ExportFailed');
verifyEqual(testCase, get(testCase.TestData.figure, 'Color'), [0.2 0.3 0.4]);
end

function write_function(filename, contents)
file = fopen(filename, 'w');
assert(file ~= -1, 'Unable to create export test fixture.');
cleanup = onCleanup(@() fclose(file));
fprintf(file, '%s', contents);
end
