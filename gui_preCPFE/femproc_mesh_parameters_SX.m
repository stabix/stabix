% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handles = femproc_mesh_parameters_SX(mesh_variables)
%% Function to create and fill string boxes and edit boxes to set indenter and indentation properties
% authors: d.mercier@mpie.de

[handles.coneAngle_str, handles.coneAngle_val]         = femproc_set_inputs_boxes({'Full Angle of conical indenter (°)'}, [0.025 0.935 0.28 0.025],mesh_variables.variables.coneAngle, 'femproc_indentation_setting_SX');
[handles.tipRadius_str, handles.tipRadius_val]         = femproc_set_inputs_boxes({'Tip radius of indenter (µm)'}, [0.025 0.905 0.28 0.025],mesh_variables.variables.tipRadius, 'femproc_indentation_setting_SX');
[handles.h_indent_str,  handles.h_indent_val]           = femproc_set_inputs_boxes({'Indentation depth (µm)'}, [0.025 0.875 0.28 0.025],mesh_variables.variables.h_indent, 'femproc_indentation_setting_SX');
[handles.r_center_frac_str, handles.r_center_frac_val] = femproc_set_inputs_boxes({'r_center_frac'}, [0.025 0.845 0.28 0.025],mesh_variables.variables.r_center_frac, 'femproc_indentation_setting_SX');
[handles.box_xfrac_str, handles.box_xfrac_val]         = femproc_set_inputs_boxes({'box_xfrac'}, [0.025 0.815 0.28 0.025],mesh_variables.variables.box_xfrac, 'femproc_indentation_setting_SX');
[handles.box_zfrac_str, handles.box_zfrac_val]         = femproc_set_inputs_boxes({'box_zfrac'}, [0.025 0.785 0.28 0.025],mesh_variables.variables.box_zfrac, 'femproc_indentation_setting_SX');
[handles.D_sample_str, handles.D_sample_val]           = femproc_set_inputs_boxes({'D_sample (µm)'}, [0.025 0.755 0.28 0.025],mesh_variables.variables.D_sample, 'femproc_indentation_setting_SX');
[handles.h_sample_str, handles.h_sample_val]           = femproc_set_inputs_boxes({'h_sample (µm)'}, [0.025 0.725 0.28 0.025],mesh_variables.variables.h_sample, 'femproc_indentation_setting_SX');
[handles.sample_rep_str, handles.sample_rep_val]       = femproc_set_inputs_boxes({'sample_rep (8,16,24,32,48)'}, [0.025 0.695 0.28 0.025],mesh_variables.variables.sample_rep, 'femproc_indentation_setting_SX');
[handles.box_elm_nx_str, handles.box_elm_nx_val]       = femproc_set_inputs_boxes({'box_elm_nx'}, [0.025 0.665 0.28 0.025],mesh_variables.variables.box_elm_nx, 'femproc_indentation_setting_SX');
[handles.box_elm_nz_str, handles.box_elm_nz_val]       = femproc_set_inputs_boxes({'box_elm_nz'}, [0.025 0.635 0.28 0.025],mesh_variables.variables.box_elm_nz, 'femproc_indentation_setting_SX');
[handles.radial_divi_str, handles.radial_divi_val]     = femproc_set_inputs_boxes({'radial_divi'}, [0.025 0.605 0.28 0.025],mesh_variables.variables.radial_divi, 'femproc_indentation_setting_SX');
[handles.box_bias_x_str, handles.box_bias_x_val]       = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [0.025 0.575 0.28 0.025],mesh_variables.variables.box_bias_x, 'femproc_indentation_setting_SX');
[handles.box_bias_z_str, handles.box_bias_z_val]       = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [0.025 0.545 0.28 0.025],mesh_variables.variables.box_bias_z, 'femproc_indentation_setting_SX');
[handles.box_bias_conv_x_str, handles.box_bias_conv_x_val] = femproc_set_inputs_boxes({'box_bias_conv_x (-0.5 to 0.5)'}, [0.025 0.515 0.28 0.025],mesh_variables.variables.box_bias_conv_x, 'femproc_indentation_setting_SX');

end