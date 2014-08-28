% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [pmax1, xmax1, ymax1, pmax2, xmax2, ymax2, pmax3, xmax3, ymax3,...
    pmin1, xmin1, ymin1, pmin2, xmin2, ymin2, pmin3, xmin3, ymin3] = sort_values(matrix, varargin)
%% Function used to sort values (max and min) from a given matrix and to get indices of these values
% matrix : a N-by-N matrix of values given for a specific parameter
% pmax1 : 1st highest value
% xmax1 : row of the 1st highest value
% ymax1 : col of the 1st highest value
% pmax2 : 2nd highest value
% xmax2 : row of the 2nd highest value
% ymax2 : col of the 2nd highest value
% pmax3 : 3rd highest value
% xmax3 : row of the 3rd highest value
% ymax3 : col of the 3rd highest value
% pmin1 : 1st lowest value
% xmin1 : row of the 1st lowest value
% ymin1 : col of the 1st lowest value
% pmin2 : 2nd lowest value
% xmin2 : row of the 2nd lowest value
% ymin2 : col of the 2nd lowest value
% pmin3 : 3rd lowest value
% xmin3 : row of the 3rd lowest value
% ymin3 : col of the 3rd lowest value

if nargin < 1
    matrix = magic(5);
end

matrix_max = matrix;
matrix_min = matrix;

for ii = 1:size(matrix,1)
    for jj = 1:size(matrix,2)
        if isnan(matrix(ii,jj)) == 1
            matrix_max(ii,jj) = -Inf;
        end
    end
end

sort_param_col(:,:) = sort((matrix_max(:,:)), 1, 'descend');                          % sort matrix (by columns)
[sort_param_1stline(:,:), param_index_1] = sort(sort_param_col(1,:), 'descend');      % sort 1st line of values (maximum of each columns)
sort_param_row(:,:) = sort((matrix_max(:,:)), 2, 'descend');                          % sort matrix (by rows)
[sort_param_1stcol(:,:), param_index_2] = sort(sort_param_row(:,1), 'descend');       % sort 1st column of values (maximum of each columns)

sort_param_all(:,:) = sort((sort((matrix_max(:,:)), 1, 'descend')), 2, 'descend');

pmax1 = sort_param_all(1,1);                      % 1st highest value
pmax2 = sort_param_all(2,1);                      % 2nd highest value
pmax3 = sort_param_all(3,1);                      % 3rd highest value
xmax1 = param_index_2(1);                         % row of the 1st highest value
ymax1 = param_index_1(1);                         % col of the 1st highest value
xmax2 = param_index_2(2);                         % row of the 2nd highest value
ymax2 = param_index_1(2);                         % col of the 2nd highest value
xmax3 = param_index_2(3);                         % row of the 3rd highest value
ymax3 = param_index_1(3);                         % col of the 3rd highest value

for ii = 1:size(matrix,1)
    for jj = 1:size(matrix,2)
        if isnan(matrix(ii,jj)) == 1
            matrix_min(ii,jj) = Inf;
        end
    end
end

sort_param_col(:,:) = sort((matrix_min(:,:)), 1, 'ascend');                          % sort matrix (by columns)
[sort_param_1stline(:,:), param_index_1] = sort(sort_param_col(1,:), 'ascend');      % sort 1st line of values (maximum of each columns)
sort_param_row(:,:) = sort((matrix_min(:,:)), 2, 'ascend');                          % sort matrix (by rows)
[sort_param_1stcol(:,:), param_index_2] = sort(sort_param_row(:,1), 'ascend');       % sort 1st column of values (maximum of each columns)

sort_param_all(:,:) = sort((sort((matrix_min(:,:)), 1, 'ascend')), 2, 'ascend');

pmin1 = sort_param_all(1,1);                    % 1st lowest value
pmin2 = sort_param_all(2,1);                    % 2nd lowest value
pmin3 = sort_param_all(3,1);                    % 3rd lowest value
xmin1 = param_index_2(1);                       % row of the 1st lowest value
ymin1 = param_index_1(1);                       % col of the 1st lowest value
xmin2 = param_index_2(2);                       % row of the 2nd lowest value
ymin2 = param_index_1(2);                       % col of the 2nd lowest value
xmin3 = param_index_2(3);                       % row of the 3rd lowest value
ymin3 = param_index_1(3);                       % col of the 3rd lowest value

end