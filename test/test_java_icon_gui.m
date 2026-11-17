function tests = test_java_icon_gui
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'util_gui'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function testModernMatlabSkipsJavaFrameForExplicitFigure(testCase)
assumeFalse(testCase, verLessThan('matlab', '25.1'));
fig = figure('Visible', 'off');
cleanup = onCleanup(@() close(fig));
verifyWarning(testCase, @() java_icon_gui(fig), ...
    'STABiX:CustomIconUnavailable');
verifyTrue(testCase, isgraphics(fig, 'figure'));
end

function testModernMatlabSupportsNoArgumentCall(testCase)
assumeFalse(testCase, verLessThan('matlab', '25.1'));
verifyWarning(testCase, @() java_icon_gui(), ...
    'STABiX:CustomIconUnavailable');
end
