% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function A_gui_gbinc
%% This toolbox helps to find the grain boundary inclination from two micrographs
% with the same scale obtained before and after a serial polishing.
% At least three marks such as microindents are needed for registration of the images.

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Check License of Image Toolbox
license_msg = ['Sorry, no license found for the Matlab ', ...
    'Image Processing Toolbox™ !'];
if  license('checkout', 'Image_Toolbox') == 0
    helpdlg(license_msg, ' Error');
    gui.flag.licenceFlag = 0;
else
    gui.flag.licenceFlag = 1;
end

if gui.flag.licenceFlag
    
    %% Toolbox configuration
    gui.config = get_config;
    
    gui.config.gbinc_root_fullpath = mfilename('fullpath');
    [gui.config.gbinc_root, gui.config.gbinc_root_filename,...
        gui.config.gbinc_ext] = fileparts(gui.config.gbinc_root_fullpath);
    
    gui.description = 'Toolbox for GB Inclination Calculation - ';
    gui.module_name = 'GBInc GUI';
    
    gui.config.defaults.picture_before.fullpath = ...
        fullfile(gui.config.gbinc_root,...
        'sem_pictures_serial_polishing', 'cpTi_before_polishing.tif');
    [gui.config.defaults.picture_before.pathname, ...
        gui.config.defaults.picture_before.filename, ...
        gui.config.defaults.picture_before.extension] = ...
        fileparts(gui.config.defaults.picture_before.fullpath);
    
    gui.config_map.pathname_image_before_polishing = ...
        gui.config.defaults.picture_before.pathname;
    gui.config_map.filename_image_before_polishing = ...
        strcat(gui.config.defaults.picture_before.filename, ...
        gui.config.defaults.picture_before.extension);
    gui.config_map.fullpath_image_before_polishing = fullfile(...
        gui.config_map.pathname_image_before_polishing, ...
        gui.config_map.filename_image_before_polishing);
    
    gui.config.defaults.picture_after.fullpath = ...
        fullfile(gui.config.gbinc_root,...
        'sem_pictures_serial_polishing', 'cpTi_post_polishing.tif');
    [gui.config.defaults.picture_after.pathname, ...
        gui.config.defaults.picture_after.filename, ...
        gui.config.defaults.picture_after.extension] = ...
        fileparts(gui.config.defaults.picture_after.fullpath);
    
    gui.config_map.pathname_image_after_polishing = ...
        gui.config.defaults.picture_after.pathname;
    gui.config_map.filename_image_after_polishing = ...
        strcat(gui.config.defaults.picture_after.filename, ...
        gui.config.defaults.picture_after.extension);
    gui.config_map.fullpath_image_after_polishing = fullfile(...
        gui.config_map.pathname_image_after_polishing, ...
        gui.config_map.filename_image_after_polishing);
    
    %% Initialization of flags
    gui.flag.image1          = 1;
    gui.flag.image2          = 1;
    gui.flag.calibration_1   = 0;
    gui.flag.calibration_2   = 0;
    gui.flag.edgedetection_1 = 0;
    gui.flag.edgedetection_2 = 0;
    gui.flag.overlay         = 0;
    gui.flag.vickersdist     = 0;
    gui.flag.gbdist          = 0;
    
    %% Main Window Coordinates Configuration
    scrsize = get(0, 'ScreenSize');   % Get screen size
    WX = 0.05 * scrsize(3);           % X Position (bottom)
    WY = 0.10 * scrsize(4);           % Y Position (left)
    WW = 0.90 * scrsize(3);           % Width
    WH = 0.80 * scrsize(4);           % Height
    
    x0 = 0.01;
    hu = 0.1; % height unit
    wu = 0.1; % width unit
    
    %% Main window setting
    gui.handles.main_window = figure('NumberTitle', 'off',...
        'Color', [0.9 0.9 0.9],...
        'toolBar', 'figure',...
        'Position', [WX WY WW WH]);
    
    gui.title_str = set_gui_title(gui, '');
    
    %% Customized menu
    gui_gbinc_customized_menu;
    
    %% Buttons to import/analyze picture before serial polishing
    gui.handles.image_before_polishing = gui_gbinc_buttons_load_set_image(x0, ...
        hu, wu, 1, gui.config.defaults.picture_before.filename);
    
    %% Buttons to import/analyze picture after serial polishing
    gui.handles.image_after_polishing = gui_gbinc_buttons_load_set_image(x0, ...
        hu/1.5, wu, 2, gui.config.defaults.picture_after.filename);
    
    %% Overlay buttons
    gui.handles.overlay = gui_gbinc_buttons_overlay(x0, hu, wu);
    
    %% Vickers indents analysis
    gui.handles.vickers_indents = ...
        gui_gbinc_buttons_vickers_indents(x0, hu, wu);
    
    %% GB inclination calculations
    gui.handles.gb_inclination = gui_gbinc_buttons_gb_inclination(x0, hu, wu);
    
    %% Buttons to switch pictures plot
    h = uibuttongroup('visible','on', 'Position',[x0*33 hu*9.4 wu*3.5 x0*5]);
    
    pb1 = set_pushbutton('Image before polishing', [x0*2.5 hu wu*3 x0*80], ...
        'gui_gbinc_switch_plot(1);', h);
    
    pb2 = set_pushbutton('Image after polishing', [x0*35 hu wu*3 x0*80], ...
        'gui_gbinc_switch_plot(2);', h);
    
    pb3 = set_pushbutton('Plot overlay', [x0*68.125 hu wu*3 x0*80], ...
        'gui_gbinc_switch_plot(3);', h);
    
    set(pb1, 'Backgroundcolor', [0.2 0.8 0]);
    set(pb3, 'Visible', 'off');
    
    gui.handles.switch_plot.pb1 = pb1;
    gui.handles.switch_plot.pb2 = pb2;
    gui.handles.switch_plot.pb3 = pb3;
    
    %% Popup menu to correct/modify image
    [gui.handles.correction_image_str, gui.handles.correction_image] = ...
        set_popupmenu('Correction to apply', [x0*70 hu*9.65 wu x0*2.5], ...
        1, listImageCorrection, 'gui_gbinc_correction_image;');
    
    gui.handles.brightening_image_str = uicontrol(...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [x0*85 hu*9.4 wu x0*5],...
        'String', 'Darken/Brighten');
    
    gui.handles.brightening_image = uicontrol(...
        'Units','normalized',...
        'Style', 'slider',...
        'Min', -1, 'Max', 1, 'Value', 0,...
        'Position', [x0*85 hu*9.4 wu x0*2.5],...
        'Callback', 'gui_gbinc_load_image');
    
    %% Others buttons
    gui.handles.documentation = set_pushbutton('DOCUMENTATION', ...
        [x0 hu*1.6 wu x0*5], ...
        ['webbrowser(''http://stabix.readthedocs.org/en/latest/' ...
        'gui_gbinc.html'')']);
    % See https://github.com/stabix/stabix/blob/master/gui_gbinc/README.rst
    
    gui.handles.reset = set_pushbutton('RESET', ...
        [x0 hu wu x0*5], 'close_windows(gcf); A_gui_gbinc;');
    
    %% Axis settings
    gui.handles.main_axis = axes('Position', [x0*33 hu/20 wu*6.5 x0*92]);
    axis off;
    
    %% Encapsulation of data
    guidata(gcf, gui);
    
    %% Load first image en gui encapsulation
    gui.config_map.image_loaded = fullfile(...
        gui.config.defaults.picture_before.pathname, ...
        strcat(gui.config.defaults.picture_before.filename, ...
        gui.config.defaults.picture_before.extension));
    
    gui_gbinc_load_image(gui.config_map.image_loaded);
    
    %% Encapsulation of data
    guidata(gcf, gui);
    
    %% Set logo of the GUI
    java_icon_gui;
    
end

end