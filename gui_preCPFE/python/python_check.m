% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function python = python_check(python_loc, numpy_check_path, scipy_check_path)
%% Check Python installation
% python_loc: Python executable
%
% author: c.zambaldi@mpie.de

if nargin < 3
    scipy_check_path = fullfile('gui_preCPFE', 'python', 'scipy_check.py');
end

if nargin < 2
    numpy_check_path = fullfile('gui_preCPFE', 'python', 'numpy_check.py');
end

if nargin < 1
    python_loc = 'python';
end

python = struct;
python.location = python_loc;
python.exists = ~ system(sprintf('%s -c "exit()"', python_loc));
python.finds_numpy = ~ system(sprintf('%s -c "import numpy"', python_loc));
python.finds_scipy = ~ system(sprintf('%s -c "import scipy"', python_loc));
%python.finds_msc = ~ system('python -c "import msc"');

cmd = sprintf('%s %s', python_loc, numpy_check_path);
commandwindow;
disp(cmd);
python.numpy_version = strtrim(evalc('system(cmd);'));

cmd = sprintf('%s %s', python_loc, scipy_check_path);
commandwindow;
disp(cmd);
python.scipy_version = strtrim(evalc('system(cmd);'));

cmd = sprintf('%s --version', python_loc);
commandwindow;
disp(cmd);
python.version = strtrim(evalc('system(cmd);'));

%if all(cell2mat(struct2cell(python)))
if all([python.exists, python.finds_numpy])
    python.works = true;
else
    python.works = false;
end
%python

end