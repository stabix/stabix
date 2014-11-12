% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_set_valid_inputs_BX
%% Function to set valid inputs in case of wrong inputs
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_BX = guidata(gcf);

% Tip radius
if gui_BX.variables.tipRadius < 0
    gui_BX.variables.tipRadius = abs(gui_BX.variables.tipRadius);
    set(gui_BX.handles.indenter.tipRadius_val, 'String', ...
        num2str(gui_BX.variables.tipRadius));
end

% Cone Angle
if gui_BX.variables.coneAngle < 0 || gui_BX.variables.coneAngle > 180
    set(gui_BX.handles.indenter.coneAngle_val, 'String', ...
        num2str(gui_BX.defaults.variables.coneAngle));
    gui_BX.variables.coneAngle = gui_BX.defaults.variables.coneAngle;
end

% Indent depth
if gui_BX.variables.h_indent < 0
    set(gui_BX.handles.indenter.h_indent_val, 'String', ...
        num2str(abs(gui_BX.variables.h_indent)));
    gui_BX.variables.h_indent = str2num(get(...
        gui_BX.handles.mesh.h_indent_val, 'String'));
elseif gui_BX.variables.h_indent == 0
    set(gui_BX.handles.indenter.h_indent_val, 'String', ...
        num2str(gui_BX.defaults.variables.h_indent));
    gui_BX.variables.h_indent = gui_BX.defaults.variables.h_indent;
end

% Width of the sample
if gui_BX.variables.w_sample < 0
    gui_BX.variables.w_sample = abs(gui_BX.variables.w_sample);
    set(gui_BX.handles.mesh.w_sample_val, 'String', ...
        num2str(gui_BX.variables.w_sample));
elseif gui_BX.variables.w_sample == 0
    set(gui_BX.handles.mesh.w_sample_val, 'String', ...
        num2str(gui_BX.defaults.variables.w_sample));
    gui_BX.variables.w_sample = gui_BX.defaults.variables.w_sample;
end

% Heigth of the sample
if gui_BX.variables.h_sample < 0
    gui_BX.variables.h_sample = abs(gui_BX.variables.h_sample);
    set(gui_BX.handles.mesh.h_sample_val, 'String', ...
        num2str(gui_BX.variables.h_sample));
elseif gui_BX.variables.h_sample == 0
    set(gui_BX.handles.mesh.h_sample_val, 'String', ...
        num2str(gui_BX.defaults.variables.h_sample));
    gui_BX.variables.h_sample = gui_BX.defaults.variables.h_sample;
end

% Length of the sample
if gui_BX.variables.len_sample < 0
    gui_BX.variables.len_sample = abs(gui_BX.variables.len_sample);
    set(gui_BX.handles.mesh.len_sample_val, 'String', ...
        num2str(gui_BX.variables.len_sample));
elseif gui_BX.variables.len_sample == 0
    set(gui_BX.handles.mesh.len_sample_val, 'String', ...
        num2str(gui_BX.defaults.variables.len_sample));
    gui_BX.variables.len_sample = gui_BX.defaults.variables.len_sample;
end

% Inclination of the GB
if gui_BX.variables.inclination < 0
    gui_BX.variables.inclination = abs(gui_BX.variables.inclination);
    set(gui_BX.handles.mesh.inclination_val, 'String', ...
        num2str(gui_BX.variables.inclination));
elseif gui_BX.variables.inclination == 0 ...
        || gui_BX.variables.inclination > 180
    set(gui_BX.handles.mesh.inclination_val, 'String', ...
        num2str(gui_BX.defaults.variables.inclination));
    gui_BX.variables.inclination = gui_BX.defaults.variables.inclination;
end

% Box elm nx
if gui_BX.variables.box_elm_nx <= 0
    set(gui_BX.handles.mesh.box_elm_nx_val, 'String', ...
        num2str(gui_BX.defaults.variables.box_elm_nx));
    gui_BX.variables.box_elm_nx = str2num(get(...
        gui_BX.handles.mesh.box_elm_nx_val, 'String'));
end

% Box elm nz
if gui_BX.variables.box_elm_nz <= 0
    set(gui_BX.handles.mesh.box_elm_nz_val, 'String', ...
        num2str(gui_BX.defaults.variables.box_elm_nz));
    gui_BX.variables.box_elm_nz = str2num(get(...
        gui_BX.handles.mesh.box_elm_nz_val, 'String'));
end

% Box elm ny1
if gui_BX.variables.box_elm_ny1 <= 0
    set(gui_BX.handles.mesh.box_elm_ny1_val, 'String', ...
        num2str(gui_BX.defaults.variables.box_elm_ny1));
    gui_BX.variables.box_elm_ny1 = str2num(get(...
        gui_BX.handles.mesh.box_elm_ny1_val, 'String'));
end

% Box elm ny2_fac
if gui_BX.variables.box_elm_ny2_fac <= 0
    set(gui_BX.handles.mesh.box_elm_ny2_fac_val, 'String', ...
        num2str(gui_BX.defaults.variables.box_elm_ny2_fac));
    gui_BX.variables.box_elm_ny2_fac = str2num(get(...
        gui_BX.handles.mesh.box_elm_ny2_fac_val, 'String'));
end

% Box elm ny3
if gui_BX.variables.box_elm_ny3 <= 0
    set(gui_BX.handles.mesh.box_elm_ny3_val, 'String', ...
        num2str(gui_BX.defaults.variables.box_elm_ny3));
    gui_BX.variables.box_elm_ny3 = str2num(get(...
        gui_BX.handles.mesh.box_elm_ny3_val, 'String'));
end

if strfind(gui_BX.config.CPFEM.fem_solver_used, 'Abaqus')
    % Bias x
    if gui_BX.variables.box_bias_x == 0
        set(gui_BX.handles.mesh.box_bias_x_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_x_abaqus));
        gui_BX.variables.box_bias_x = str2num(get(...
            gui_BX.handles.mesh.box_bias_x1_val, 'String'));
    end
    
    % Bias z
    if gui_BX.variables.box_bias_z == 0
        set(gui_BX.handles.mesh.box_bias_z_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_z_abaqus));
        gui_BX.variables.box_bias_z = str2num(get(...
            gui_BX.handles.mesh.box_bias_z1_val, 'String'));
    end
    
    % Bias y1
    if gui_BX.variables.box_bias_y1 == 0
        set(gui_BX.handles.mesh.box_bias_y1_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_y1_abaqus));
        gui_BX.variables.box_bias_y1 = str2num(get(...
            gui_BX.handles.mesh.box_bias_y1_val, 'String'));
    end
    
    % Bias y2
    if gui_BX.variables.box_bias_y2 == 0
        set(gui_BX.handles.mesh.box_bias_y2_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_y2_abaqus));
        gui_BX.variables.box_bias_y2 = str2num(get(...
            gui_BX.handles.mesh.box_bias_y2_val, 'String'));
    end
    
    % Bias y3
    if gui_BX.variables.box_bias_y3 == 0
        set(gui_BX.handles.mesh.box_bias_y3_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_y3_abaqus));
        gui_BX.variables.box_bias_y3 = (str2num(get(...
            gui_BX.handles.mesh.box_bias_y3_val, 'String')));
    end
    
elseif strfind(gui_BX.config.CPFEM.fem_solver_used, 'Mentat')
    % Bias x
    if gui_BX.variables.box_bias_x < -0.5 ...
            || gui_BX.variables.box_bias_x > 0.5
        set(gui_BX.handles.mesh.box_bias_x_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_x_mentat));
        gui_BX.variables.box_bias_x = str2num(get(...
            gui_BX.handles.mesh.box_bias_x_val, 'String'));
    end
    
    % Bias z
    if gui_BX.variables.box_bias_z < -0.5 ...
            || gui_BX.variables.box_bias_z > 0.5
        set(gui_BX.handles.mesh.box_bias_z_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_z_mentat));
        gui_BX.variables.box_bias_z = str2num(get(...
            gui_BX.handles.mesh.box_bias_z_val, 'String'));
    end
    
    % Bias y1
    if gui_BX.variables.box_bias_y1 < -0.5 ...
            || gui_BX.variables.box_bias_y1 > 0.5
        set(gui_BX.handles.mesh.box_bias_y1_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_y1_mentat));
        gui_BX.variables.box_bias_y1 = str2num(get(...
            gui_BX.handles.mesh.box_bias_y1_val, 'String'));
    end
    
    % Bias y2
    if gui_BX.variables.box_bias_y2 < -0.5 ...
            || gui_BX.variables.box_bias_y2 > 0.5
        set(gui_BX.handles.mesh.box_bias_y2_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_y2_mentat));
        gui_BX.variables.box_bias_y2 = str2num(get(...
            gui_BX.handles.mesh.box_bias_y2_val, 'String'));
    end
    
    % Bias y3
    if gui_BX.variables.box_bias_y3 < -0.5 ...
            || gui_BX.variables.box_bias_y3 > 0.5
        set(gui_BX.handles.mesh.box_bias_y3_val, 'String', ...
            num2str(gui_BX.defaults.variables.box_bias_y3_mentat));
        gui_BX.variables.box_bias_y3 = (str2num(get(...
            gui_BX.handles.mesh.box_bias_y3_val, 'String')));
    end
end

guidata(gcf, gui_BX);

end