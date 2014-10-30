% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function cellstr_out = cellstr_filter(cellstring, filter_cell_or_str)
%% Delete all entries of a cell array of string that math the filter
% filter can be string or cellstr
% maybe could be implemented faster by using "regexprep", TODO...

if ~ iscellstr(filter_cell_or_str)
    if isstr(filter_cell_or_str)
        filter_cell = {filter_cell_or_str};
    else
        error('takes only CELLSTRs or STRs as filter');
    end
else
    filter_cell = filter_cell_or_str;
end

cellstr_out = {};

for el_idx = 1:numel(cellstring);
    stritem = cellstring(el_idx);
    for fstr_idx = 1:numel(filter_cell)
        fstr = filter_cell(fstr_idx);
         % strcmpi instead of strfind to load folders in the Matlab search
         % paths, named for instance "foldername.git"
        if strfind(stritem{1}, fstr{1})
            %stritem{1} % show filtered item
            continue % don't add filtered elements
        else
            cellstr_out{end+1} = stritem{1};
        end
    end
end
%filtered_ = numel(cellstring) - numel(cellstr_out)