% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_preset_mesh_parameters_BX
%% Function to set valid inputs for mesh
% author: d.mercier@mpie.de

gui_BX = guidata(gcf);

set(gui_BX.handles.mesh.w_sample_val, ...
    'String', num2str(gui_BX.defaults.variables.w_sample));

set(gui_BX.handles.mesh.h_sample_val, ...
    'String', num2str(gui_BX.defaults.variables.h_sample));

set(gui_BX.handles.mesh.len_sample_val, ...
    'String', num2str(gui_BX.defaults.variables.len_sample));

set(gui_BX.handles.mesh.inclination_val, ...
    'String', num2str(gui_BX.defaults.variables.inclination));

set(gui_BX.handles.mesh.ind_dist_val, ...
    'String', num2str(gui_BX.defaults.variables.ind_dist));

set(gui_BX.handles.mesh.box_elm_nx_val, ...
    'String', num2str(gui_BX.defaults.variables.box_elm_nx));

set(gui_BX.handles.mesh.box_elm_nz_val, ...
    'String', num2str(gui_BX.defaults.variables.box_elm_nz));

set(gui_BX.handles.mesh.box_elm_ny1_val, ...
    'String', num2str(gui_BX.defaults.variables.box_elm_ny1));

set(gui_BX.handles.mesh.box_elm_ny2_fac_val, ...
    'String', num2str(gui_BX.defaults.variables.box_elm_ny2_fac));

set(gui_BX.handles.mesh.box_elm_ny3_val, ...
    'String', num2str(gui_BX.defaults.variables.box_elm_ny3));

set(gui_BX.handles.other_setting.mesh_quality_lvl_val, ...
    'String', num2str(gui_BX.defaults.variables.mesh_quality_lvl));

end