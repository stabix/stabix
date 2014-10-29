% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_custom_menu_edit_gui(parent, file_loc)
%% Setting of customized menu
% parent: handle of the GUI

% author: c.zambaldi@mpie.de

cb_string = sprintf('edit(''%s'')', file_loc);
uimenu(parent, 'Label', 'Edit this GUI', ...
    'Callback', cb_string, ...
    'Separator','on');

preCPFE_custom_menu_visit_damask(parent)
end