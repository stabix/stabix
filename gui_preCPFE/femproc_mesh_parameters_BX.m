% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handles = femproc_mesh_parameters_BX(mesh_variables, x0, hu, wu)
%% Function to create and fill string boxes and edit boxes to set indenter and indentation properties
% mesh_variables: Name of mesh variables from the mesh layout
% x0: origin of x coordinate
% hu: heigth unit
% wu: width unit

% authors: d.mercier@mpie.de

[handles.coneAngle_str, handles.coneAngle_val]        = femproc_set_inputs_boxes({'Full Angle of conical indenter (°)'}, [x0 hu*19.3 wu*2.8 x0],mesh_variables.variables.coneAngle, 'femproc_indentation_setting_BX');
[handles.tipRadius_str, handles.tipRadius_val]        = femproc_set_inputs_boxes({'Tip radius of indenter (µm)'}, [x0 hu*18.7 wu*2.8 x0],mesh_variables.variables.tipRadius, 'femproc_indentation_setting_BX');
[handles.h_indent_str, handles.h_indent_val]          = femproc_set_inputs_boxes({'abs(indentation depth) (µm)'}, [x0 hu*18.1 wu*2.8 x0],mesh_variables.variables.h_indent, 'femproc_indentation_setting_BX');
[handles.w_sample_str, handles.w_sample_val]          = femproc_set_inputs_boxes({'w_sample (µm)'}, [x0 hu*17.5 wu*2.8 x0],mesh_variables.variables.w_sample, 'femproc_indentation_setting_BX');
[handles.h_sample_str, handles.h_sample_val]          = femproc_set_inputs_boxes({'h_sample (µm)'}, [x0 hu*16.9 wu*2.8 x0],mesh_variables.variables.h_sample, 'femproc_indentation_setting_BX');
[handles.len_sample_str, handles.len_sample_val]      = femproc_set_inputs_boxes({'len_sample (µm)'}, [x0 hu*16.3 wu*2.8 x0],mesh_variables.variables.len_sample, 'femproc_indentation_setting_BX');
[handles.inclination_str, handles.inclination_val]    = femproc_set_inputs_boxes({'Inclination (°)'}, [x0 hu*15.7 wu*2.8 x0],mesh_variables.variables.inclination, 'femproc_indentation_setting_BX');
[handles.ind_dist_str, handles.ind_dist_val]          = femproc_set_inputs_boxes({'Distance GB-indent (µm)'}, [x0 hu*15.1 wu*2.8 x0],mesh_variables.variables.ind_dist, 'femproc_indentation_setting_BX');
% txt boxes for subdivision
[handles.box_elm_nx_str, handles.box_elm_nx_val]      = femproc_set_inputs_boxes({'box_elm_nx'}, [x0 hu*14.5 wu*2.8 x0],mesh_variables.variables.box_elm_nx, 'femproc_indentation_setting_BX');
[handles.box_elm_nz_str, handles.box_elm_nz_val]      = femproc_set_inputs_boxes({'box_elm_nz'}, [x0 hu*13.9 wu*2.8 x0],mesh_variables.variables.box_elm_nz, 'femproc_indentation_setting_BX');
[handles.box_elm_ny1_str, handles.box_elm_ny1_val]    = femproc_set_inputs_boxes({'box_elm_ny1'}, [x0 hu*13.3 wu*2.8 x0],mesh_variables.variables.box_elm_ny1, 'femproc_indentation_setting_BX');
[handles.box_elm_ny2_fac_str, handles.box_elm_ny2_fac_val]    = femproc_set_inputs_boxes({'box_elm_ny2_fac'}, [x0 hu*12.7 wu*2.8 x0],mesh_variables.variables.box_elm_ny2_fac, 'femproc_indentation_setting_BX');
[handles.box_elm_ny3_str, handles.box_elm_ny3_val]    = femproc_set_inputs_boxes({'box_elm_ny3'}, [x0 hu*12.1 wu*2.8 x0],mesh_variables.variables.box_elm_ny3, 'femproc_indentation_setting_BX');
[handles.mesh_quality_lvl_str, handles.mesh_quality_lvl_val]  = femproc_set_inputs_boxes({'lvl (mesh quality)'}, [x0 hu*11.5 wu*2.8 x0],mesh_variables.variables.mesh_quality_lvl, 'femproc_indentation_setting_BX');
% txt boxes for bias
[handles.box_bias_x1_str, handles.box_bias_x_val]     = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [x0 hu*10.9 wu*2.8 x0],mesh_variables.variables.box_bias_x, 'femproc_indentation_setting_BX');
[handles.box_bias_z1_str, handles.box_bias_z_val]     = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [x0 hu*10.3 wu*2.8 x0],mesh_variables.variables.box_bias_z, 'femproc_indentation_setting_BX');
[handles.box_bias_y1_str, handles.box_bias_y1_val]    = femproc_set_inputs_boxes({'box_bias_y1 (-0.5 to 0.5)'}, [x0 hu*9.7 wu*2.8 x0],mesh_variables.variables.box_bias_y1, 'femproc_indentation_setting_BX');
[handles.box_bias_x2_str, handles.box_bias_y2_val]    = femproc_set_inputs_boxes({'box_bias_y2 (-0.5 to 0.5)'}, [x0 hu*9.1 wu*2.8 x0],mesh_variables.variables.box_bias_y2, 'femproc_indentation_setting_BX');
[handles.box_bias_z3_str, handles.box_bias_y3_val]    = femproc_set_inputs_boxes({'box_bias_y3 (-0.5 to 0.5)'}, [x0 hu*8.5 wu*2.8 x0],mesh_variables.variables.box_bias_y3, 'femproc_indentation_setting_BX');

end