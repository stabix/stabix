% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_set_valid_inputs_BX
%% Function to set valid inputs in case of wrong inputs
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_BX = guidata(gcf);

% Tip radius
if gui_BX.variables.tipRadius < 0
    gui_BX.variables.tipRadius = abs(gui_BX.variables.tipRadius);
    set(gui_BX.handles.tipRadius_val, 'String', num2str(gui_BX.variables.tipRadius));
end

% Cone Angle
if gui_BX.variables.coneAngle < 0
    gui_BX.variables.coneAngle = abs(gui_BX.variables.coneAngle);
    set(gui_BX.handles.coneAngle_val, 'String', num2str(gui_BX.variables.coneAngle));
end

% Indent depth
if gui_BX.variables.h_indent < 0
    gui_BX.variables.h_indent = abs(gui_BX.variables.h_indent);
    set(gui_BX.handles.h_indent_val, 'String', num2str(gui_BX.variables.h_indent));
end

% Width of the sample
if gui_BX.variables.w_sample < 0
    gui_BX.variables.w_sample = abs(gui_BX.variables.w_sample);
    set(gui_BX.handles.w_sample_val, 'String', num2str(gui_BX.variables.w_sample));
end

% Heigth of the sample
if gui_BX.variables.h_sample < 0
    gui_BX.variables.h_sample = abs(gui_BX.variables.h_sample);
    set(gui_BX.handles.h_sample_val, 'String', num2str(gui_BX.variables.h_sample));
end

% Length of the sample
if gui_BX.variables.len_sample < 0
    gui_BX.variables.len_sample = abs(gui_BX.variables.len_sample);
    set(gui_BX.handles.len_sample_val, 'String', num2str(gui_BX.variables.len_sample));
end

% Inclination of the GB
if gui_BX.variables.inclination < 0
    gui_BX.variables.inclination = abs(gui_BX.variables.inclination);
    set(gui_BX.handles.inclination_val, 'String', num2str(gui_BX.variables.inclination));
end

% Bias x
if gui_BX.variables.box_bias_x < -0.5 || gui_BX.variables.box_bias_x > 0.5
    set(gui_BX.handles.box_bias_x_val, 'String', num2str(gui_BX.variables.box_bias_x_init));
    gui_BX.variables.box_bias_x  = (str2num(get(gui_BX.handles.box_bias_x_val, 'String')));
end

% Bias z
if gui_BX.variables.box_bias_z < -0.5 || gui_BX.variables.box_bias_z > 0.5
    set(gui_BX.handles.box_bias_z_val, 'String', num2str(gui_BX.variables.box_bias_z_init));
    gui_BX.variables.box_bias_z  = str2num(get(gui_BX.handles.box_bias_z_val, 'String'));
end

% Bias y1
if gui_BX.variables.box_bias_y1 < -0.5 || gui_BX.variables.box_bias_y1 > 0.5
    set(gui_BX.handles.box_bias_y1_val, 'String', num2str(gui_BX.variables.box_bias_y1_init));
    gui_BX.variables.box_bias_y1 = str2num(get(gui_BX.handles.box_bias_y1_val, 'String'));
end

% Bias y2
if gui_BX.variables.box_bias_y2 < -0.5 || gui_BX.variables.box_bias_y2 > 0.5
    set(gui_BX.handles.box_bias_y2_val, 'String', num2str(gui_BX.variables.box_bias_y2_init));
    gui_BX.variables.box_bias_y2 = str2num(get(gui_BX.handles.box_bias_y2_val, 'String'));
end

% Bias y3
if gui_BX.variables.box_bias_y3 < -0.5 || gui_BX.variables.box_bias_y3 > 0.5
    set(gui_BX.handles.box_bias_y3_val, 'String', num2str(gui_BX.variables.box_bias_y3_init));
    gui_BX.variables.box_bias_y3 = (str2num(get(gui_BX.handles.box_bias_y3_val, 'String')));
end

guidata(gcf, gui_BX);

end
