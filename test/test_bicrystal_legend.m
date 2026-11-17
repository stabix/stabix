function tests = test_bicrystal_legend
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'gui_bicrystal'), fullfile(root, 'crystallo'), ...
    fullfile(root, 'util'), fullfile(root, 'util_gui'), fullfile(root, 'test'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function setup(testCase)
fig = figure('Visible', 'off');
testCase.TestData.figure = fig;
gui.handles.pmchoiceplot = uicontrol(fig, 'Style', 'popupmenu', ...
    'String', {'Unit cells'}, 'Value', 1);
gui.handles.cblegend = uicontrol(fig, 'Style', 'checkbox', 'Value', 1);
gui.handles.pmlegend_location = uicontrol(fig, 'Style', 'popupmenu', ...
    'String', listLocationLegend, 'Value', 1);
testCase.TestData.axes = axes('Parent', fig);
hold(testCase.TestData.axes, 'on');
gui.flag.LaTeX_flag = false;
gui.GB.Phase_A = 'bcc';
gui.GB.Phase_B = 'bcc';
gui.GB.GrainA = 1;
gui.GB.GrainB = 2;
gui.GB.eulerA = [0 0 0];
gui.GB.eulerB = [23 41 17];
gui.GB_geometry.perp_gb = [1;0;0];
gui.calculations.vectA = zeros(60,6,2);
gui.calculations.vectB = zeros(60,6,2);
gui.calculations.vectA(25,:,1) = [0 0 1 1 0 0];
gui.calculations.vectB(13,:,2) = [0 1 0 1 0 0];
guidata(fig, gui);
end

function teardown(testCase)
close(testCase.TestData.figure);
end

function testPlainLegendIgnoresLaterTracesAndLines(testCase)
verify_stable_legend(testCase, false);
end

function testLatexLegendIgnoresLaterTracesAndLines(testCase)
verify_stable_legend(testCase, true);
end

function testNoSlipDoesNotConfigureNonexistentLegend(testCase)
plotGB_Bicrystal_plot_lattices(25, 13, true);
verifyEmpty(testCase, findall(testCase.TestData.figure, 'Type', 'legend'));
end

function verify_stable_legend(testCase, latex_flag)
fig = testCase.TestData.figure;
gui = guidata(fig);
gui.flag.LaTeX_flag = latex_flag;
guidata(fig, gui);
plotGB_Bicrystal_plot_lattices(25, 13, false);
leg = findall(fig, 'Type', 'legend');
labels = get(leg, 'String');
verifyNumElements(testCase, labels, 2);
plot_slip_traces(25, gui.GB.eulerA, 'bcc', 1, [1;0;0], 2, 0.5);
plot_slip_traces(13, gui.GB.eulerB, 'bcc', 1, [-1;0;0], 2, 0.5);
plot3(testCase.TestData.axes, [0 1], [0 0], [0 0], 'k');
plot3(testCase.TestData.axes, [0 0], [0 1], [0 0], 'k');
plot3(testCase.TestData.axes, [0 0], [0 0], [0 1], 'k');
drawnow;
verifyEqual(testCase, get(leg, 'String'), labels);
verifyEqual(testCase, get(leg, 'Location'), 'north');
if latex_flag
    verifyEqual(testCase, get(leg, 'Interpreter'), 'latex');
else
    verifyEqual(testCase, get(leg, 'Interpreter'), 'none');
end
end
