function tests = test_set_opengl
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

function testModernMatlabSkipsDefaultOpenGLSetup(testCase)
assumeFalse(testCase, verLessThan('matlab', '25.1'));
verifyEqual(testCase, set_opengl(), struct([]));
end

function testModernMatlabIgnoresLegacyRendererModes(testCase)
assumeFalse(testCase, verLessThan('matlab', '25.1'));
for mode = {'software', 'hardware', 'autoselect'}
    verifyEqual(testCase, set_opengl(mode{1}), struct([]));
end
end
