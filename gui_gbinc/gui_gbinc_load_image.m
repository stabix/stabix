% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function image_loaded = gui_gbinc_load_image(pathname, filename)
%% Function used to load images
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Load images
zoom reset;
image_loaded = imread(fullfile(pathname, filename));

imshow(image_loaded);

end