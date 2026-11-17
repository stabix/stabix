function tests = test_tetragonal_support
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'crystallo'), fullfile(root, 'crystal_plasticity'), ...
    fullfile(root, 'test'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function testDirectAndReciprocalMetrics(testCase)
indices = cat(3, [1 1 1; 0 1 -1], [1 0 1; 1 0 -1], NaN(2,3));
for phase = {'bct', 'fct'}
    actual = slip_systems_to_cartesian(indices, phase{1}, 2);
    verifyEqual(testCase, actual(:,:,1), [1 1 0.5; 0 1 -2]);
    verifyEqual(testCase, actual(:,:,2), [1 0 0.5; 1 0 -2]);
    verifyTrue(testCase, all(all(isnan(actual(:,:,3)))));
    for index = 1:2
        verifyEqual(testCase, dot(actual(1,:,index), actual(2,:,index)), 0);
    end
    verifyEqual(testCase, slip_systems_to_cartesian(indices, phase{1}, 1), indices);
    verifyError(testCase, @() slip_systems_to_cartesian(indices, phase{1}, 0), ...
        'MATLAB:expectedPositive');
end
verifyEqual(testCase, slip_systems_to_cartesian(indices, 'fcc', 2), indices);
verifyEqual(testCase, slip_systems_to_cartesian(indices, 'bcc', 2), indices);
end

function testMaterialSlipCalculations(testCase)
materials = {'Sn', 'In', 'TiAl'};
phases = {'bct', 'bct', 'fct'};
euler = [23 41 17];
rotation = eulers2g(euler);
stress.sigma = diag([0 0 1]);
stress.sigma_n = stress.sigma;
for material = 1:numel(materials)
    phase = phases{material};
    indices = slip_systems(phase, 1);
    [actual, flag] = vector_calculations(1, materials{material}, ...
        phase, euler, indices, stress);
    verifyEqual(testCase, flag, 0);
    lattice = listLattParam(materials{material}, phase);
    valid = find(~isnan(reshape(indices(1,1,:), [], 1)));
    for row = valid'
        normal = indices(1,:,row) .* [1 1 1/lattice(1)];
        direction = indices(2,:,row) .* [1 1 lattice(1)];
        expected_normal = (rotation' * normal' / norm(normal))';
        expected_direction = (rotation' * direction' / norm(direction))';
        verifyEqual(testCase, actual(row,1:3), expected_normal, 'AbsTol', 1e-12);
        verifyEqual(testCase, actual(row,4:6), expected_direction, 'AbsTol', 1e-12);
        verifyEqual(testCase, actual(row,7:9), (rotation'*direction')', 'AbsTol', 1e-12);
        verifyEqual(testCase, dot(actual(row,1:3), actual(row,4:6)), 0, 'AbsTol', 1e-12);
        expected_shear = expected_normal(3) * expected_direction(3);
        verifyEqual(testCase, actual(row,13), expected_shear, 'AbsTol', 1e-12);
        verifyEqual(testCase, actual(row,15), expected_shear, 'AbsTol', 1e-12);
    end
    missing = find(isnan(reshape(indices(1,1,:), [], 1)));
    verifyTrue(testCase, all(all(isnan(actual(missing,1:12)))));
end
end

function testExistingHcpAndCubicConversions(testCase)
hexagonal = [0 0 0 1; 2 -1 -1 0];
verifyEqual(testCase, slip_systems_to_cartesian(hexagonal, 'hcp', 1.6), ...
    [0 0 1/1.6; 3 0 0], 'AbsTol', 1e-12);
cubic = cat(3, [1 1 1; 0 1 -1], [1 1 0; 1 -1 1]);
verifyEqual(testCase, slip_systems_to_cartesian(cubic, 'fcc', 1), cubic);
verifyEqual(testCase, slip_systems_to_cartesian(cubic, 'bcc', 1), cubic);
end

function testTiAlComplianceAndTetragonalYoungsModulus(testCase)
stiffness = [0.190 0.105 0.090 0.185 0.120 0.050];
compliance = listElasticConstants('TiAl', 'fct');
verifyEqual(testCase, voigt_matrix(compliance) * voigt_matrix(stiffness), ...
    eye(6), 'AbsTol', 1e-12);
verifyEqual(testCase, stiffness_to_compliance('TiAl', 'fct'), ...
    stiffness, 'AbsTol', 1e-12);
materials = {'Sn', 'In', 'TiAl'};
phases = {'bct', 'bct', 'fct'};
for index = 1:numel(materials)
    S = voigt_matrix(listElasticConstants(materials{index}, phases{index})) * 1e-3;
    for euler = {[0 0 0], [23 41 17]}
        actual = youngs_modulus(materials{index}, phases{index}, euler{1});
        verifyTrue(testCase, all(isfinite(actual) & actual > 0));
        rotation = eulers2g(euler{1});
        for axis_index = 1:3
            d = rotation(:,axis_index);
            load = [d(1)^2 d(2)^2 d(3)^2 d(2)*d(3) d(1)*d(3) d(1)*d(2)];
            expected = 1 / (load * S * load');
            verifyEqual(testCase, actual(axis_index), expected, 'RelTol', 1e-12);
        end
    end
end
end

function testSurfaceTraceUsesTetragonalNormal(testCase)
fig = figure('Visible', 'off');
cleanup = onCleanup(@() close(fig));
euler = [23 41 17];
rotation = eulers2g(euler);
for phase = {'bct', 'fct'}
    clf(fig);
    handles = plot_slip_traces(1, euler, phase{1}, 2, [0;0;0], 2, 0.5);
    indices = slip_systems(phase{1}, 1);
    normal = rotation' * (indices(1,:,1) .* [1 1 0.5])';
    expected = cross(normal, [0;0;1]);
    expected = expected / norm(expected);
    x = get(handles(1), 'XData');
    y = get(handles(1), 'YData');
    z = get(handles(1), 'ZData');
    verifyEqual(testCase, [x(1); y(1); z(1)], expected, 'AbsTol', 1e-12);
end
end

function matrix = voigt_matrix(constants)
s = constants;
matrix = [s(1) s(2) s(3) 0 0 0; s(2) s(1) s(3) 0 0 0; ...
    s(3) s(3) s(4) 0 0 0; 0 0 0 s(5) 0 0; ...
    0 0 0 0 s(5) 0; 0 0 0 0 0 s(6)];
end
