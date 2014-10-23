function pcell = path2cell(path_str)
%splits a matlab search path string at the pathseparator and returns the
%result as a cellstr
pcell = regexp(path_str, pathsep, 'split');
