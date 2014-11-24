% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_brighten_image
%% Function to correct loaded image
% image_loaded: Loaded image
% correction: Correction to apply to the image

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

gui.config_map.bright_factor = get(gui.handles.brightening_image, 'Value');

brighten(gui.config_map.bright_factor);

guidata(gcf, gui);

end