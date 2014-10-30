% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_scale_calibration(image_type)
%% Function to set calibration factor based on the scale of picture
% image_type: 1 for before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

parent = gcf;

gui = guidata(parent);

if image_type == 1
    pathnameimage = gui.config_map.pathname_image_before_polishing;
    filenameimage = gui.config_map.filename_image_before_polishing;
    set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.2 0.8 0]);
    set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.9 0.9 0.9]);
elseif image_type == 2
    pathnameimage = gui.config_map.pathname_image_after_polishing;
    filenameimage = gui.config_map.filename_image_after_polishing;
    set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.9 0.9 0.9]);
    set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.2 0.8 0]);
end

gui_gbinc_load_image(pathnameimage, filenameimage);

gui.config_map.h_dist = imdistline(gca,[10 80],[750 750]);
api    = iptgetapi(gui.config_map.h_dist);
fcn    = makeConstrainToRectFcn('imline',...
    get(gca, 'XLim'),...
    get(gca, 'YLim'));

setLabelVisible(gui.config_map.h_dist, false);

api.setDragConstraintFcn(fcn);

%% Calculation of the calibration factor
if image_type == 1
    if ~gui.flag.image1
        warning('Please, load image first !'); beep; commandwindow;
    else
        gui.config_map.scale_str = get(gui.handles.image_before_polishing.scale_value, 'string');
        gui.config_map.scale     = str2double(gui.config_map.scale_str);
        gui.config_map.dist = getDistance(gui.config_map.h_dist);
        gui.config_map.factor_calib_1 = gui.config_map.scale / gui.config_map.dist;
        set(gui.handles.image_before_polishing.scale_factor_value, ...
            'string', gui.config_map.factor_calib_1);
        gui.flag.calibration_1 = 1;
    end
elseif image_type == 2
    if ~gui.flag.image2
        warning('Please, load image first !'); beep; commandwindow;
    else
        gui.config_map.scale_str = get(gui.handles.image_after_polishing.scale_value, 'string');
        gui.config_map.scale     = str2double(gui.config_map.scale_str);
        gui.config_map.dist = getDistance(gui.config_map.h_dist);
        gui.config_map.factor_calib_2 = gui.config_map.scale / gui.config_map.dist;
        set(gui.handles.image_after_polishing.scale_factor_value, ...
            'string', gui.config_map.factor_calib_2);
        gui.flag.calibration_2 = 1;
    end
end

guidata(parent, gui);

end