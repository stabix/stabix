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
    image_loaded = im2uint16(image_loaded);
elseif correction == 2
    image_loaded = imfilter(image_loaded, fspecial('unsharp'));
elseif correction == 1
    image_loaded = adapthisteq(image_loaded);
elseif correction == 1
    image_loaded = histeq(image_loaded);
elseif correction == 1
    image_loaded = decorrstretch(image_loaded);
end

end