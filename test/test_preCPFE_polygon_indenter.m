function tests = test_preCPFE_polygon_indenter
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'gui_preCPFE'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function setup(testCase)
testCase.TestData.figure = figure('Visible', 'off');
end

function teardown(testCase)
close(testCase.TestData.figure);
end

function testZeroRadiusPreservesSharpGeometry(testCase)
[~, defaultMesh] = preCPFE_3d_polygon_indenter(3, 65.3, 1, -0.5);
[~, zeroRadiusMesh] = ...
    preCPFE_3d_polygon_indenter(3, 65.3, 1, -0.5, 0);

verifyEqual(testCase, defaultMesh.vertices, zeroRadiusMesh.vertices);
verifyEqual(testCase, defaultMesh.faces, zeroRadiusMesh.faces);
verifyEqual(testCase, size(defaultMesh.faces), [3 3]);
end

function testRoundedPyramidalMeshes(testCase)
shapes = [3 65.3; 4 68; 3 35.26];
tipRadius = 0.1;
height = 1;
zShift = -0.5;

for i = 1:size(shapes, 1)
    [handle, mesh] = preCPFE_3d_polygon_indenter( ...
        shapes(i, 1), shapes(i, 2), height, zShift, tipRadius);
    vertices = mesh.vertices;
    faces = mesh.faces;

    verifyTrue(testCase, isgraphics(handle));
    verifyEqual(testCase, size(faces, 2), 3);
    verifyGreaterThan(testCase, size(faces, 1), shapes(i, 1));
    verifyEqual(testCase, min(vertices(:, 3)), zShift, 'AbsTol', 1e-12);
    verifyEqual(testCase, max(vertices(:, 3)), ...
        zShift + tipRadius + height, 'AbsTol', 1e-12);
    verifyTrue(testCase, all(ismember((1:size(vertices, 1))', faces(:))));

    edge1 = vertices(faces(:, 2), :) - vertices(faces(:, 1), :);
    edge2 = vertices(faces(:, 3), :) - vertices(faces(:, 1), :);
    areas = sqrt(sum(cross(edge1, edge2, 2).^2, 2)) / 2;
    verifyTrue(testCase, all(areas > 0));
    delete(handle);
end
end

function testNegativeTipRadiusIsRejected(testCase)
verifyError(testCase, ...
    @() preCPFE_3d_polygon_indenter(3, 65.3, 1, 0, -0.1), ...
    'preCPFE_3d_polygon_indenter:InvalidTipRadius');
end
