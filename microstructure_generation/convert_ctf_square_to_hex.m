function [fdata, ang_file] = convert_ctf_square_to_hex(ctf_file, ang_file, step_size)
%CONVERT_CTF_SQUARE_TO_HEX Resample a rectangular HKL scan to hexagonal ANG.
%   convert_ctf_square_to_hex opens a CTF file selection dialog.
%   [fdata, ang_file] = convert_ctf_square_to_hex(ctf_file) writes
%   <input_name>_hex.ang without overwriting existing files.
%   convert_ctf_square_to_hex(ctf_file, ang_file, step_size) sets the
%   horizontal hex spacing in the input coordinate units (normally microns).
%   The default is the CTF XStep; vertical spacing is sqrt(3)/2 * step_size.
%
%   Nearest-neighbour sampling copies orientations and phases, including
%   unindexed pixels, without averaging. fdata.source_index identifies the
%   original CTF data row for each output point. No toolbox is required.
%   Euler angles retain the CTF reference frame, converted to radians only.
%   BC is exported as IQ, MAD as Fit; CI is 0 for indexed and -1 otherwise.
%   These are not measured OIM quality/confidence values.
%   Resampling does not reconstruct boundaries or recover spatial detail.
%   See https://github.com/stabix/stabix/issues/57.

fdata = struct();
if nargin == 0
    [filename, folder] = uigetfile('*.ctf', 'Select square-grid HKL scan');
    if isequal(filename, 0)
        ang_file = '';
        disp('User selected Cancel');
        return;
    end
    ctf_file = fullfile(folder, filename);
end
if exist(ctf_file, 'file') ~= 2
    error('STABiX:MissingCTFFile', 'CTF file not found: %s.', ctf_file);
end
if nargin < 2 || isempty(ang_file)
    [folder, filename] = fileparts(ctf_file);
    ang_file = fullfile(folder, [filename '_hex.ang']);
end
if exist(ang_file, 'file') || exist(ang_file, 'dir')
    error('STABiX:ANGFileExists', ...
        'Output already exists; choose a different ANG filename: %s.', ang_file);
end
[output_folder, ~, extension] = fileparts(ang_file);
if ~strcmpi(extension, '.ang')
    error('STABiX:InvalidANGFilename', 'The output filename must end in .ang.');
end
if ~isempty(output_folder) && exist(output_folder, 'dir') ~= 7
    error('STABiX:MissingOutputFolder', 'Output folder not found: %s.', output_folder);
end

[data, header, phases, columns] = read_ctf(ctf_file);
required = {'Phase', 'X', 'Y', 'Euler1', 'Euler2', 'Euler3', 'MAD', 'BC'};
[found, col] = ismember(required, columns);
if ~all(found)
    error('STABiX:InvalidCTFColumns', ...
        'CTF data must contain Phase, X, Y, Euler1, Euler2, Euler3, MAD and BC.');
end
validateattributes(data(:,col), {'numeric'}, {'real', 'finite', 'nonempty'});
phase = data(:,col(1));
if any(phase ~= fix(phase) | phase < 0 | phase > numel(phases))
    error('STABiX:InvalidCTFPhase', 'CTF phase IDs must be integers from 0 to Phases.');
end
nx = header.XCells;
ny = header.YCells;
dx = header.XStep;
dy = header.YStep;
validateattributes([nx ny], {'numeric'}, {'integer', 'finite', '>=', 2});
validateattributes([dx dy], {'numeric'}, {'positive', 'finite'});
if size(data,1) ~= nx * ny
    error('STABiX:InvalidCTFGrid', 'The CTF must contain XCells * YCells data rows.');
end
x = data(:,col(2));
y = data(:,col(3));
[x_axis, ~, ix] = unique(x);
[y_axis, ~, iy] = unique(y);
if numel(x_axis) ~= nx || numel(y_axis) ~= ny
    error('STABiX:InvalidCTFGrid', 'CTF coordinates do not form the declared rectangular grid.');
end
x0 = x_axis(1);
y0 = y_axis(1);
% CTF exporters round coordinates independently of their step-size headers.
tolerance = max(0.01 * min(dx,dy), 64 * eps(max(abs([x; y]))));
if any(abs(x-(x0+(ix-1)*dx)) > tolerance | abs(y-(y0+(iy-1)*dy)) > tolerance)
    error('STABiX:InvalidCTFGrid', 'CTF coordinates do not form the declared regular grid.');
end
grid_index = (iy-1)*nx + ix;
if numel(unique(grid_index)) ~= nx*ny
    error('STABiX:InvalidCTFGrid', 'CTF grid points must be complete and unique.');
end
lookup = zeros(nx*ny,1);
lookup(grid_index) = (1:size(data,1))';
if nargin < 3 || isempty(step_size)
    step_size = dx;
end
validateattributes(step_size, {'numeric'}, {'scalar', 'real', 'finite', 'positive'});
hex_dy = sqrt(3)/2 * step_size;
span_x = (max(x)-x0)/step_size;
span_y = (max(y)-y0)/hex_dy;
roundoff = 64 * eps(max([1 span_x span_y]));
fdata.n_col_odd = floor(span_x + roundoff) + 1;
fdata.n_col_even = floor(span_x - 0.5 + roundoff) + 1;
fdata.n_rows = floor(span_y + roundoff) + 1;
if fdata.n_col_even < 1 || fdata.n_rows < 2
    error('STABiX:HexStepTooLarge', ...
        'The hex step must allow at least two rows and one point on shifted rows.');
end
counts = repmat(fdata.n_col_odd, fdata.n_rows, 1);
counts(2:2:end) = fdata.n_col_even;
fdata.x_pixel_pos = zeros(sum(counts),1);
fdata.y_pixel_pos = zeros(sum(counts),1);
first = 1;
for row = 0:fdata.n_rows-1
    last = first + counts(row+1) - 1;
    fdata.x_pixel_pos(first:last) = ...
        min(x0 + ((0:counts(row+1)-1)' + mod(row,2)/2)*step_size, x_axis(end));
    fdata.y_pixel_pos(first:last) = min(y0 + row*hex_dy, y_axis(end));
    first = last + 1;
end
ix = interp1(x_axis, 1:nx, fdata.x_pixel_pos, 'nearest');
iy = interp1(y_axis, 1:ny, fdata.y_pixel_pos, 'nearest');
fdata.source_index = lookup((iy-1)*nx + ix);
sampled = data(fdata.source_index,col);
fdata.eul_ang = sampled(:,4:6) * pi/180;
fdata.phase_ang = sampled(:,1);
fdata.image_quality = sampled(:,8);
fdata.fit = sampled(:,7);
fdata.confidence_index = -double(fdata.phase_ang == 0);
fdata.detector_intensity = zeros(size(sampled,1),1);
fdata.x_step = step_size;
fdata.y_step = hex_dy;
fdata.phases = phases;
write_hex_ang(fdata, ang_file);
fprintf('Hexagonal scan saved as: %s\n', ang_file);
end

function [data, header, phases, columns] = read_ctf(filename)
[file, message] = fopen(filename, 'r');
if file == -1
    error('STABiX:ReadCTFFailed', 'Cannot open CTF file: %s.', message);
end
cleanup = onCleanup(@() fclose(file));
line = fgetl(file);
if ~ischar(line) || ~strcmp(strtrim(line), 'Channel Text File')
    error('STABiX:InvalidCTFHeader', 'Expected a Channel Text File header.');
end
header = struct();
phases = struct('name', {}, 'lattice', {}, 'symmetry', {});
columns = {};
while ~feof(file)
    line = fgetl(file);
    if ~ischar(line)
        break;
    end
    line = strtrim(line);
    if ~isempty(regexp(line, '^Phase\s+X\s+Y\s+', 'once'))
        columns = regexp(line, '\s+', 'split');
        break;
    end
    token = regexp(line, '^(XCells|YCells|XStep|YStep)\s+(\S+)$', 'tokens', 'once');
    if ~isempty(token)
        header.(token{1}) = str2double(strrep(token{2}, ',', '.'));
    end
    token = regexp(line, '^Phases\s+(\d+)$', 'tokens', 'once');
    if ~isempty(token)
        number = str2double(token{1});
        for index = 1:number
            phase_line = fgetl(file);
            if ~ischar(phase_line)
                error('STABiX:InvalidCTFHeader', 'Truncated CTF phase table.');
            end
            phases(index) = read_phase(phase_line);
        end
    end
end
if isempty(columns) || isempty(phases) || ...
        ~all(isfield(header, {'XCells', 'YCells', 'XStep', 'YStep'}))
    error('STABiX:InvalidCTFHeader', 'Missing CTF grid, phase table or column header.');
end
body = strrep(fread(file, Inf, '*char')', ',', '.');
values = textscan(body, repmat('%f', 1, numel(columns)), ...
    'CollectOutput', true, 'ReturnOnError', false);
data = values{1};
end

function phase = read_phase(line)
parts = regexp(strtrim(line), '\t+', 'split');
if numel(parts) < 4
    error('STABiX:InvalidCTFPhase', 'Expected a tab-separated CTF phase description.');
end
abc = sscanf(strrep(parts{1}, ',', '.'), '%f;%f;%f');
angles = sscanf(strrep(parts{2}, ',', '.'), '%f;%f;%f');
laue = str2double(parts{4});
if numel(abc) ~= 3 || numel(angles) ~= 3 || ...
        any(~isfinite([abc; angles])) || any(abc <= 0) || ...
        any(angles <= 0 | angles >= 180) || ~ismember(laue, 1:11)
    error('STABiX:InvalidCTFPhase', 'Invalid CTF lattice parameters or Laue group.');
end
tsl_symmetry = [1 2 22 4 42 3 32 6 62 23 43];
phase.name = parts{3};
phase.lattice = [abc; angles]';
phase.symmetry = tsl_symmetry(laue);
end

function write_hex_ang(data, filename)
[file, message] = fopen(filename, 'w');
if file == -1
    error('STABiX:WriteANGFailed', 'Cannot open ANG output: %s.', message);
end
cleanup = onCleanup(@() fclose(file));
fprintf(file, '# VERSION 5\n');
fprintf(file, '# Resampled from HKL CTF by STABiX (nearest neighbour)\n');
fprintf(file, '# Euler angles retain the CTF sample reference frame\n');
fprintf(file, '# IQ = CTF BC; Fit = CTF MAD; CI = 0 indexed, -1 unindexed\n');
fprintf(file, '# SEM signal unavailable (0); detector calibration unavailable\n');
for index = 1:numel(data.phases)
    phase = data.phases(index);
    fprintf(file, '# Phase %d\n', index);
    fprintf(file, '# MaterialName %s\n', phase.name);
    fprintf(file, '# Symmetry %d\n', phase.symmetry);
    fprintf(file, '# LatticeConstants %.12g %.12g %.12g %.12g %.12g %.12g\n', phase.lattice);
    fprintf(file, '# NumberFamilies 0\n');
end
fprintf(file, '# GRID: HexGrid\n');
fprintf(file, '# XSTEP: %.12g\n# YSTEP: %.12g\n', data.x_step, data.y_step);
fprintf(file, '# NCOLS_ODD: %d\n# NCOLS_EVEN: %d\n# NROWS: %d\n', ...
    data.n_col_odd, data.n_col_even, data.n_rows);
values = [data.eul_ang data.x_pixel_pos data.y_pixel_pos data.image_quality ...
    data.confidence_index data.phase_ang data.detector_intensity data.fit];
fprintf(file, '%.12g %.12g %.12g %.12g %.12g %.12g %d %d %.12g %.12g\n', values');
[message, number] = ferror(file);
if number ~= 0
    error('STABiX:WriteANGFailed', 'Cannot write ANG output: %s.', message);
end
end
