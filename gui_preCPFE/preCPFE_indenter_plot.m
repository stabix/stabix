% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [fvc, handle_indenter] = preCPFE_indenter_plot
%% Function to set plot of 3D indenter

% author: d.mercier@mpie.de

gui = guidata(gcf);

%% Set indentation depth
if get(gui.handles.other_setting.cb_indenter_post_indentation,'Value') == 0
    h_indent = 0;
else
    h_indent = gui.variables.h_indent;
end

%% Set plot of indenter
if strcmp(gui.indenter_type, 'conical') == 1
    [fvc, handle_indenter_sphere, handle_indenter_cone] = ...
        preCPFE_3d_conospherical_indenter(gui.variables.tipRadius, ...
        gui.variables.coneAngle, 50, 0, 0, ...
        gui.variables.tipRadius - h_indent);
    handle_indenter = handle_indenter_sphere;
    % FIXME: conospherical indenter in 2 parts --> 2 handles
    % to fix in case we want to use surf2patch or patch2inp functions...
    
elseif strcmp(gui.indenter_type, 'Berkovich') == 1
    [fvc, handle_indenter] = preCPFE_3d_polygon_indenter(3, 65.3, ...
        2*gui.variables.h_indent, -h_indent);
    
elseif strcmp(gui.indenter_type, 'Vickers') == 1
    [fvc, handle_indenter] = preCPFE_3d_polygon_indenter(4, 68, ...
        2*gui.variables.h_indent, -h_indent);
    
elseif strcmp(gui.indenter_type, 'cubeCorner') == 1
    [fvc, handle_indenter] = preCPFE_3d_polygon_indenter(3, 35.26, ...
        2*gui.variables.h_indent, -h_indent);
    
elseif strcmp(gui.indenter_type, 'flatPunch') == 1
    [fvc, handle_indenter] = preCPFE_3d_flat_punch_indenter(...
        gui.variables.tipRadius, 0, 0, ...
        -h_indent, 2*gui.variables.h_indent);
    
elseif strcmp(gui.indenter_type, 'AFM') == 1
    smooth_factor_value = ...
        get(gui.handles.indenter.pm_indenter_mesh_quality, 'Value');
    
    smooth_factor_string = ...
        get(gui.handles.indenter.pm_indenter_mesh_quality, 'String');
    
    smooth_factor = 2^(1 + length(smooth_factor_string) - ...
        smooth_factor_value);
    
    [gui.afm_topo_indenter.X, gui.afm_topo_indenter.Y,...
        gui.afm_topo_indenter.data, fvc, ...
        handle_indenter] =...
        preCPFE_3d_indenter_topo_AFM(gui.indenter_topo,...
        h_indent, smooth_factor);
end

colormap gray;

%% Rotate indenter
% rotation_angle: Angle to rotate indenter (from 0 to 360°) in degrees

rotation_angle = ...
    get(gui.handles.indenter.rotate_loaded_indenter, 'Value');

direction = [0 0 1]; % along z-axis
origin = [0,0,0];

rotate(handle_indenter, direction, rotation_angle, origin);

% Update fvc after rotation...
% See patch2inp function
if strcmpi(get(handle_indenter, 'Type'), 'Surface')
    fvc = surf2patch(handle_indenter);
elseif strcmpi(get(handle_indenter, 'Type'), 'Patch')
    fvc = struct;
    fvc.faces = get(handle_indenter, 'Faces');
    fvc.vertices = get(handle_indenter, 'Vertices');
else
    error('not a patch or surf handle');
end

%% Save encapsulated data
guidata(gcf, gui);

end