% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_custom_menu_visit_damask(parent)
%% Setting of customized menu
% parent: handle of the GUI

% author: c.zambaldi@mpie.de

uimenu(parent, 'Label', 'DAMASK.mpie.de', ...
    'Callback', 'webbrowser(''http://damask.mpie.de'')', ...
    'Separator','on');
end