% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_calib_distance(image_type)
%% Function to measure the distance of the scalebar on the SEM picture
% before and after polishing
% image_type: 1 for image before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

gui_gbinc_switch_plot(image_type)

zoom out;

gui.config_map.h_dist = imdistline_set([10 80],[750 750], 'red');

guidata(gcf, gui);

end