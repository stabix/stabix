% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [python_executable, python_checked] = ...
    preCPFE_python_select(handle_pm_Python)
%% Get Python installation selected
% handle_pm_Python: Handle of the popup menu for Python executables

% author: c.zambaldi@mpie.de

gui = guidata(gcf);

python_executable = ...
    get_value_popupmenu(handle_pm_Python, get(handle_pm_Python, 'String'));

python_executable = python_executable{:};

python_checked = python_check(python_executable);

gui.config.CPFEM.python = python_checked;
guidata(gcf, gui);

preCPFE_config_CPFEM_updated;

end