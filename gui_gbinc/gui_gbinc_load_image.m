% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_load_image(image_loaded)
%% Function used to load images
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Load images
zoom reset;

if nargin == 0
    gui = guidata(gcf);
   image_loaded  = gui.config_map.image_loaded;
end

imshow(image_loaded);

gui_gbinc_correction_image(image_loaded);

gui_gbinc_brighten_image;

end