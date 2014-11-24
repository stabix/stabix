% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function pcell = path2cell(path_str)
%% Splits a Matlab search path string at the pathseparator and returns the
%result as a cellstr
pcell = regexp(path_str, pathsep, 'split');

end