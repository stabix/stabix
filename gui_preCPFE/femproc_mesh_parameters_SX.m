% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handles = femproc_mesh_parameters_SX(mesh_variables, x0, hu, wu)
%% Function to create and fill string boxes and edit boxes to set indenter and indentation properties
% mesh_variables: Name of mesh variables from the mesh layout
% x0: origin of x coordinate
% hu: heigth unit
% wu: width unit

% authors: d.mercier@mpie.de

[handles.coneAngle_str, handles.coneAngle_val]         = femproc_set_inputs_boxes({'Full Angle of conical indenter (°)'}, [x0 hu*18.7 wu*3 hu/2.5], mesh_variables.variables.coneAngle, 'femproc_indentation_setting_SX');
[handles.tipRadius_str, handles.tipRadius_val]         = femproc_set_inputs_boxes({'Tip radius of indenter (µm)'}, [x0 hu*18.1 wu*3 hu/2.5], mesh_variables.variables.tipRadius, 'femproc_indentation_setting_SX');
[handles.h_indent_str,  handles.h_indent_val]           = femproc_set_inputs_boxes({'Indentation depth (µm)'}, [x0 hu*17.5 wu*3 hu/2.5], mesh_variables.variables.h_indent, 'femproc_indentation_setting_SX');
[handles.r_center_frac_str, handles.r_center_frac_val] = femproc_set_inputs_boxes({'r_center_frac'}, [x0 hu*16.9 wu*3 hu/2.5], mesh_variables.variables.r_center_frac, 'femproc_indentation_setting_SX');
[handles.box_xfrac_str, handles.box_xfrac_val]         = femproc_set_inputs_boxes({'box_xfrac'}, [x0 hu*16.3 wu*3 hu/2.5], mesh_variables.variables.box_xfrac, 'femproc_indentation_setting_SX');
[handles.box_zfrac_str, handles.box_zfrac_val]         = femproc_set_inputs_boxes({'box_zfrac'}, [x0 hu*15.7 wu*3 hu/2.5], mesh_variables.variables.box_zfrac, 'femproc_indentation_setting_SX');
[handles.D_sample_str, handles.D_sample_val]           = femproc_set_inputs_boxes({'D_sample (µm)'}, [x0 hu*15.1 wu*3 hu/2.5], mesh_variables.variables.D_sample, 'femproc_indentation_setting_SX');
[handles.h_sample_str, handles.h_sample_val]           = femproc_set_inputs_boxes({'h_sample (µm)'}, [x0 hu*14.5 wu*3 hu/2.5], mesh_variables.variables.h_sample, 'femproc_indentation_setting_SX');
[handles.sample_rep_str, handles.sample_rep_val]       = femproc_set_inputs_boxes({'sample_rep (8,16,24,32,48)'}, [x0 hu*13.9 wu*3 hu/2.5], mesh_variables.variables.sample_rep, 'femproc_indentation_setting_SX');
[handles.box_elm_nx_str, handles.box_elm_nx_val]       = femproc_set_inputs_boxes({'box_elm_nx'}, [x0 hu*13.3 wu*3 hu/2.5], mesh_variables.variables.box_elm_nx, 'femproc_indentation_setting_SX');
[handles.box_elm_nz_str, handles.box_elm_nz_val]       = femproc_set_inputs_boxes({'box_elm_nz'}, [x0 hu*12.7 wu*3 hu/2.5], mesh_variables.variables.box_elm_nz, 'femproc_indentation_setting_SX');
[handles.radial_divi_str, handles.radial_divi_val]     = femproc_set_inputs_boxes({'radial_divi'}, [x0 hu*12.1 wu*3 hu/2.5], mesh_variables.variables.radial_divi, 'femproc_indentation_setting_SX');
[handles.box_bias_x_str, handles.box_bias_x_val]       = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [x0 hu*11.5 wu*3 hu/2.5], mesh_variables.variables.box_bias_x, 'femproc_indentation_setting_SX');
[handles.box_bias_z_str, handles.box_bias_z_val]       = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [x0 hu*10.9 wu*3 hu/2.5], mesh_variables.variables.box_bias_z, 'femproc_indentation_setting_SX');
[handles.box_bias_conv_x_str, handles.box_bias_conv_x_val] = femproc_set_inputs_boxes({'box_bias_conv_x (-0.5 to 0.5)'}, [x0 hu*10.3 wu*3 hu/2.5], mesh_variables.variables.box_bias_conv_x, 'femproc_indentation_setting_SX');

end