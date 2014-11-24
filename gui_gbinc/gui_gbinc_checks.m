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
    warning_commwin('Please, load images first !', 1);
    images = 0;
end

%% Check calibration
if flag.calibration_1 == 0 || flag.calibration_2 == 0
    warning_commwin('Please, calibration to do !', 1);
    calibration = 0;
end

%% Check edge detection
if flag.edgedetection_1 == 0 || flag.edgedetection_2 == 0
    warning_commwin('Please, edge detection to do !', 1);
    edge_detection = 0;
end

%% Check of the presence of on overlay
if flag.overlay == 0
    warning_commwin('Please, overlay images before !', 1);
    overlay = 0;
end

end