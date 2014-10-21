% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function python = femproc_python_check(python_loc)
%% Check Python installation
% python_loc: Python executable

% author: c.zambaldi@mpie.de

if nargin < 1
    python_loc = 'python';
end

python = struct;
python.location = python_loc;
python.exists = ~ system(sprintf('%s -c "exit()"', python_loc));
python.finds_numpy = ~ system(sprintf('%s -c "import numpy"', python_loc));
%python.finds_msc = ~ system('python -c "import msc"');
cmd = sprintf('%s --version', python_loc);
python.version = strtrim(evalc('system(cmd);'));

% TODO ==> which to change ?
python.which_all = strtrim(evalc('system(''which -a python'');'));
if ~isempty(python.which_all)
    [tok, remain] = strtok(python.which_all);
    python.which = {tok};
    while ~isempty(remain)
        [tok, remain] = strtok(remain);
        python.which{end+1} = tok;
    end
end

%if all(cell2mat(struct2cell(python)))
if all([python.exists, python.finds_numpy])
    python.works = true;
else
    python.works = false;
    python
end

end