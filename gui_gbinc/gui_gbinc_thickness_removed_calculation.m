% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_thickness_removed_calculation
%% Function used to calculate the height of polished/removed material

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

calibration = 1;
edge_detection = 1;
overlay = 1;

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

%% Check of the presence of on overlay
if gui.flag.overlay == 0
    warning('Please, overlay images before !'); beep; commandwindow;
    overlay = 0;
end

%% Calculations
if calibration && edge_detection && overlay
    gui.config_map.factor_calib = mean([gui.config_map.factor_calib_1, ...
        gui.config_map.factor_calib_2]);
    
    gui.vickers.vick_dist_pix = getDistance(gui.config_map.h_dist);
    gui.vickers.vick_dist     = gui.vickers.vick_dist_pix * gui.config_map.factor_calib;
    
    % Set Vickers constants (angles in degrees)
    gui.vickers.angle_edge  = 136;
    gui.vickers.angle_ridge = 148.1;
    
    gui.vickers.VickersChoice = get(gui.handles.vickers_indents.indent_selection, 'value');
    
    if gui.vickers.VickersChoice == 1
        gui.vickers.VickersChoice_str = 'edge';
        gui.config_map.height_polished = gui.vickers.vick_dist / ...
            (tand(gui.vickers.angle_edge / 2));
    elseif VickersChoice == 2
        gui.vickers.VickersChoice_str = 'ridge';
        gui.config_map.height_polished = gui.vickers.vick_dist / ...
            (tand(gui.vickers.angle_ridge / 2));
    end
    
    set(gui.handles.vickers_indents.height, 'String', gui.config_map.height_polished);
end

guidata(gcf, gui);

end