% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_set_valid_inputs_SX
%% Function to set valid inputs in case of wrong inputs
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_SX = guidata(gcf);

% Tip radius
if gui_SX.variables.tipRadius < 0
    gui_SX.variables.tipRadius = abs(gui_SX.variables.tipRadius);
    set(gui_SX.handles.mesh.tipRadius_val, 'String', num2str(gui_SX.variables.tipRadius));
end

% Cone Angle
if gui_SX.variables.coneAngle < 0
    gui_SX.variables.coneAngle = abs(gui_SX.variables.coneAngle);
    set(gui_SX.handles.mesh.coneAngle_val, 'String', num2str(gui_SX.variables.coneAngle));
end

% Indent depth
if gui_SX.variables.h_indent < 0
    gui_SX.variables.h_indent = abs(gui_SX.variables.h_indent);
    set(gui_SX.handles.mesh.h_indent_val, 'String', num2str(gui_SX.variables.h_indent));
end

% Diameter of the sample
if gui_SX.variables.D_sample < 0
    gui_SX.variables.D_sample = abs(gui_SX.variables.D_sample);
    set(gui_SX.handles.mesh.D_sample_val, 'String', num2str(gui_SX.variables.D_sample));
end

% Heigth of the sample
if gui_SX.variables.h_sample < 0
    gui_SX.variables.h_sample = abs(gui_SX.variables.h_sample);
    set(gui_SX.handles.mesh.h_sample_val, 'String', num2str(gui_SX.variables.h_sample));
end

% Radius of inner cylinder
if gui_SX.variables.r_center_frac < 0 || gui_SX.variables.r_center_frac >= 1
    set(gui_SX.handles.mesh.r_center_frac_val, 'String', num2str(gui_SX.r_center_frac_init));
    gui_SX.variables.r_center_frac   = str2num(get(gui_SX.r_center_frac_val, 'String'));
elseif gui_SX.variables.r_center_frac == 0
    set(gui_SX.handles.mesh.sample_rep_val, 'String',8);
end

% Box xfrac
if gui_SX.variables.box_xfrac < 0 || gui_SX.variables.box_xfrac > 1
    set(gui_SX.handles.mesh.box_xfrac_val, 'String', num2str(gui_SX.box_xfrac_init));
    gui_SX.variables.box_xfrac  = str2num(get(gui_SX.box_xfrac_val, 'String'));
end

% Box zfrac
if gui_SX.variables.box_zfrac < 0 || gui_SX.variables.box_zfrac > 1
    set(gui_SX.handles.mesh.box_zfrac_val, 'String', num2str(gui_SX.box_zfrac_init));
    gui_SX.variables.box_zfrac  = str2num(get(gui_SX.box_zfrac_val, 'String'));
end

% Sample repetition
if gui_SX.variables.sample_rep == 8 || gui_SX.variables.sample_rep == 16 || gui_SX.variables.sample_rep == 24 || gui_SX.variables.sample_rep == 32 || gui_SX.variables.sample_rep == 48
    
else
    set(gui_SX.handles.mesh.sample_rep_val, 'String', num2str(gui_SX.sample_rep_init));
    gui_SX.variables.sample_rep  = str2num(get(gui_SX.sample_rep_val, 'String'));
end

% Elements along x
if gui_SX.variables.box_elm_nx <= 0
    set(gui_SX.handles.mesh.box_elm_nx_val, 'String', num2str(gui_SX.box_elm_nx_init));
else
    set(gui_SX.handles.mesh.box_elm_nx_val, 'String', num2str(gui_SX.variables.box_elm_nx));
end

% Elements along z
if gui_SX.variables.box_elm_nz <= 0
    set(gui_SX.handles.mesh.box_elm_nz_val, 'String', num2str(gui_SX.box_elm_nz_init));
else
    set(gui_SX.handles.mesh.box_elm_nz_val, 'String', num2str(gui_SX.variables.box_elm_nz));
end

% Radial division
if gui_SX.variables.radial_divi <= 0
    set(gui_SX.handles.mesh.radial_divi_val, 'String', num2str(gui_SX.radial_divi_init));
else
    set(gui_SX.handles.mesh.radial_divi_val, 'String', num2str(gui_SX.variables.radial_divi));
end


% Bias x
if gui_SX.variables.box_bias_x < -0.5 || gui_SX.variables.box_bias_x > 0.5
    set(gui_SX.handles.mesh.box_bias_x_val, 'String', num2str(gui_SX.variables.box_bias_x_init));
    gui_SX.variables.box_bias_x = -(str2num(get(gui_SX.handles.mesh.box_bias_x_val, 'String')));
end

% Bias z
if gui_SX.variables.box_bias_z < -0.5 || gui_SX.variables.box_bias_z > 0.5
    set(gui_SX.handles.mesh.box_bias_z_val, 'String', num2str(gui_SX.variables.box_bias_z_init));
    gui_SX.variables.box_bias_z =(str2num(get(gui_SX.handles.mesh.box_bias_z_val, 'String')));
end

% Bias conv_x
if gui_SX.variables.box_bias_conv_x < -0.5 || gui_SX.variables.box_bias_conv_x > 0.5
    set(gui_SX.handles.mesh.box_bias_conv_x_val, 'String', num2str(gui_SX.variables.box_bias_conv_x_init));
    gui_SX.variables.box_bias_conv_x =(str2num(get(gui_SX.handles.mesh.box_bias_conv_x_val, 'String')));
end

guidata(gcf, gui_SX);

end