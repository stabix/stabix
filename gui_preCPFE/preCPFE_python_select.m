% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function python_executable = preCPFE_python_select
%% Get Python installation selected

gui = guidata(gcf);

python_executable_list = get(gui.handles.pm_Python, 'String');
python_executable_selected = get(gui.handles.pm_Python, 'Value');

python_executable = python_executable_list(python_executable_selected);
python_executable = python_executable{:}

gui.config.CPFEM.python = preCPFE_python_check(python_executable);

guidata(gcf, gui);

preCPFE_config_CPFEM_updated;

end