% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_gb_inclination_calculation
%% Function used to calculate GB angle

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

calibration = 1;
edge_detection = 1;
overlay = 1;

%% Check calibration
if gui.flag.calibration_1 == 0 || gui.flag.calibration_2 == 0
    warning('Please, calibration to do first !'); beep; commandwindow;
    calibration = 0;
end

%% Check edge detection
if gui.flag.edgedetection_1 == 0 || gui.flag.edgedetection_2 == 0
    warning('Please, edge detection to do !'); beep; commandwindow;
    edge_detection = 0;
end

%% Check of the presence of on overlay
if gui.flag.overlay == 0
    warning('Please, overlay images before !'); beep; commandwindow;
    overlay = 0;
end

%% Calculations
if calibration && edge_detection && overlay
    gui.config_map.factor_calib = mean([gui.config_map.factor_calib_1, ...
        gui.config_map.factor_calib_2]);
    
    gui.gb.gb_dist_pix = getDistance(gui.config_map.h_dist);
    gui.gb.gb_dist     = gui.gb.gb_dist_pix * gui.config_map.factor_calib;
    gui.gb.gb_angle    = 90 + (atand(gui.gb.gb_dist ...
        / gui.config_map.height_polished));
    gui.gb.angle       = 'Angle of GB (delta=180° => // surface)';
    
    set(gui.handles.gb_inclination.distance, 'String', gui.gb.gb_dist);
    set(gui.handles.gb_inclination.inclination, 'String', gui.gb.gb_angle);
end

guidata(gcf, gui);

end