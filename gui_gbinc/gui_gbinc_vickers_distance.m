% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_vickers_distance
%% Function to measure the distance between 2 sides of the same Vickers indent

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
    zoom out;
    gui.config_map.h_dist = imdistline_set([350 400],[150 150], 'green');
end
guidata(gcf, gui);

end