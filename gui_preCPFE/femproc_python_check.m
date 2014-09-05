function python = femproc_python_check(python_loc)
%%
if nargin < 1
    python_loc = 'python'
end
python = struct;
python.location = python_loc;
python.exists = ~ system(sprintf('%s -c "exit()"', python_loc));
python.finds_numpy = ~ system(sprintf('%s -c "import numpy"', python_loc));
%python.finds_msc = ~ system('python -c "import msc"');
cmd = sprintf('%s --version', python_loc);
python.version = strtrim(evalc('system(cmd);'));

%if all(cell2mat(struct2cell(python)))
if all([python.exists, python.finds_numpy])
    python.works = true;
else
    python.works = false;
    python
end