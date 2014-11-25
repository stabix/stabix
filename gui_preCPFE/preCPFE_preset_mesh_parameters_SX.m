% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_preset_mesh_parameters_SX
%% Function to set valid inputs for mesh
% author: d.mercier@mpie.de

gui_SX = guidata(gcf);

set(gui_SX.handles.mesh.D_sample_val, ...
    'String', num2str(gui_SX.defaults.variables.D_sample));

set(gui_SX.handles.mesh.h_sample_val, ...
    'String', num2str(gui_SX.defaults.variables.h_sample));

set(gui_SX.handles.mesh.r_center_frac_val, ...
    'String', num2str(gui_SX.defaults.variables.r_center_frac));

set(gui_SX.handles.mesh.box_xfrac_val, ...
    'String', num2str(gui_SX.defaults.variables.box_xfrac));

set(gui_SX.handles.mesh.box_zfrac_val, ...
    'String', num2str(gui_SX.defaults.variables.box_zfrac));

set(gui_SX.handles.mesh.sample_rep_val, ...
    'String', num2str(gui_SX.defaults.variables.sample_rep));

set(gui_SX.handles.mesh.box_elm_nx_val, ...
    'String', num2str(gui_SX.defaults.variables.box_elm_nx));

set(gui_SX.handles.mesh.box_elm_nz_val, ...
    'String', num2str(gui_SX.defaults.variables.box_elm_nz));

set(gui_SX.handles.mesh.radial_divi_val, ...
    'String', num2str(gui_SX.defaults.variables.radial_divi));

set(gui_SX.handles.other_setting.mesh_quality_lvl_val, ...
    'String', num2str(gui_SX.defaults.variables.mesh_quality_lvl));

end