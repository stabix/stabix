function tests = test_convert_ctf_square_to_hex
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'microstructure_generation'), ...
    fullfile(root, 'read_write_ebsd_files'));
testCase.TestData.folder = tempname;
mkdir(testCase.TestData.folder);
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
rmdir(testCase.TestData.folder, 's');
end

function testHexGeometryAndMultiphaseRoundTrip(testCase)
input = fullfile(testCase.TestData.folder, 'multiphase.ctf');
source = make_scan(4, 3, 1, 1, [0 0]);
write_ctf(input, source, [4 3 1 1], true);
original = fileread(input);
current_folder = pwd;
[data, output] = convert_ctf_square_to_hex(input);
verifyEqual(testCase, output, fullfile(testCase.TestData.folder, 'multiphase_hex.ang'));
verifyEqual(testCase, pwd, current_folder);
verifyEqual(testCase, fileread(input), original);
verifyEqual(testCase, data.source_index, [1:4 6:8 9:12]');
verifyEqual(testCase, [data.n_col_odd data.n_col_even data.n_rows], [4 3 3]);
verifyEqual(testCase, data.x_pixel_pos, [0 1 2 3 0.5 1.5 2.5 0 1 2 3]');
verifyEqual(testCase, data.y_pixel_pos, ...
    [zeros(1,4) repmat(sqrt(3)/2,1,3) repmat(sqrt(3),1,4)]', 'AbsTol', 1e-12);
verify_samples(testCase, data, source);
ang = read_oim_ang_file(output);
verifyEqual(testCase, ang.data, [data.eul_ang data.x_pixel_pos data.y_pixel_pos ...
    data.image_quality data.confidence_index data.phase_ang ...
    data.detector_intensity data.fit], 'AbsTol', 1e-9);
text = fileread(output);
verifyNotEmpty(testCase, strfind(text, '# GRID: HexGrid'));
verifyNotEmpty(testCase, strfind(text, '# NCOLS_ODD: 4'));
verifyNotEmpty(testCase, strfind(text, '# NCOLS_EVEN: 3'));
verifyNotEmpty(testCase, strfind(text, '# NROWS: 3'));
verifyNotEmpty(testCase, strfind(text, '# MaterialName Ferrite'));
verifyNotEmpty(testCase, strfind(text, '# MaterialName Alpha Ti'));
verifyNotEmpty(testCase, strfind(text, '# Symmetry 43'));
verifyNotEmpty(testCase, strfind(text, '# Symmetry 62'));
verifyEqual(testCase, data.phases(2).lattice, [2.95 2.95 4.68 90 90 120]);
end

function testCustomStepUnorderedRowsAndNonzeroOrigin(testCase)
input = fullfile(testCase.TestData.folder, 'unordered.ctf');
output = fullfile(testCase.TestData.folder, 'custom_hex.ang');
source = make_scan(4, 3, 1, 1, [-10 20]);
source = source([12:-2:2 11:-2:1],:);
write_ctf(input, source, [4 3 1 1], false);
data = convert_ctf_square_to_hex(input, output, 0.75);
verifyEqual(testCase, [data.n_col_odd data.n_col_even data.n_rows], [5 4 4]);
verifyEqual(testCase, data.x_step, 0.75);
verifyEqual(testCase, data.y_step, 0.75*sqrt(3)/2);
verify_samples(testCase, data, source);
end

function testSmallAndAnisotropicScanSteps(testCase)
cases = {[4 3 1e-5 1e-5], [4 5 2 1.5]};
for index = 1:numel(cases)
    grid = cases{index};
    source = make_scan(grid(1), grid(2), grid(3), grid(4), [0 0]);
    input = fullfile(testCase.TestData.folder, sprintf('spacing_%d.ctf', index));
    write_ctf(input, source, grid, false);
    data = convert_ctf_square_to_hex(input);
    verifyEqual(testCase, data.x_step, grid(3));
    verify_samples(testCase, data, source);
end
end

function testRoundedCTFCoordinatesAndStepHeaders(testCase)
input = fullfile(testCase.TestData.folder, 'rounded.ctf');
step = 0.124997558665273;
source = make_scan(4, 3, step, step, [0 0]);
source(:,2:3) = round(source(:,2:3)*1e4)/1e4;
write_ctf(input, source, [4 3 step step], true);
data = convert_ctf_square_to_hex(input);
verify_samples(testCase, data, source);
end

function testInvalidGridsAndOverwriteProtection(testCase)
input = fullfile(testCase.TestData.folder, 'invalid.ctf');
output = fullfile(testCase.TestData.folder, 'protected.ang');
source = make_scan(4, 3, 1, 1, [0 0]);
write_ctf(input, source(1:end-1,:), [4 3 1 1], false);
verifyError(testCase, @() convert_ctf_square_to_hex(input, output), ...
    'STABiX:InvalidCTFGrid');
duplicate = source;
duplicate(end,2:3) = duplicate(1,2:3);
write_ctf(input, duplicate, [4 3 1 1], false);
verifyError(testCase, @() convert_ctf_square_to_hex(input, output), ...
    'STABiX:InvalidCTFGrid');
irregular = source;
irregular(2,2) = 1.2;
write_ctf(input, irregular, [4 3 1 1], false);
verifyError(testCase, @() convert_ctf_square_to_hex(input, output), ...
    'STABiX:InvalidCTFGrid');
write_ctf(input, source, [4 3 1 1], false);
verifyError(testCase, @() convert_ctf_square_to_hex(input, output, 10), ...
    'STABiX:HexStepTooLarge');
verifyEqual(testCase, exist(output, 'file'), 0);
original = fileread(input);
verifyError(testCase, @() convert_ctf_square_to_hex(input, input), ...
    'STABiX:ANGFileExists');
verifyEqual(testCase, fileread(input), original);
convert_ctf_square_to_hex(input, output);
saved = fileread(output);
verifyError(testCase, @() convert_ctf_square_to_hex(input, output), ...
    'STABiX:ANGFileExists');
verifyEqual(testCase, fileread(output), saved);
end

function verify_samples(testCase, data, source)
sampled = source(data.source_index,:);
verifyEqual(testCase, data.eul_ang, sampled(:,6:8)*pi/180, 'AbsTol', 1e-12);
verifyEqual(testCase, data.phase_ang, sampled(:,1));
verifyEqual(testCase, data.image_quality, sampled(:,10));
verifyEqual(testCase, data.fit, sampled(:,9));
verifyEqual(testCase, data.confidence_index, -double(sampled(:,1) == 0));
points = [data.x_pixel_pos data.y_pixel_pos];
tolerance = max(max(source(:,2:3))-min(source(:,2:3))) * 1e-10;
verifyGreaterThanOrEqual(testCase, points+tolerance, ...
    repmat(min(source(:,2:3)),size(points,1),1));
verifyLessThanOrEqual(testCase, points-tolerance, ...
    repmat(max(source(:,2:3)),size(points,1),1));
for index = 1:size(points,1)
    distances = sum(bsxfun(@minus, source(:,2:3), points(index,:)).^2,2);
    verifyEqual(testCase, distances(data.source_index(index)), min(distances), ...
        'AbsTol', max(tolerance^2, 1e-20));
end
end

function source = make_scan(nx, ny, dx, dy, origin)
[x, y] = meshgrid(origin(1)+(0:nx-1)*dx, origin(2)+(0:ny-1)*dy);
index = (1:nx*ny)';
source = [mod(index,3) reshape(x',[],1) reshape(y',[],1) ...
    8*ones(size(index)) zeros(size(index)) 10*index 20+index 30+index ...
    index/10 100+index 200+index];
end

function write_ctf(filename, source, grid, decimal_comma)
[file, message] = fopen(filename, 'w');
assert(file ~= -1, message);
cleanup = onCleanup(@() fclose(file));
fprintf(file, 'Channel Text File\nPrj Test\nAuthor Test\nJobMode Grid\n');
header = sprintf('XCells %d\nYCells %d\nXStep %.12g\nYStep %.12g\n', grid);
if decimal_comma
    header = strrep(header, '.', ',');
end
fprintf(file, '%s', header);
fprintf(file, 'AcqE1 0\nAcqE2 0\nAcqE3 0\n\n');
fprintf(file, 'Phases 2\n');
fprintf(file, '2.866;2.866;2.866\t90;90;90\tFerrite\t11\t229\n');
fprintf(file, '2.95;2.95;4.68\t90;90;120\tAlpha Ti\t9\t194\n');
fprintf(file, 'Phase\tX\tY\tBands\tError\tEuler1\tEuler2\tEuler3\tMAD\tBC\tBS\n');
text = sprintf('%.12g %.12g %.12g %.12g %.12g %.12g %.12g %.12g %.12g %.12g %.12g\n', source');
if decimal_comma
    text = strrep(text, '.', ',');
end
fprintf(file, '%s', text);
end
