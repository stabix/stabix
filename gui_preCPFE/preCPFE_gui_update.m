% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_gui_update
%% Function used to add a custom menu item in the GUI menubar

% author: d.mercier@mpie.de

gui = guidata(gcf);

if strcmp(gui.indenter_type, 'conical') == 1
    set(gui.handles.mesh.coneAngle_str, 'visible', 'on');
    set(gui.handles.mesh.coneAngle_val, 'visible', 'on');
    set(gui.handles.mesh.tipRadius_str, 'visible', 'on');
    set(gui.handles.mesh.tipRadius_val, 'visible', 'on');
    set(gui.handles.mesh.h_indent_str, 'visible', 'on');
    set(gui.handles.mesh.h_indent_val, 'visible', 'on');
    set(gui.handles.indenter_topo.pm_indenter_mesh_quality, 'visible', 'off');
    set(gui.handles.indenter_topo.rotate_loaded_indenter, 'visible', 'off');
    set(gui.handles.indenter_topo.rotate_loaded_indenter_str, 'visible', 'off');
    
elseif strcmp(gui.indenter_type, 'AFM') == 1
    set(gui.handles.mesh.coneAngle_str, 'visible', 'off');
    set(gui.handles.mesh.coneAngle_val, 'visible', 'off');
    set(gui.handles.mesh.tipRadius_str, 'visible', 'off');
    set(gui.handles.mesh.tipRadius_val, 'visible', 'off');
    set(gui.handles.mesh.h_indent_str, 'visible', 'off');
    set(gui.handles.mesh.h_indent_val, 'visible', 'off');
    set(gui.handles.indenter_topo.pm_indenter_mesh_quality, 'visible', 'on');
    set(gui.handles.indenter_topo.rotate_loaded_indenter, 'visible', 'on');
    set(gui.handles.indenter_topo.rotate_loaded_indenter_str, 'visible', 'on');
    
end

guidata(gcf, gui);

end