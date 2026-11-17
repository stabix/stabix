function tests = test_bicrystal_min_max
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'gui_bicrystal'));
fixture = tempname;
mkdir(fixture);
testCase.TestData.fixture = fixture;
file = fopen(fullfile(fixture, 'get_config.m'), 'w');
assert(file ~= -1, 'Unable to create plotting test fixture.');
cleanup = onCleanup(@() fclose(file));
fprintf(file, 'function config = get_config\nconfig.matlab_version_year = 2015;\nend\n');
clear cleanup;
addpath(fixture, '-begin');
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
rmdir(testCase.TestData.fixture, 's');
end

function testExtremaForAllPhasePairs(testCase)
phases = {'hcp', 'bcc', 'bct', 'fcc', 'fct'};
ends = {[3 6 9 15 27 33], [12 24 48], [12 24 48], 12, 12};
for a = 1:numel(phases)
    for b = 1:numel(phases)
        rows = ends{a}(end);
        columns = ends{b}(end);
        matrix = reshape(sin(1:rows*columns), rows, columns);
        expected_min = zeros(numel(ends{a}), numel(ends{b}));
        expected_max = expected_min;
        starts_A = [1 ends{a}(1:end-1)+1];
        starts_B = [1 ends{b}(1:end-1)+1];
        for row = 1:numel(ends{a})
            for column = 1:numel(ends{b})
                block = matrix(starts_A(row):ends{a}(row), ...
                    starts_B(column):ends{b}(column));
                values = sort(block(:));
                expected_min(row, column) = values(1);
                expected_max(row, column) = values(end);
            end
        end
        for padded = 0:1
            if padded
                % Match the calculator's square, NaN-padded two-phase matrices.
                data = NaN(max(rows, columns)+24);
                data(1:rows, 1:columns) = matrix;
            else
                data = matrix;
            end
            actual_min = plotGB_Bicrystal_max_min_values_from_matrix(...
                data, phases{a}, phases{b}, 'min');
            actual_max = plotGB_Bicrystal_max_min_values_from_matrix(...
                data, phases{a}, phases{b}, 'max');
            verifyEqual(testCase, actual_min, expected_min);
            verifyEqual(testCase, actual_max, expected_max);
        end
    end
end
end

function testRectangularPlotsAndLabels(testCase)
phases = {'hcp', 'bcc', 'fcc'};
counts = [33 48 12];
labels = {{'bas','pri1<a>','pri2<a>','pyr1<a>','pyr1<a+c>','pyr2<a+c>'}, ...
    {'{110}<111>','{112}<111>','{123}<111>'}, {'{111}<110>'}};
fig = figure('Visible', 'off');
cleanup = onCleanup(@() close(fig));
for a = 1:numel(phases)
    for b = 1:numel(phases)
        if a == b
            continue;
        end
        matrix = reshape(1:counts(a)*counts(b), counts(a), counts(b));
        for mode = 1:2
            clf(fig);
            ax = axes('Parent', fig);
            gui.GB.Phase_A = phases{a};
            gui.GB.Phase_B = phases{b};
            gui.GB.GrainA = 1;
            gui.GB.GrainB = 2;
            gui.flag.LaTeX_flag = false;
            guidata(fig, gui);
            plotGB_Bicrystal_min_max_param_map_plot(matrix, mode);
            result = guidata(fig);
            verifyEqual(testCase, get(ax, 'XTick'), 1:numel(labels{b}));
            verifyEqual(testCase, get(ax, 'YTick'), 1:numel(labels{a}));
            verifyEqual(testCase, result.handles.legend_x, labels{b});
            verifyEqual(testCase, result.handles.legend_y, labels{a});
            if mode == 1
                operation = 'min';
            else
                operation = 'max';
            end
            expected = plotGB_Bicrystal_max_min_values_from_matrix(...
                matrix, phases{a}, phases{b}, operation);
            image = findobj(ax, 'Type', 'image');
            verifyEqual(testCase, get(image, 'CData'), expected);
            verifyEqual(testCase, numel(result.handles.hstrings), numel(expected));
            for index = 1:numel(expected)
                [row, column] = ind2sub(size(expected), index);
                annotation = result.handles.hstrings(index);
                verifyEqual(testCase, get(annotation, 'Position'), [column row 0]);
                verifyEqual(testCase, get(annotation, 'String'), ...
                    sprintf('%0.2f', expected(index)));
            end
        end
    end
end
end

function testInvalidInputsAreReported(testCase)
verifyError(testCase, @() plotGB_Bicrystal_max_min_values_from_matrix(...
    zeros(33, 48), 'hcp', 'bcc', 'median'), 'STABiX:InvalidExtremum');
verifyError(testCase, @() plotGB_Bicrystal_max_min_values_from_matrix(...
    zeros(33, 48), 'hcp', 'unknown', 'min'), 'STABiX:UnsupportedSlipPhase');
verifyError(testCase, @() plotGB_Bicrystal_max_min_values_from_matrix(...
    zeros(12, 33), 'hcp', 'fcc', 'max'), 'STABiX:InvalidSlipMatrixSize');
end
