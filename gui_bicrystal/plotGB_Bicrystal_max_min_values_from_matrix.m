% Copyright 2013 Max-Planck-Institut fuer Eisenforschung GmbH
function [p_max_min_bc] = ...
    plotGB_Bicrystal_max_min_values_from_matrix(...
    matrix, phase_A, phase_B, max_min, varargin)
%% Get extrema for each pair of slip families (rows: grain A, columns: grain B).

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin == 0
    matrix = magic(66);
    phase_A = 'hcp';
    phase_B = 'hcp';
    max_min = 'max';
end

switch max_min
    case 'max'
        reduce = @max;
    case 'min'
        reduce = @min;
    otherwise
        error('STABiX:InvalidExtremum', 'Expected ''min'' or ''max''.');
end

families_A = slip_families(phase_A);
families_B = slip_families(phase_B);
if size(matrix, 1) < families_A{end}(end) || ...
        size(matrix, 2) < families_B{end}(end)
    error('STABiX:InvalidSlipMatrixSize', ...
        'The slip-slip matrix must contain all slip systems for both phases.');
end

p_max_min_bc = zeros(numel(families_A), numel(families_B));
for row = 1:numel(families_A)
    for column = 1:numel(families_B)
        % Ignore trailing twin systems and padding, as in the single-phase maps.
        block = matrix(families_A{row}, families_B{column});
        p_max_min_bc(row, column) = reduce(reduce(block));
    end
end
end

function families = slip_families(phase)
switch phase
    case 'hcp'
        families = {1:3, 4:6, 7:9, 10:15, 16:27, 28:33};
    case {'bcc', 'bct'}
        families = {1:12, 13:24, 25:48};
    case {'fcc', 'fct'}
        families = {1:12};
    otherwise
        error('STABiX:UnsupportedSlipPhase', ...
            'Unsupported crystal phase: %s.', phase);
end
end
