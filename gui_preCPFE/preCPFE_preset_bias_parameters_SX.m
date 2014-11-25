% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_preset_bias_parameters_SX
%% Function to set valid inputs for bias parameters
% author: d.mercier@mpie.de

preCPFE_set_CPFEM_solver

gui_SX = guidata(gcf);

if strfind(gui_SX.config.CPFEM.fem_solver_used, 'Abaqus')
    set(gui_SX.handles.mesh.box_bias_x_val, 'String', num2str(gui_SX.defaults.variables.box_bias_x_abaqus));
    set(gui_SX.handles.mesh.box_bias_x_str, 'String', 'box_bias_x (>= 1)');
    
    set(gui_SX.handles.mesh.box_bias_z_val, 'String', num2str(gui_SX.defaults.variables.box_bias_z_abaqus));
    set(gui_SX.handles.mesh.box_bias_z_str, 'String', 'box_bias_x (>= 1)');
    
    set(gui_SX.handles.mesh.box_bias_conv_x_val, 'String', num2str(gui_SX.defaults.variables.box_bias_conv_x_abaqus));
    set(gui_SX.handles.mesh.box_bias_conv_x_str, 'String', 'box_bias_x (>= 1)');
    
elseif strfind(gui_SX.config.CPFEM.fem_solver_used, 'Mentat')
    set(gui_SX.handles.mesh.box_bias_x_val, 'String', num2str(gui_SX.defaults.variables.box_bias_x_mentat));
    set(gui_SX.handles.mesh.box_bias_x_str, 'String', 'box_bias_x (-0.5 to 0.5)');
    
    set(gui_SX.handles.mesh.box_bias_z_val, 'String', num2str(gui_SX.defaults.variables.box_bias_z_mentat));
    set(gui_SX.handles.mesh.box_bias_z_str, 'String', 'box_bias_x (-0.5 to 0.5)');
    
    set(gui_SX.handles.mesh.box_bias_conv_x_val, 'String', num2str(gui_SX.defaults.variables.box_bias_conv_x_mentat));
    set(gui_SX.handles.mesh.box_bias_conv_x_str, 'String', 'box_bias_x (-0.5 to 0.5)');
end

end