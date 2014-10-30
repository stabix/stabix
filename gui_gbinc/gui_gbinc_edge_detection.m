% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_edge_detection(image_type)
%% Function used to run the edge detection
% image_type: 1 for before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if image_type == 1
    pathnameimage = gui.config_map.pathname_image_before_polishing;
    filenameimage = gui.config_map.filename_image_before_polishing;
    num_algo = get(gui.handles.image_before_polishing.edge_detection_algo, 'value');
    threshold = str2num(get(gui.handles.image_before_polishing.edge_detection_threshold_value, 'string'));
    set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.2 0.8 0]);
    set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.9 0.9 0.9]);
elseif image_type == 2
    pathnameimage = gui.config_map.pathname_image_after_polishing;
    filenameimage = gui.config_map.filename_image_after_polishing;
    num_algo = get(gui.handles.image_after_polishing.edge_detection_algo, 'value');
    threshold = str2num(get(gui.handles.image_after_polishing.edge_detection_threshold_value, 'string'));
    set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.9 0.9 0.9]);
    set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.2 0.8 0]);
end

%% Check of the presence of the 2 pictures
if ~gui.flag.image1 || ~gui.flag.image2 || isequal(filenameimage, 0)
    warning('Please, load image first !'); beep; commandwindow;
end

%% Check of the calibration setting
%% Set edge detection
image_loaded = imread(fullfile(pathnameimage, filenameimage));

% Scale down large images
image_loaded = im2uint16(image_loaded);
%image_loaded = imfilter(image_loaded, fspecial('unsharp'));
%image_loaded = adapthisteq(image_loaded);
%image_loaded = histeq(image_loaded);
%image_loaded = decorrstretch(image_loaded);

rawImages = false;

if 1 && ~rawImages % Contrast Stretch
    image_loaded = imadjust(image_loaded, stretchlim(image_loaded));
end

if 1 && ~rawImages % Reduce noise
    msk = [10, 10];
    if 1
        image_loaded = wiener2(image_loaded, msk);
    else
        image_loaded = medfilt2(image_loaded, msk);
    end
end

%% Run edge detection
if 1 && ~rawImages
    
    if num_algo == 1
        algo = 'sobel';
    elseif num_algo == 2
        algo = 'prewitt';
    elseif num_algo == 3
        algo = 'roberts';
    elseif num_algo == 4
        algo = 'canny';
    elseif num_algo == 5
        algo = 'log';
    end
    
    % Set threshold for edge detection
    if threshold >= 1 | threshold <= 0
        warning('Please, threshold must be between 0 and 1'); beep; commandwindow;
    end
end

if 0
    image_loaded = edge(image_loaded,algo);
else
    image_loaded = edge(image_loaded,algo,threshold);
end

if 1
    image_loaded = (-(image_loaded-1));
    %image_loaded = ind2rgb(image_loaded,'summer');
end

imshow(image_loaded);
if image_type == 1
    gui.flag.edgedetection_1 = 1;
    gui.config_map.image_loaded_1 = image_loaded;
elseif image_type == 2
    gui.flag.edgedetection_2 = 1;
    gui.config_map.image_loaded_2 = image_loaded;
end

guidata(gcf, gui);

end