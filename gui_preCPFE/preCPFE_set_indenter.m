% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_set_indenter
%% Function to import topography from Gwyddion file

% author: d.mercier@mpie.de

gui = guidata(gcf);

%%
indenter_index = get(gui.handles.indenter.pm_indenter, 'Value');
if indenter_index == 1
    gui.indenter_type = 'conical';
elseif indenter_index == 2
    gui.indenter_type = 'Berkovich';
elseif indenter_index == 3
    gui.indenter_type = 'Vickers';
elseif indenter_index == 4
    gui.indenter_type = 'cubeCorner';
elseif indenter_index == 5
    gui.indenter_type = 'flatPunch';
elseif indenter_index == 6
    gui.indenter_type = 'AFM';
end

gui.variables.h_indent  = ...
    str2num(get(gui.handles.indenter.h_indent_val, 'String')); % Depth of indentation (in µm)
% tipRadius is used for conospherical and flat punch
gui.variables.tipRadius = ...
    str2num(get(gui.handles.indenter.tipRadius_val, 'String')); % Radius of cono-spherical indenter (in µm)

if indenter_index == 1
    % Indenter variables
    gui.variables.coneAngle = ...
        str2num(get(gui.handles.indenter.coneAngle_val, 'String')); % Full Angle of cono-spherical indenter (in °)
    
    % Calculation of transition depth between spherical and conical parts of the indenter
    gui.variables.h_trans = ...
        preCPFE_indentation_transition_depth(...
        gui.variables.tipRadius, gui.variables.coneAngle/2);
    gui.variables.h_trans = round(gui.variables.h_trans*100)/100;
    set(gui.handles.indenter.trans_depth , 'String', ...
        sprintf('Transition depth: %.2f ', gui.variables.h_trans));
    
    % Calculation of radius of the spherical cap in the cono-spherical indenter
    gui.variables.calRadius = (gui.variables.tipRadius^2 - ...
        (gui.variables.tipRadius - gui.variables.h_trans)^2)^0.5;
end
guidata(gcf, gui);
%%
set(gui.handles.indenter.move, 'Value', ...
    get(gui.handles.indenter.h_indent_str, 'Value'));

preCPFE_indenter_update_controls;
gui.handle_indenter = preCPFE_indenter_plot;
guidata(gcf, gui);
end