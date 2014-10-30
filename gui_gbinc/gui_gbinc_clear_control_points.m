% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_clear_control_points
%% Function used to to clear variables

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

delete(gui.config_map.cpfilename);

set(gui.handles.overlay.delete_control_points, 'Visible', 'off')

guidata(gcf, gui);

end