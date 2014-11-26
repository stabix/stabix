% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_thickness_removed_calculation
%% Function used to calculate the height of polished/removed material

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

[images, calibration, edge_detection, overlay] = ...
    gui_gbinc_checks(gui.flag);

%% Calculations
if images && calibration && edge_detection && overlay
    gui.config_map.factor_calib = mean([gui.config_map.factor_calib_1, ...
        gui.config_map.factor_calib_2]);
    
    gui.vickers.vick_dist_pix = getDistance(gui.config_map.h_dist);
    
    gui.vickers.vick_dist = gui.vickers.vick_dist_pix * ...
        gui.config_map.factor_calib;
    
    % Set Vickers constants (angles in degrees)
    % from A.C. Fischer-Cripps "Nanoindentation" - Springer 2nd Ed. (2004)
    gui.vickers.angle_face  = 136; %angle between opposite faces
    gui.vickers.angle_ridge = 148; %angle between opposite edges
    
    gui.vickers.VickersChoice = ...
        get(gui.handles.vickers_indents.indent_selection, 'value');
    
    if gui.vickers.VickersChoice == 1
        gui.vickers.VickersChoice_str = 'edge';
        gui.config_map.height_polished = gui.vickers.vick_dist / ...
            (tand(gui.vickers.angle_face / 2));
    elseif VickersChoice == 2
        gui.vickers.VickersChoice_str = 'ridge';
        gui.config_map.height_polished = gui.vickers.vick_dist / ...
            (tand(gui.vickers.angle_ridge / 2));
    end
    
    set(gui.handles.vickers_indents.height, ...
        'String', gui.config_map.height_polished);
end

guidata(gcf, gui);

end