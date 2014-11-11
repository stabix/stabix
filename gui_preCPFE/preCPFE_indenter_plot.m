% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handle_indenter = preCPFE_indenter_plot
%% Function to set plot of 3D indenter

% author: d.mercier@mpie.de, c.zambaldi@mpie.de

gui = guidata(gcf);

if isfield(gui, 'handle_indenter')
    try
        delete(gui.handle_indenter)
    catch id
        disp(id.message)
    end
end

%% Set indentation depth
h_indent = 0;
try
    if get(gui.handles.indenter.move,'Value')
        h_indent = gui.variables.h_indent;
    end
catch id
    disp(id)
end

% if ~isfield(gui, 'indenter_type')
%     gui.indenter_type = 'conical';
% end

%% Set plot of indenter
if strcmp(gui.indenter_type, 'conical') == 1
    handle_indenter = ...
        preCPFE_3d_conospherical_indenter(gui.variables.tipRadius, ...
        gui.variables.coneAngle, 50, 0, 0, ...
        gui.variables.tipRadius - h_indent);

elseif strcmp(gui.indenter_type, 'Berkovich') == 1
    [handle_indenter, ~] = preCPFE_3d_polygon_indenter(3, 65.3, ...
        2*gui.variables.h_indent, -h_indent);
    
elseif strcmp(gui.indenter_type, 'Vickers') == 1
    [handle_indenter, ~] = preCPFE_3d_polygon_indenter(4, 68, ...
        2*gui.variables.h_indent, -h_indent);
    
elseif strcmp(gui.indenter_type, 'cubeCorner') == 1
    [handle_indenter, ~] = preCPFE_3d_polygon_indenter(3, 35.26, ...
        2*gui.variables.h_indent, -h_indent);
    
elseif strcmp(gui.indenter_type, 'flatPunch') == 1
    handle_indenter = preCPFE_3d_flat_punch_indenter(...
        gui.variables.tipRadius, 0, 0, ...
        -h_indent, 2*gui.variables.h_indent);
    
elseif strcmp(gui.indenter_type, 'AFM') == 1
    smooth_factor_value = ...
        get(gui.handles.indenter.pm_indenter_mesh_quality, 'Value');
    smooth_factor_string = ...
        get(gui.handles.indenter.pm_indenter_mesh_quality, 'String');
    smooth_factor = 2^(1 + length(smooth_factor_string) - ...
        smooth_factor_value);
    
    if ~isfield(gui, 'indenter_topo')
        guidata(gcf, gui);
        preCPFE_load_AFM_indenter();
        gui = guidata(gcf);
    end
    
    [gui.afm_topo_indenter.X, gui.afm_topo_indenter.Y,...
        gui.afm_topo_indenter.data, fvc, ...
        handle_indenter] =...
        preCPFE_3d_indenter_topo_AFM(gui.indenter_topo,...
        h_indent, smooth_factor);
    guidata(gcf, gui);
end

colormap white;

%% Rotate indenter
% rotation_angle: Angle to rotate indenter (from 0 to 360°) in degrees

rotation_angle = get(gui.handles.indenter.rotate_loaded_indenter, 'Value');
rotation_angle = round(rotation_angle * 10) / 10; % 0.1 deg steps
set(gui.handles.indenter.rotate_loaded_indenter, 'Value', rotation_angle);
set(gui.handles.indenter.rotate_loaded_indenter_box, 'String', sprintf('%.1f',rotation_angle));

direction = [0 0 1]; % along z-axis
origin = [0,0,0];

rotate(handle_indenter, direction, rotation_angle, origin);

% Update fvc after rotation... %FIXME: WHY? We don't need it yet...
% See patch2inp function
if numel(handle_indenter) == 1  %~strcmpi(gui.indenter_type,'conical')
    if strcmpi(get(handle_indenter, 'Type'), 'Surface')
        fvc = surf2patch(handle_indenter);
    elseif strcmpi(get(handle_indenter, 'Type'), 'Patch')
        fvc = struct;
        fvc.faces = get(handle_indenter, 'Faces');
        fvc.vertices = get(handle_indenter, 'Vertices');
    end
else
    fvc = NaN;
end

%% Save encapsulated data
%guidata(gcf, gui);
axis tight

end