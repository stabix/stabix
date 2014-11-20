% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_title = set_gui_title(gui, label, varargin)
%% Setting of GUI's title
% gui: Handle of the GUI
% label: String used for the title
% gui_title: Title of the GUI

% author: c.zambaldi@mpie.de

if nargin < 2 || isempty(label)
    label = '';
else
    label = [' (', label, ')'];
end

gui_title = [gui.module_name, ' - ', gui.description, label, ...
    ' ', gui.config.toolbox_name, ' ', gui.config.toolbox_version_str];

set(gcf, 'name', gui_title);

end