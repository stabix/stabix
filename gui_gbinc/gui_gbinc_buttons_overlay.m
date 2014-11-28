% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handles = gui_gbinc_buttons_overlay(x0, hu, wu)
%% Function to create buttons/boxes for the loading/setting of images
% x0: origin of x coordinate
% hu: heigth unit
% wu: width unit

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

h = uibuttongroup('visible','on','Position',[x0 hu*4.1 wu*3 x0*8]);

handles.main = set_pushbutton(...
    'OVERLAY', [x0 hu wu*3 x0*80], ...
    'gui_gbinc_pictures_overlay;', h);

handles.save = set_pushbutton(...
    'SAVE OVERLAY', [x0+wu*3.2 hu wu*3 x0*80], ...
    'gui_gbinc_save_overlay;', h);

handles.delete_control_points = set_pushbutton(...
    'CLEAR CONTROL POINTS', [x0+wu*6.4 hu wu*3 x0*80], ...
    'gui_gbinc_clear_control_points;', h);

set(handles.delete_control_points, 'Visible', 'off');

end