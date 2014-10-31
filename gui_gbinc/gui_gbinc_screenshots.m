% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_screenshots
%% Function used to generate sequential screenshots of the GUI running with given files.
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

tabularasa;
% Initialization of parameters
SCREENSHOT = strcat(timestamp_make, 'screenshots');
SCREENSHOT_DIR = get_stabix_root;
SCREENSHOT_NUM = 1;

% Run the GUI
A_gui_gbinc;
gui = guidata(gcf);
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);

% Calibration image #1
gui_gbinc_calib_distance(1);
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);
waitfor(gui.handles.image_before_polishing.scale_factor_value, 'String');
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);
set(gui.handles.image_before_polishing.edge_detection_algo, 'Value', 4);
gui_gbinc_edge_detection(1);
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);

% Calibration image #2
gui_gbinc_calib_distance(2);
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);
waitfor(gui.handles.image_after_polishing.scale_factor_value, 'String');
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);
set(gui.handles.image_before_polishing.edge_detection_algo, 'Value', 4);
gui_gbinc_edge_detection(2);
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);

% Overlay
gui_gbinc_pictures_overlay;

% Vickers indents
gui_gbinc_vickers_distance;
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);
waitfor(gui.handles.vickers_indents.height, 'String');
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);

% GB inclination
gui_gbinc_gb_distance
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);
waitfor(gui.handles.gb_inclination.inclination, 'String');
SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM);

end