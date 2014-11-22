% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function image_loaded = gui_gbinc_correction_image(...
    image_loaded, correction, varargin)
%% Function to correct loaded image
% image_loaded: Loaded image
% correction: Correction to apply to the image

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin == 0
    gui = guidata(gcf);
    try
        image_loaded = gui.config_map.image_loaded;
    catch
        gui_gbinc_edge_detection(1);
        gui = guidata(gcf);
        image_loaded = gui.config_map.image_loaded;
    end
    correction = get(gui.handles.correction_image, 'Value');
end

if correction == 1
    image_corrected = im2uint16(image_loaded);
elseif correction == 2
    image_corrected = imfilter(image_loaded, fspecial('unsharp'));
elseif correction == 3
    image_corrected = adapthisteq(image_loaded);
elseif correction == 4
    image_corrected = histeq(image_loaded);
elseif correction == 5
    image_corrected = decorrstretch(image_loaded);
end

imshow(image_corrected);

end