function [fdata, rb_file] = generate_RB_from_GF2(gf2_file, rb_file, bounds)
%GENERATE_RB_FROM_GF2 Approximate missing boundaries with a 2-D Voronoi map.
%   generate_RB_from_GF2 opens a GF type 2 .txt file selection dialog.
%   generate_RB_from_GF2(gf2_file) writes <input_name>_RB_voronoi.txt next
%   to the input. Existing files are never overwritten.
%   generate_RB_from_GF2(gf2_file, rb_file, bounds) clips boundaries to
%   [xmin xmax ymin ymax], in the GF2 coordinate system and units (microns).
%   With no bounds, the centre bounding box is expanded by half the median
%   positive grain diameter, or 5 percent of the largest centre span.
%   Returned fdata contains the data passed to the OIM RB writer.
%
%   These are synthetic straight boundaries, not measured EBSD boundaries.

fdata = struct();
if nargin == 0
    [filename, folder] = uigetfile('*.txt', 'Select Grain File Type 2');
    if isequal(filename, 0)
        rb_file = '';
        disp('User selected Cancel');
        return;
    end
    gf2_file = fullfile(folder, filename);
end
if exist(gf2_file, 'file') ~= 2
    error('STABiX:MissingGF2File', 'GF2 file not found: %s.', gf2_file);
end
if nargin < 2 || isempty(rb_file)
    [folder, filename] = fileparts(gf2_file);
    rb_file = fullfile(folder, [filename '_RB_voronoi.txt']);
end
if exist(rb_file, 'file') || exist(rb_file, 'dir')
    error('STABiX:RBFileExists', ...
        'Output already exists; choose a different RB filename: %s.', rb_file);
end
output_folder = fileparts(rb_file);
if ~isempty(output_folder) && exist(output_folder, 'dir') ~= 7
    error('STABiX:MissingOutputFolder', 'Output folder not found: %s.', output_folder);
end

GF2 = read_oim_grain_file_type2(gf2_file);
required = {'INT_ID_GRAIN', 'AVG_ORI', 'AVG_POS_XY'};
if ~all(isfield(GF2.col_idx, required))
    error('STABiX:InvalidGF2Columns', ...
        'GF2 must identify grain ID, average orientation and average position columns.');
end
grain_ids = GF2.data(:, GF2.col_idx.INT_ID_GRAIN);
positions = GF2.data(:, GF2.col_idx.AVG_POS_XY);
orientations = GF2.data(:, GF2.col_idx.AVG_ORI);
validateattributes(grain_ids, {'numeric'}, ...
    {'column', 'integer', 'nonnegative', 'finite'});
validateattributes(positions, {'numeric'}, ...
    {'2d', 'ncols', 2, 'real', 'finite'});
validateattributes(orientations, {'numeric'}, ...
    {'2d', 'ncols', 3, 'real', 'finite'});
if numel(grain_ids) < 2
    error('STABiX:TooFewGrains', 'At least two grains are needed for internal boundaries.');
end
if numel(unique(grain_ids)) ~= numel(grain_ids)
    error('STABiX:DuplicateGrainIDs', 'GF2 grain IDs must be unique.');
end
if size(unique(positions, 'rows'), 1) ~= size(positions, 1)
    error('STABiX:DuplicateGrainCentres', 'GF2 grain centres must be distinct.');
end

if nargin < 3 || isempty(bounds)
    margin = [];
    if isfield(GF2, 'DIAM')
        diameters = GF2.DIAM(isfinite(GF2.DIAM) & GF2.DIAM > 0);
        if ~isempty(diameters)
            margin = median(diameters) / 2;
        end
    end
    if isempty(margin)
        margin = 0.05 * max(max(positions) - min(positions));
    end
    lower = min(positions) - margin;
    upper = max(positions) + margin;
    bounds = [lower(1) upper(1) lower(2) upper(2)];
end
validateattributes(bounds, {'numeric'}, {'real', 'finite', 'vector', 'numel', 4});
if bounds(1) >= bounds(2) || bounds(3) >= bounds(4)
    error('STABiX:InvalidMapBounds', 'Bounds must satisfy xmin < xmax and ymin < ymax.');
end
if any(positions(:,1) < bounds(1) | positions(:,1) > bounds(2) | ...
        positions(:,2) < bounds(3) | positions(:,2) > bounds(4))
    error('STABiX:GrainsOutsideBounds', 'All GF2 grain centres must lie inside the bounds.');
end
warning('STABiX:ApproximateVoronoiBoundaries', ...
    ['Generating approximate Voronoi boundaries from grain centres, not measured ' ...
    'boundaries. Clipping bounds: [%g %g %g %g].'], bounds);

[start_points, end_points, pairs] = clipped_voronoi(positions, bounds);
if isempty(pairs)
    error('STABiX:NoVoronoiBoundaries', 'No nonzero internal boundaries were found.');
end
delta = end_points - start_points;
fdata.title = 'Approximate Voronoi boundaries generated from GF type 2';
fdata.grain_ids = grain_ids;
fdata.eul_ang = orientations * pi / 180;
fdata.GBvx = [start_points(:,1) end_points(:,1)];
fdata.GBvy = [start_points(:,2) end_points(:,2)];
% The directed bisector has the second seed on its right, the first on its left.
fdata.GB2cells = [grain_ids(pairs(:,2)) grain_ids(pairs(:,1))];
fdata.gb_length = hypot(delta(:,1), delta(:,2));
% OIM scan y points down; trace angles use the horizontal after y reversal.
fdata.gb_trace_angle = mod(atan2d(-delta(:,2), delta(:,1)), 180);
fdata.number_of_grain_boundaries = size(pairs, 1);
fdata.bounds = bounds;
write_oim_reconstructed_boundaries_file(fdata, '', rb_file);
fprintf('Approximate RB file saved as: %s\n', rb_file);
end

function [start_points, end_points, pairs] = clipped_voronoi(positions, bounds)
% Normalize isotropically to retain Euclidean distances at different map scales.
offset = [bounds(1) bounds(3)];
scale = max([bounds(2)-bounds(1) bounds(4)-bounds(3)]);
points = bsxfun(@rdivide, bsxfun(@minus, positions, offset), scale);
box = [0 (bounds(2)-bounds(1))/scale 0 (bounds(4)-bounds(3))/scale];

centred = bsxfun(@minus, points, points(1,:));
if rank(centred) < 2
    [~, axis_index] = max(max(points) - min(points));
    [~, order] = sort(points(:,axis_index));
    candidates = sort([order(1:end-1) order(2:end)], 2);
else
    triangles = delaunay(points(:,1), points(:,2));
    candidates = unique(sort([triangles(:,[1 2]); triangles(:,[2 3]); ...
        triangles(:,[3 1])], 2), 'rows');
end
start_points = zeros(size(candidates, 1), 2);
end_points = start_points;
pairs = zeros(size(candidates));
count = 0;
tolerance = 64 * eps;
for index = 1:size(candidates, 1)
    a = candidates(index, 1);
    b = candidates(index, 2);
    normal = points(b,:) - points(a,:);
    direction = [-normal(2) normal(1)] / norm(normal);
    midpoint = (points(a,:) + points(b,:)) / 2;
    relative = bsxfun(@minus, points, points(a,:));

    % Intersect the bisector with every nearest-seed half-plane and the box.
    coefficients = relative * direction';
    limits = sum(relative.^2, 2)/2 - relative * (midpoint-points(a,:))';
    coefficients([a b]) = 0;
    limits([a b]) = 0;
    coefficients = [coefficients; direction(1); -direction(1); ...
        direction(2); -direction(2)];
    limits = [limits; box(2)-midpoint(1); midpoint(1)-box(1); ...
        box(4)-midpoint(2); midpoint(2)-box(3)];
    parallel = abs(coefficients) <= tolerance;
    if any(limits(parallel) < -tolerance)
        continue;
    end
    positive = coefficients > tolerance;
    negative = coefficients < -tolerance;
    first = max(limits(negative) ./ coefficients(negative));
    last = min(limits(positive) ./ coefficients(positive));
    % Cocircular seeds can introduce Delaunay diagonals with zero-length duals.
    if last - first <= tolerance
        continue;
    end
    count = count + 1;
    start_points(count,:) = midpoint + first * direction;
    end_points(count,:) = midpoint + last * direction;
    pairs(count,:) = [a b];
end
start_points = bsxfun(@plus, start_points(1:count,:) * scale, offset);
end_points = bsxfun(@plus, end_points(1:count,:) * scale, offset);
pairs = pairs(1:count,:);
end
