% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_edge_detection(image_type)
%% Function used to run the edge detection
% image_type: 1 for before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if image_type == 1
    num_algo = get(...
        gui.handles.image_before_polishing.edge_detection_algo, ...
        'value');
    threshold = str2num(get(...
        gui.handles.image_before_polishing.edge_detection_threshold_value, ...
        'string'));
elseif image_type == 2
    num_algo = get(...
        gui.handles.image_after_polishing.edge_detection_algo, ...
        'value');
    threshold = str2num(get(...
        gui.handles.image_after_polishing.edge_detection_threshold_value, ...
        'string'));
end

gui_gbinc_switch_plot(image_type);

%% Set edge detection
gui_gbinc_brighten_image;

image_loaded = gui_gbinc_correction_image;

image_loaded = imadjust(image_loaded, stretchlim(image_loaded));

msk = [10, 10];
image_loaded = wiener2(image_loaded, msk);
%image_loaded = medfilt2(image_loaded, msk);

%% Run edge detection
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

thresholg_flag = 1;
% Set threshold for edge detection
if threshold >= 1 | threshold <= 0
    warning_commwin('Please, threshold must be between 0 and 1', 1);
    thresholg_flag = 0;
end

if thresholg_flag
    image_loaded = edge(image_loaded, algo, threshold);
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