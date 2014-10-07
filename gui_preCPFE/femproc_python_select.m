% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function python_executable = femproc_python_select
%% Get Python installation selected

gui_SX = guidata(gcf);

python_executable_list = get(gui_SX.handles.pm_Python, 'String');
python_executable_selected = get(gui_SX.handles.pm_Python, 'Value');

python_executable = python_executable_list(python_executable_selected);
python_executable = python_executable{:};

end