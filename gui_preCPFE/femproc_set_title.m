function gui_title = femproc_set_title(gui, label, varargin)
if nargin < 2 || isempty(label)
    label = '';
else
    label = [' (', label, ')'];
end

gui_title = [gui.module_name, ' - ', gui.description, label, ...
    ' ', gui.toolbox_name, ' ', gui.version_str];
set(gcf, 'name', gui_title);