% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function pstr = cell2path(p_cstr)
%joins a matlab search path cell string with the pathseparator and returns the
%result as a STR

if ~iscellstr(p_cstr)
    error('Only accepts CELLSTR');
end

pstr = '';

for item_idx = 1:numel(p_cstr)
    item = p_cstr(item_idx);
    pstr = [pstr, pathsep, item{1}];
end
