% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_calib_distance(image_type)
%% Function to measure the distance of the scalebar on the SEM picture
% before and after polishing
% image_type: 1 for before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if image_type == 1
    pathnameimage = gui.config_map.pathname_image_before_polishing;
    filenameimage = gui.config_map.filename_image_before_polishing;
    set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.2 0.8 0]);
    set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.9 0.9 0.9]);
elseif image_type == 2
    pathnameimage = gui.config_map.pathname_image_after_polishing;
    filenameimage = gui.config_map.filename_image_after_polishing;
    set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.9 0.9 0.9]);
    set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.2 0.8 0]);
end

gui_gbinc_load_image(pathnameimage, filenameimage);

zoom out;

gui.config_map.h_dist = set_imdistline([10 80],[750 750], 'red');

guidata(gcf, gui);

end