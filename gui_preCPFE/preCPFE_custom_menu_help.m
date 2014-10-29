% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_custom_menu_help(parent)
%% Setting of customized menu
% parent: handle of the GUI

% author: c.zambaldi@mpie.de

help_menu = uimenu(parent, 'Label', 'Help');

uimenu(help_menu, 'Label', 'HTML Documentation', ...
    'Callback', 'gui = guidata(gcf); webbrowser(gui.config.doc_path)');

uimenu(help_menu, 'Label', 'Download PDF Documentation', ...
    'Callback', 'gui = guidata(gcf); webbrowser(gui.config.doc_pdf_path);');

end