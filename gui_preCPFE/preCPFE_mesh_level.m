% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_mesh_level(ratio)
%% Function to set the mesh level

gui = guidata(gcf);

gui.variables.mesh_quality_lvl = ...
    str2num(get(gui.handles.other_setting.mesh_quality_lvl_val, 'String'));

gui.variables.mesh_quality_lvl = gui.variables.mesh_quality_lvl + ...
    gui.variables.mesh_quality_lvl * ratio;

set(gui.handles.other_setting.mesh_quality_lvl_val, ...
    'String', num2str(round(10*gui.variables.mesh_quality_lvl)/10));

guidata(gcf, gui);

end