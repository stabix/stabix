function tests = test_transparent_export
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'util'), fullfile(root, 'util_gui'), ...
    fullfile(root, 'third_party_code', 'export_fig'));
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
    'fig = varargin{2};\n' ...
    'setappdata(0, ''STABiXTestExportControls'', numel(findall(fig, ''Type'', ''uicontrol'')));\n' ...
    'setappdata(0, ''STABiXTestExportAxes'', numel(findall(fig, ''Type'', ''axes'')));\n' ...
    'setappdata(0, ''STABiXTestExportLines'', findall(fig, ''Type'', ''line''));\n' ...
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
ax = axes('Parent', testCase.TestData.figure);
plot(ax, [0 1], [1 0]);
setappdata(0, 'STABiXTestFilename', 'transparent.png');
setappdata(0, 'STABiXTestExportArgs', {});
setappdata(0, 'STABiXTestExportError', false);
end

function teardown(testCase)
close(testCase.TestData.figure);
keys = {'STABiXTestFilename', 'STABiXTestExportArgs', ...
    'STABiXTestExportError', 'STABiXTestDialogArgs', ...
    'STABiXTestExportControls', 'STABiXTestExportAxes', ...
    'STABiXTestExportLines'};
for index = 1:numel(keys)
    if isappdata(0, keys{index})
        rmappdata(0, keys{index});
    end
end
end

function testToolbarExportsItsOwnFigure(testCase)
target = testCase.TestData.figure;
control = uicontrol(target, 'Style', 'pushbutton', 'String', 'Keep me');
button = custom_export_toolbar(target);
other = figure('Visible', 'off');
cleanup = onCleanup(@() close(other));
setappdata(0, 'STABiXTestFilename', 'transparent');
callback = get(button, 'ClickedCallback');
callback(button, []);
args = getappdata(0, 'STABiXTestExportArgs');
verifyEqual(testCase, args{1}, fullfile(tempdir, 'transparent.png'));
verifyNotEqual(testCase, args{2}, target);
verifyFalse(testCase, isgraphics(args{2}));
verifyEqual(testCase, getappdata(0, 'STABiXTestExportControls'), 0);
verifyEqual(testCase, getappdata(0, 'STABiXTestExportAxes'), 1);
verifyNumElements(testCase, getappdata(0, 'STABiXTestExportLines'), 1);
verifyTrue(testCase, isgraphics(control));
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

function testTransparentExportCleansUpCopyOnFailure(testCase)
target = testCase.TestData.figure;
uicontrol(target, 'Style', 'pushbutton');
figures_before = findall(0, 'Type', 'figure');
setappdata(0, 'STABiXTestExportError', true);
verifyError(testCase, @() save_figure(pwd, target, '-transparent', '-png'), ...
    'STABiXTest:ExportFailed');
verifyEqual(testCase, getappdata(0, 'STABiXTestExportControls'), 0);
verifyEqual(testCase, findall(0, 'Type', 'figure'), figures_before);
verifyEqual(testCase, get(target, 'Color'), [0.2 0.3 0.4]);
end

function testTransparentExportRejectsFigureWithoutPlots(testCase)
target = testCase.TestData.figure;
delete(findall(target, 'Type', 'axes'));
uicontrol(target, 'Style', 'pushbutton');
verifyError(testCase, @() save_figure(pwd, target, '-transparent', '-png'), ...
    'STABiX:NoPlotsToExport');
verifyEmpty(testCase, getappdata(0, 'STABiXTestExportArgs'));
end

function write_function(filename, contents)
file = fopen(filename, 'w');
assert(file ~= -1, 'Unable to create export test fixture.');
cleanup = onCleanup(@() fclose(file));
fprintf(file, '%s', contents);
end
