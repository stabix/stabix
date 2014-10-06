% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handles = femproc_mesh_parameters_SX(mesh_variables)
%% Function to create and fill string boxes and edit boxes to set indenter and indentation properties
% authors: d.mercier@mpie.de

x0 = 0.025;
%y0 = 
%dy = 
wid = 0.1*3;
hei = 0.025;

[handles.coneAngle_str, handles.coneAngle_val]         = femproc_set_inputs_boxes({'Full Angle of conical indenter (°)'}, [x0 0.935 wid hei], mesh_variables.variables.coneAngle, 'femproc_indentation_setting_SX');
[handles.tipRadius_str, handles.tipRadius_val]         = femproc_set_inputs_boxes({'Tip radius of indenter (µm)'}, [x0 0.905 wid hei], mesh_variables.variables.tipRadius, 'femproc_indentation_setting_SX');
[handles.h_indent_str,  handles.h_indent_val]           = femproc_set_inputs_boxes({'Indentation depth (µm)'}, [x0 0.875 wid hei], mesh_variables.variables.h_indent, 'femproc_indentation_setting_SX');
[handles.r_center_frac_str, handles.r_center_frac_val] = femproc_set_inputs_boxes({'r_center_frac'}, [x0 0.845 wid hei], mesh_variables.variables.r_center_frac, 'femproc_indentation_setting_SX');
[handles.box_xfrac_str, handles.box_xfrac_val]         = femproc_set_inputs_boxes({'box_xfrac'}, [x0 0.815 wid hei], mesh_variables.variables.box_xfrac, 'femproc_indentation_setting_SX');
[handles.box_zfrac_str, handles.box_zfrac_val]         = femproc_set_inputs_boxes({'box_zfrac'}, [x0 0.785 wid hei], mesh_variables.variables.box_zfrac, 'femproc_indentation_setting_SX');
[handles.D_sample_str, handles.D_sample_val]           = femproc_set_inputs_boxes({'D_sample (µm)'}, [x0 0.755 wid hei], mesh_variables.variables.D_sample, 'femproc_indentation_setting_SX');
[handles.h_sample_str, handles.h_sample_val]           = femproc_set_inputs_boxes({'h_sample (µm)'}, [x0 0.725 wid hei], mesh_variables.variables.h_sample, 'femproc_indentation_setting_SX');
[handles.sample_rep_str, handles.sample_rep_val]       = femproc_set_inputs_boxes({'sample_rep (8,16,24,32,48)'}, [x0 0.695 wid hei], mesh_variables.variables.sample_rep, 'femproc_indentation_setting_SX');
[handles.box_elm_nx_str, handles.box_elm_nx_val]       = femproc_set_inputs_boxes({'box_elm_nx'}, [x0 0.665 wid hei], mesh_variables.variables.box_elm_nx, 'femproc_indentation_setting_SX');
[handles.box_elm_nz_str, handles.box_elm_nz_val]       = femproc_set_inputs_boxes({'box_elm_nz'}, [x0 0.635 wid hei], mesh_variables.variables.box_elm_nz, 'femproc_indentation_setting_SX');
[handles.radial_divi_str, handles.radial_divi_val]     = femproc_set_inputs_boxes({'radial_divi'}, [x0 0.605 wid hei], mesh_variables.variables.radial_divi, 'femproc_indentation_setting_SX');
[handles.box_bias_x_str, handles.box_bias_x_val]       = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [x0 0.575 wid hei], mesh_variables.variables.box_bias_x, 'femproc_indentation_setting_SX');
[handles.box_bias_z_str, handles.box_bias_z_val]       = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [x0 0.545 wid hei], mesh_variables.variables.box_bias_z, 'femproc_indentation_setting_SX');
[handles.box_bias_conv_x_str, handles.box_bias_conv_x_val] = femproc_set_inputs_boxes({'box_bias_conv_x (-0.5 to 0.5)'}, [x0 0.515 wid hei], mesh_variables.variables.box_bias_conv_x, 'femproc_indentation_setting_SX');

end