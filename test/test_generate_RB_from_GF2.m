function tests = test_generate_RB_from_GF2
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
testCase.TestData.warning = warning('off', 'STABiX:ApproximateVoronoiBoundaries');
addpath(fullfile(root, 'microstructure_generation'), ...
    fullfile(root, 'read_write_ebsd_files'));
testCase.TestData.folder = tempname;
mkdir(testCase.TestData.folder);
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
warning(testCase.TestData.warning);
rmdir(testCase.TestData.folder, 's');
end

function testKnownVoronoiGeometries(testCase)
positions = {[0 0; 2 0], [0 0; 1 0; 2 0], ...
    [0 0; 2 0; 0 2; 2 2], [0 0; 2 2], [0 0; 2 0; 0 2]};
bounds = {[-1 3 -1 1], [-0.5 2.5 -1 1], [-1 3 -1 3], ...
    [-1 3 -1 3], [-1 3 -1 3]};
expected_pairs = {[0 17], [0 17; 17 34], ...
    [0 17; 0 34; 17 51; 34 51], [0 17], [0 17; 0 34; 17 34]};
expected_lengths = {[2], [2; 2], [2; 2; 2; 2], [sqrt(32)], [2; 2; sqrt(8)]};
for index = 1:numel(positions)
    points = positions{index};
    ids = (0:size(points,1)-1)' * 17;
    filename = fullfile(testCase.TestData.folder, sprintf('geometry_%i_GF2.txt', index));
    angles = write_GF2(filename, points, ids);
    original = fileread(filename);
    output = fullfile(testCase.TestData.folder, sprintf('geometry_%i_RB.txt', index));
    current_folder = pwd;
    [data, rb_file] = generate_RB_from_GF2(filename, output, bounds{index});
    verifyEqual(testCase, pwd, current_folder);
    verifyEqual(testCase, rb_file, output);
    verifyEqual(testCase, fileread(filename), original);
    verifyEqual(testCase, sortrows(sort(data.GB2cells, 2)), expected_pairs{index});
    verifyEqual(testCase, sort(data.gb_length), expected_lengths{index}, 'AbsTol', 1e-10);
    check_boundaries(testCase, data, points, ids, angles);
    RB = read_oim_reconstructed_boundaries_file(output);
    verifyEqual(testCase, size(RB.data), [size(expected_pairs{index},1) 14]);
    verifyEqual(testCase, RB.data(:,13:14), data.GB2cells);
    verifyEqual(testCase, RB.data(:,7:12), ...
        [data.gb_length data.gb_trace_angle data.GBvx(:,1) data.GBvy(:,1) ...
        data.GBvx(:,2) data.GBvy(:,2)], 'AbsTol', 1e-9);
    [~, row_right] = ismember(data.GB2cells(:,1), ids);
    [~, row_left] = ismember(data.GB2cells(:,2), ids);
    verifyEqual(testCase, RB.data(:,1:6), ...
        [angles(row_right,:) angles(row_left,:)] * pi/180, 'AbsTol', 1e-10);
end
end

function testDefaultBoundsAndSmallCoordinates(testCase)
filename = fullfile(testCase.TestData.folder, 'small_GF2.txt');
points = [0 0; 2e-5 0];
angles = write_GF2(filename, points, [19; 3], 2e-5);
[data, output] = generate_RB_from_GF2(filename);
verifyEqual(testCase, output, fullfile(testCase.TestData.folder, ...
    'small_GF2_RB_voronoi.txt'));
verifyEqual(testCase, data.bounds, [-1e-5 3e-5 -1e-5 1e-5], 'AbsTol', 1e-16);
check_boundaries(testCase, data, points, [19; 3], angles);
RB = read_oim_reconstructed_boundaries_file(output);
verifyEqual(testCase, RB.data(7), 2e-5, 'AbsTol', 1e-16);
verifyEqual(testCase, RB.data(9:12), [1e-5 -1e-5 1e-5 1e-5], 'AbsTol', 1e-16);
end

function testBoundsWithoutPositiveDiameters(testCase)
filename = fullfile(testCase.TestData.folder, 'no_diameter_GF2.txt');
write_GF2(filename, [0 0; 2 0], [1; 2], 0);
data = generate_RB_from_GF2(filename);
verifyEqual(testCase, data.bounds, [-0.1 2.1 -0.1 0.1], 'AbsTol', 1e-14);
end

function testLegacyWriterWithoutExplicitIDs(testCase)
filename = fullfile(testCase.TestData.folder, 'legacy_GF2.txt');
write_GF2(filename, [0 0; 2 0], [1; 2]);
data = generate_RB_from_GF2(filename);
data = rmfield(data, 'grain_ids');
write_oim_reconstructed_boundaries_file(data, '', ...
    fullfile(testCase.TestData.folder, 'legacy_RB.txt'));
RB = read_oim_reconstructed_boundaries_file('legacy_RB.txt', testCase.TestData.folder);
verifyEqual(testCase, RB.data(:,1:6), ...
    [data.eul_ang(2,:) data.eul_ang(1,:)], 'AbsTol', 1e-10);
verifyEqual(testCase, RB.data(:,13:14), [2 1]);
end

function testInvalidInputsAndOverwriteProtection(testCase)
filename = fullfile(testCase.TestData.folder, 'invalid_GF2.txt');
output = fullfile(testCase.TestData.folder, 'invalid_RB.txt');
write_GF2(filename, [0 0; 2 0], [1; 1]);
verifyError(testCase, @() generate_RB_from_GF2(filename, output), ...
    'STABiX:DuplicateGrainIDs');
write_GF2(filename, [0 0; 0 0], [1; 2]);
verifyError(testCase, @() generate_RB_from_GF2(filename, output), ...
    'STABiX:DuplicateGrainCentres');
write_GF2(filename, [0 0], 1);
verifyError(testCase, @() generate_RB_from_GF2(filename, output), ...
    'STABiX:TooFewGrains');
write_GF2(filename, [0 0; 2 0], [1; 2]);
verifyError(testCase, @() generate_RB_from_GF2(filename, output, [1 0 -1 1]), ...
    'STABiX:InvalidMapBounds');
verifyError(testCase, @() generate_RB_from_GF2(filename, output, [0 1 -1 1]), ...
    'STABiX:GrainsOutsideBounds');
verifyEqual(testCase, exist(output, 'file'), 0);
original = fileread(filename);
verifyError(testCase, @() generate_RB_from_GF2(filename, filename), ...
    'STABiX:RBFileExists');
verifyEqual(testCase, fileread(filename), original);
generate_RB_from_GF2(filename, output);
saved = fileread(output);
verifyError(testCase, @() generate_RB_from_GF2(filename, output), ...
    'STABiX:RBFileExists');
verifyEqual(testCase, fileread(output), saved);
end

function check_boundaries(testCase, data, points, ids, angles)
verifyEqual(testCase, data.eul_ang, angles*pi/180, 'AbsTol', 1e-14);
verifyEqual(testCase, data.grain_ids, ids);
verifyTrue(testCase, all(data.gb_length > 0));
for edge = 1:data.number_of_grain_boundaries
    first = [data.GBvx(edge,1) data.GBvy(edge,1)];
    last = [data.GBvx(edge,2) data.GBvy(edge,2)];
    verifyGreaterThanOrEqual(testCase, [first; last]+1e-12, ...
        repmat(data.bounds([1 3]), 2, 1));
    verifyLessThanOrEqual(testCase, [first; last]-1e-12, ...
        repmat(data.bounds([2 4]), 2, 1));
    midpoint = (first+last)/2;
    distances = sum(bsxfun(@minus, points, midpoint).^2, 2);
    right = find(ids == data.GB2cells(edge,1));
    left = find(ids == data.GB2cells(edge,2));
    verifyEqual(testCase, distances(right), distances(left), 'AbsTol', 1e-10);
    verifyGreaterThanOrEqual(testCase, distances+1e-10, ...
        repmat(distances(right), size(distances)));
    direction = last-first;
    offset_right = points(right,:)-midpoint;
    offset_left = points(left,:)-midpoint;
    verifyLessThan(testCase, det([direction; offset_right]), 0);
    verifyGreaterThan(testCase, det([direction; offset_left]), 0);
    verifyEqual(testCase, data.gb_trace_angle(edge), ...
        mod(atan2d(-direction(2), direction(1)), 180), 'AbsTol', 1e-10);
end
end

function angles = write_GF2(filename, points, ids, diameter)
if nargin < 4
    diameter = 2;
end
[file, message] = fopen(filename, 'w');
assert(file ~= -1, message);
cleanup = onCleanup(@() fclose(file));
fprintf(file, '\n');
fprintf(file, '# Column 1: Integer identifying grain\n');
fprintf(file, '# Column 2-4: Average orientation (phi1, PHI, phi2) in degrees\n');
fprintf(file, '# Column 5-6: Average Position (x, y) in microns\n');
fprintf(file, '# Column 10: An integer identifying the phase\n');
fprintf(file, '# Column 11: Edge grain (1) or interior grain (0)\n');
fprintf(file, '# Column 12: Diameter of grain in microns\n');
angles = reshape(1:3*numel(ids), numel(ids), 3) * 10;
for row = 1:numel(ids)
    fprintf(file, '%i %.12g %.12g %.12g %.12g %.12g 1 1 1 1 1 %.12g\n', ...
        ids(row), angles(row,:), points(row,:), diameter);
end
fprintf(file, '\n');
end
