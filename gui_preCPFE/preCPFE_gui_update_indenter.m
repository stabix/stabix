% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_gui_update_indenter
%% Function used to add a custom menu item in the GUI menubar

% author: d.mercier@mpie.de

gui = guidata(gcf);

if strcmp(gui.indenter_type, 'conical') == 1
    set(gui.handles.indenter.coneAngle_str, 'visible', 'on');
    set(gui.handles.indenter.coneAngle_val, 'visible', 'on');
    set(gui.handles.indenter.tipRadius_str, 'visible', 'on');
    set(gui.handles.indenter.tipRadius_val, 'visible', 'on');
    set(gui.handles.indenter.h_indent_str, 'visible', 'on');
    set(gui.handles.indenter.h_indent_val, 'visible', 'on');
    set(gui.handles.indenter.pm_indenter_mesh_quality, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter_str, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter_box, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter_unit, 'visible', 'off');
    
elseif strcmp(gui.indenter_type, 'Berkovich') == 1 || ...
        strcmp(gui.indenter_type, 'Vickers') == 1 || ...
        strcmp(gui.indenter_type, 'cubeCorner') == 1
    set(gui.handles.indenter.coneAngle_str, 'visible', 'off');
    set(gui.handles.indenter.coneAngle_val, 'visible', 'off');
    set(gui.handles.indenter.tipRadius_str, 'visible', 'off');
    set(gui.handles.indenter.tipRadius_val, 'visible', 'off');
    set(gui.handles.indenter.h_indent_str, 'visible', 'on');
    set(gui.handles.indenter.h_indent_val, 'visible', 'on');
    set(gui.handles.indenter.pm_indenter_mesh_quality, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter_str, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter_box, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter_unit, 'visible', 'on');
    
elseif strcmp(gui.indenter_type, 'flatPunch') == 1
    set(gui.handles.indenter.coneAngle_str, 'visible', 'off');
    set(gui.handles.indenter.coneAngle_val, 'visible', 'off');
    set(gui.handles.indenter.tipRadius_str, 'visible', 'on');
    set(gui.handles.indenter.tipRadius_val, 'visible', 'on');
    set(gui.handles.indenter.h_indent_str, 'visible', 'on');
    set(gui.handles.indenter.h_indent_val, 'visible', 'on');
    set(gui.handles.indenter.pm_indenter_mesh_quality, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter_str, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter_box, 'visible', 'off');
    set(gui.handles.indenter.rotate_loaded_indenter_unit, 'visible', 'off');
    
elseif strcmp(gui.indenter_type, 'AFM') == 1
    set(gui.handles.indenter.coneAngle_str, 'visible', 'off');
    set(gui.handles.indenter.coneAngle_val, 'visible', 'off');
    set(gui.handles.indenter.tipRadius_str, 'visible', 'off');
    set(gui.handles.indenter.tipRadius_val, 'visible', 'off');
    set(gui.handles.indenter.h_indent_str, 'visible', 'on');
    set(gui.handles.indenter.h_indent_val, 'visible', 'on');
    set(gui.handles.indenter.pm_indenter_mesh_quality, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter_str, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter_box, 'visible', 'on');
    set(gui.handles.indenter.rotate_loaded_indenter_unit, 'visible', 'on');
end

guidata(gcf, gui);

end