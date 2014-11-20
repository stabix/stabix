% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_scale_calibration(image_type)
%% Function to set calibration factor based on the scale of picture
% image_type: 1 for before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

%% Calculation of the calibration factor
if image_type == 1
    if ~gui.flag.image1
        warning('Please, load image first !'); beep; commandwindow;
    else
        gui.config_map.scale_str = ...
            get(gui.handles.image_before_polishing.scale_value, 'string');
        gui.config_map.scale = str2double(gui.config_map.scale_str);
        gui.config_map.dist = getDistance(gui.config_map.h_dist);
        gui.config_map.factor_calib_1 = ...
            gui.config_map.scale / gui.config_map.dist;
        set(gui.handles.image_before_polishing.scale_factor_value, ...
            'string', gui.config_map.factor_calib_1);
        gui.flag.calibration_1 = 1;
    end
elseif image_type == 2
    if ~gui.flag.image2
        warning('Please, load image first !'); beep; commandwindow;
    else
        gui.config_map.scale_str = ...
            get(gui.handles.image_after_polishing.scale_value, 'string');
        gui.config_map.scale = str2double(gui.config_map.scale_str);
        gui.config_map.dist = getDistance(gui.config_map.h_dist);
        gui.config_map.factor_calib_2 = ...
            gui.config_map.scale / gui.config_map.dist;
        set(gui.handles.image_after_polishing.scale_factor_value, ...
            'string', gui.config_map.factor_calib_2);
        gui.flag.calibration_2 = 1;
    end
end

guidata(gcf, gui);

end