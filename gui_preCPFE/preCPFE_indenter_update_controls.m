% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_indenter_update_controls
%% Function used to add a custom menu item in the GUI menubar

% authors: d.mercier@mpie.de, c.zambaldi@mpie.de

gui = guidata(gcf);

indenter = gui.handles.indenter;

%% Set rotation angle value
set(indenter.rotate_loaded_indenter_box, ...
    'String', get(indenter.rotate_loaded_indenter, 'Value'));

%% Get Indentation depth
h_ind = [indenter.h_indent_str, indenter.h_indent_val];
set(h_ind, 'visible', 'on');

%% Get tip radius
tipRadius = [indenter.tipRadius_str, indenter.tipRadius_val];
rotation = [indenter.rotate_loaded_indenter, ...
    indenter.rotate_loaded_indenter_str, ...
    indenter.rotate_loaded_indenter_box, ...
    indenter.rotate_loaded_indenter_unit];
coneAngle = [indenter.coneAngle_str, ...
    indenter.coneAngle_val, ...
    indenter.trans_depth];
set(rotation, 'visible', 'on');
set(coneAngle, 'visible', 'off');
set(indenter.pm_indenter_mesh_quality, 'visible', 'off');
set(indenter.load_AFM, 'visible', 'off');

%% Update GUIs buttons in function of indenter type
if strcmpi(gui.indenter_type, 'conical')
    set(coneAngle, 'visible', 'on');
    set(tipRadius, 'visible', 'on');
    set(rotation, 'visible', 'off');
    
elseif strcmpi(gui.indenter_type, 'Berkovich') || ...
        strcmpi(gui.indenter_type, 'Vickers') || ...
        strcmpi(gui.indenter_type, 'cubeCorner')
    set(tipRadius, 'visible', 'off');

elseif strcmpi(gui.indenter_type, 'flatPunch')
    set(tipRadius, 'visible', 'on');
    set(rotation, 'visible', 'off');
    
elseif strcmpi(gui.indenter_type, 'AFM')
    set(tipRadius, 'visible', 'off');
    set(indenter.pm_indenter_mesh_quality, 'visible', 'on');
    set(indenter.load_AFM, 'visible', 'on');
end

end