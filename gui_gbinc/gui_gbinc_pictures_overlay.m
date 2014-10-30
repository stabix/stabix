% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_pictures_overlay
%% Function to overlay pictures

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

% See: http://www.mathworks.fr/help/images/ref/cpselect.html
% See: http://www.mathworks.fr/help/images/ref/cp2tform.html

gui = guidata(gcf);

calibration = 1;
edge_detection = 1;

%% Check of the presence of the 2 pictures
if ~gui.flag.image1 || ~gui.flag.image2
    warning('Please, load image first !'); beep; commandwindow;
end

%% Check calibration
if gui.flag.calibration_1 == 0 || gui.flag.calibration_2 == 0
    warning('Please, calibration to do first !'); beep; commandwindow;
    calibration = 0;
end

%% Check edge detection
if gui.flag.edgedetection_1 == 0 || gui.flag.edgedetection_2 == 0
    warning('Please, edge detection to do !'); beep; commandwindow;
    edge_detection = 0;
end

%% Calculations
if calibration && edge_detection
    zoom out;
    %% Run overlay step
    fullpath_1 = gui.config_map.fullpath_image_before_polishing;
    fullpath_2 = gui.config_map.fullpath_image_after_polishing;
    high0 = imread(fullpath_1);
    low0 = imread(fullpath_2);
    
    pathname1 = gui.config_map.pathname_image_before_polishing;
    pathname2 = gui.config_map.pathname_image_after_polishing;
    filename1 = gui.config_map.filename_image_before_polishing;
    filename2 = gui.config_map.filename_image_after_polishing;
    
    cp_file = fullfile(pathname1, [filename1, '_', filename2, '.mat']);
    gui.config_map.cpfilename = cp_file;
    
    base  = high0;  fig_base  = gui.config_map.image_loaded_1;
    unreg = low0;   fig_unreg = gui.config_map.image_loaded_2;
    
    %% Control points
    % Check if the control points have already been stored.
    % Delete or rename the stored points for creating new ones.
    
    if ~exist(cp_file)
        %[xyinput_out, xybase_out] = cpselect(high, low, 'Wait',true)  % unregistered image is the first one
        [xyinput_out, xybase_out] = cpselect(unreg, base, 'Wait', true);  % unregistered image is the first one
        save(cp_file, 'xyinput_out', 'xybase_out', 'filename1', 'filename2');
    elseif exist(cp_file) == 2
        load(cp_file, '-mat');
    end
    
    set(gui.handles.overlay.delete_control_points, 'Visible', 'on');
    
    if size(xyinput_out, 1) == 3
        tform_affine = cp2tform(xyinput_out, xybase_out, 'affine');
        regd = imtransform(fig_unreg, tform_affine,...
            'FillValues', 255, ...
            'XData', [1 size(base, 2)],...
            'YData', [1 size(base, 1)]);
    else
        warning('Please, select correctly new control points...'); beep; commandwindow;
    end
    guidata(gcf, gui);
    
    %% Overlay the 2 figures
    try
        gui_gbinc_plot_overlay(regd, fig_base);
        gui.config_map.regd = regd;
        gui.config_map.fig_base = fig_base;
        guidata(gcf, gui);
        gui_gbinc_switch_plot(3);
        set(gui.handles.switch_plot.pb3, 'Visible', 'on');
        set(gui.handles.switch_plot.pb3, 'BackgroundColor', [0.2 0.8 0]);
        set(gui.handles.overlay.delete_control_points, 'Visible', 'on')
        gui.flag.overlay = 1;
    catch
        gui_gbinc_clear_control_points;
    end
end

guidata(gcf, gui);

end
