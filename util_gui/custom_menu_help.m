% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function custom_menu_help(parent)
%% Setting of customized menu
% parent: handle of the GUI

% author: c.zambaldi@mpie.de

help_menu = uimenu(parent, 'Label', 'Help');

uimenu(help_menu, 'Label', 'HTML Documentation', ...
    'Callback', 'gui = guidata(gcf); web(gui.config.doc_path_root)');

uimenu(help_menu, 'Label', 'Download PDF Documentation', ...
    'Callback', 'gui = guidata(gcf); web(fullfile(gui.config.doc_path_root, gui.config.doc_path_pdf));');

end