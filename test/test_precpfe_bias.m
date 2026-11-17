function tests = test_precpfe_bias
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.root = root;
testCase.TestData.original_path = path;
addpath(fullfile(root, 'gui_preCPFE'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function setup(testCase)
testCase.TestData.path_before = path;
for directory = {'abaqus', 'marc_mentat'}
    folder = fullfile(testCase.TestData.root, 'gui_preCPFE', directory{1});
    if any(strcmp(strsplit(path, pathsep), folder))
        rmpath(folder);
    end
end
end

function teardown(testCase)
path(testCase.TestData.path_before);
end

function testMentatHelperLoadsWithoutRecursivePath(testCase)
actual = preCPFE_bias('Mentat_2013.1', 0.075, 0.3, 5, -0.1);
verifyEqual(testCase, actual, [0.075; 0.1128; 0.1542; 0.1992; 0.2478; 0.3], ...
    'AbsTol', 1e-12);
verifyEqual(testCase, which('mentat_bias'), ...
    fullfile(testCase.TestData.root, 'gui_preCPFE', 'marc_mentat', 'mentat_bias.m'));
end

function testAbaqusZeroBiasRemainsUniform(testCase)
actual = preCPFE_bias('Abaqus_2014', 0, 1, 4, 0);
verifyEqual(testCase, actual, [0; 0.25; 0.5; 0.75; 1], 'AbsTol', 1e-12);
verifyEqual(testCase, which('abaqus_bias'), ...
    fullfile(testCase.TestData.root, 'gui_preCPFE', 'abaqus', 'abaqus_bias.m'));
end

function testMentatZeroBiasRemainsUniform(testCase)
verifyEqual(testCase, preCPFE_bias('Mentat_2013.1', 0, 1, 4, 0), ...
    [0; 0.25; 0.5; 0.75; 1], 'AbsTol', 1e-12);
end
