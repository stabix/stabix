% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [python_executable, python_checked] = ...
    preCPFE_python_select(handle_pm_Python)
%% Get Python installation selected
% handle_pm_Python: Handle of the popup menu for Python executables

% author: c.zambaldi@mpie.de

python_executable_list = get(handle_pm_Python, 'String');
python_executable_selected = get(handle_pm_Python, 'Value');

python_executable = python_executable_list(python_executable_selected);
python_executable = python_executable{:};

python_checked = python_check(python_executable);

preCPFE_config_CPFEM_updated;

end