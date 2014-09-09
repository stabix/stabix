% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_custom_menu_help(parent)
%% Setting of customized menu
% parent: handle of the GUI

% author: c.zambaldi@mpie.de

uimenu(parent, 'Label', 'Help', ...
    'Callback', 'gui = guidata(gcf); web(gui.config_Matlab.doc_path)', ...
    'Separator','on');

end