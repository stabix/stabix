% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [images, calibration, edge_detection, overlay] = ...
    gui_gbinc_checks(flag)
%% Function to do some checkings

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

images = 1;
calibration = 1;
edge_detection = 1;
overlay = 1;

%% Check of the presence of the 2 pictures
if ~flag.image1 || ~flag.image2
    warning('Please, load images first !');
    beep; commandwindow;
    images;
end

%% Check calibration
if flag.calibration_1 == 0 || flag.calibration_2 == 0
    warning('Please, calibration to do !');
    beep; commandwindow;
    calibration = 0;
end

%% Check edge detection
if flag.edgedetection_1 == 0 || flag.edgedetection_2 == 0
    warning('Please, edge detection to do !');
    beep; commandwindow;
    edge_detection = 0;
end

%% Check of the presence of on overlay
if flag.overlay == 0
    warning('Please, overlay images before !');
    beep; commandwindow;
    overlay = 0;
end

end