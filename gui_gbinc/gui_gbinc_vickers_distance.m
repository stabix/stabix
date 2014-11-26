% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_vickers_distance
%% Function to measure the distance between 2 sides of the same Vickers indent

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

[images, calibration, edge_detection, overlay] = ...
    gui_gbinc_checks(gui.flag);

%% Calculations
if images && calibration && edge_detection && overlay
    zoom out;
    gui.config_map.h_dist = imdistline_set([350 400],[150 150], 'green');
end
guidata(gcf, gui);

end