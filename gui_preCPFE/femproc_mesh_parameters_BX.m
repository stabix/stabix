% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handles = femproc_mesh_parameters_BX(mesh_variables)
%% Function to create and fill string boxes and edit boxes to set indenter and indentation properties
% authors: d.mercier@mpie.de

[handles.coneAngle_str, handles.coneAngle_val]        = femproc_set_inputs_boxes({'Full Angle of conical indenter (°)'}, [0.025 0.965 0.28 0.025],mesh_variables.variables.coneAngle, 'femproc_indentation_setting_BX');
[handles.tipRadius_str, handles.tipRadius_val]        = femproc_set_inputs_boxes({'Tip radius of indenter (µm)'}, [0.025 0.935 0.28 0.025],mesh_variables.variables.tipRadius, 'femproc_indentation_setting_BX');
[handles.h_indent_str, handles.h_indent_val]          = femproc_set_inputs_boxes({'abs(indentation depth) (µm)'}, [0.025 0.905 0.28 0.025],mesh_variables.variables.h_indent, 'femproc_indentation_setting_BX');
[handles.w_sample_str, handles.w_sample_val]          = femproc_set_inputs_boxes({'w_sample (µm)'}, [0.025 0.875 0.28 0.025],mesh_variables.variables.w_sample, 'femproc_indentation_setting_BX');
[handles.h_sample_str, handles.h_sample_val]          = femproc_set_inputs_boxes({'h_sample (µm)'}, [0.025 0.845 0.28 0.025],mesh_variables.variables.h_sample, 'femproc_indentation_setting_BX');
[handles.len_sample_str, handles.len_sample_val]      = femproc_set_inputs_boxes({'len_sample (µm)'}, [0.025 0.815 0.28 0.025],mesh_variables.variables.len_sample, 'femproc_indentation_setting_BX');
[handles.inclination_str, handles.inclination_val]    = femproc_set_inputs_boxes({'Inclination (°)'}, [0.025 0.785 0.28 0.025],mesh_variables.variables.inclination, 'femproc_indentation_setting_BX');
[handles.ind_dist_str, handles.ind_dist_val]          = femproc_set_inputs_boxes({'Distance GB-indent (µm)'}, [0.025 0.755 0.28 0.025],mesh_variables.variables.ind_dist, 'femproc_indentation_setting_BX');
% txt boxes for subdivision
[handles.box_elm_nx_str, handles.box_elm_nx_val]      = femproc_set_inputs_boxes({'box_elm_nx'}, [0.025 0.725 0.28 0.025],mesh_variables.variables.box_elm_nx, 'femproc_indentation_setting_BX');
[handles.box_elm_nz_str, handles.box_elm_nz_val]      = femproc_set_inputs_boxes({'box_elm_nz'}, [0.025 0.695 0.28 0.025],mesh_variables.variables.box_elm_nz, 'femproc_indentation_setting_BX');
[handles.box_elm_ny1_str, handles.box_elm_ny1_val]    = femproc_set_inputs_boxes({'box_elm_ny1'}, [0.025 0.665 0.28 0.025],mesh_variables.variables.box_elm_ny1, 'femproc_indentation_setting_BX');
[handles.box_elm_ny2_fac_str, handles.box_elm_ny2_fac_val]    = femproc_set_inputs_boxes({'box_elm_ny2_fac'}, [0.025 0.635 0.28 0.025],mesh_variables.variables.box_elm_ny2_fac, 'femproc_indentation_setting_BX');
[handles.box_elm_ny3_str, handles.box_elm_ny3_val]    = femproc_set_inputs_boxes({'box_elm_ny3'}, [0.025 0.605 0.28 0.025],mesh_variables.variables.box_elm_ny3, 'femproc_indentation_setting_BX');
[handles.mesh_quality_lvl_str, handles.mesh_quality_lvl_val]  = femproc_set_inputs_boxes({'lvl (mesh quality)'}, [0.025 0.575 0.28 0.025],mesh_variables.variables.mesh_quality_lvl, 'femproc_indentation_setting_BX');
% txt boxes for bias
[handles.box_bias_x1_str, handles.box_bias_x_val]     = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [0.025 0.545 0.28 0.025],mesh_variables.variables.box_bias_x, 'femproc_indentation_setting_BX');
[handles.box_bias_z1_str, handles.box_bias_z_val]     = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [0.025 0.515 0.28 0.025],mesh_variables.variables.box_bias_z, 'femproc_indentation_setting_BX');
[handles.box_bias_y1_str, handles.box_bias_y1_val]    = femproc_set_inputs_boxes({'box_bias_y1 (-0.5 to 0.5)'}, [0.025 0.485 0.28 0.025],mesh_variables.variables.box_bias_y1, 'femproc_indentation_setting_BX');
[handles.box_bias_x2_str, handles.box_bias_y2_val]    = femproc_set_inputs_boxes({'box_bias_y2 (-0.5 to 0.5)'}, [0.025 0.455 0.28 0.025],mesh_variables.variables.box_bias_y2, 'femproc_indentation_setting_BX');
[handles.box_bias_z3_str, handles.box_bias_y3_val]    = femproc_set_inputs_boxes({'box_bias_y3 (-0.5 to 0.5)'}, [0.025 0.425 0.28 0.025],mesh_variables.variables.box_bias_y3, 'femproc_indentation_setting_BX');

end