% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_indentation_setting_SX
%% Function to set SX indentation inputs (tip radius, indentation depth...) and plot of meshing
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_SX = guidata(gcf);

%% Set positive values in case of missing parameters
set_default_values_txtbox(gui_SX.handles.mesh.coneAngle_val, num2str(gui_SX.defaults.variables.coneAngle));
set_default_values_txtbox(gui_SX.handles.mesh.tipRadius_val, num2str(gui_SX.defaults.variables.tipRadius));
set_default_values_txtbox(gui_SX.handles.mesh.h_indent_val, num2str(gui_SX.defaults.variables.h_indent));
set_default_values_txtbox(gui_SX.handles.mesh.box_xfrac_val, num2str(gui_SX.defaults.variables.box_xfrac));
set_default_values_txtbox(gui_SX.handles.mesh.box_zfrac_val, num2str(gui_SX.defaults.variables.box_zfrac));
set_default_values_txtbox(gui_SX.handles.mesh.D_sample_val, num2str(gui_SX.defaults.variables.D_sample));
set_default_values_txtbox(gui_SX.handles.mesh.h_sample_val, num2str(gui_SX.defaults.variables.h_sample));
set_default_values_txtbox(gui_SX.handles.mesh.r_center_frac_val, num2str(gui_SX.defaults.variables.r_center_frac));
set_default_values_txtbox(gui_SX.handles.mesh.sample_rep_val, num2str(gui_SX.defaults.variables.sample_rep));
set_default_values_txtbox(gui_SX.handles.mesh.box_elm_nx_val, num2str(gui_SX.defaults.variables.box_elm_nx));
set_default_values_txtbox(gui_SX.handles.mesh.box_elm_nz_val, num2str(gui_SX.defaults.variables.box_elm_nz));
set_default_values_txtbox(gui_SX.handles.mesh.radial_divi_val, num2str(gui_SX.defaults.variables.radial_divi));
set_default_values_txtbox(gui_SX.handles.mesh.box_bias_x_val, num2str(gui_SX.defaults.variables.box_bias_x));
set_default_values_txtbox(gui_SX.handles.mesh.box_bias_z_val, num2str(gui_SX.defaults.variables.box_bias_z));
set_default_values_txtbox(gui_SX.handles.mesh.box_bias_conv_x_val, num2str(gui_SX.defaults.variables.box_bias_conv_x));

%% Initialization
cla;

%% Set fine / coarse mesh
gui_SX.variables.meshquality = get(gui_SX.handles.pm_mesh_quality, 'Value');

if gui_SX.variables.meshquality ~= 1
    set(gui_SX.handles.mesh.box_elm_nx_val, 'String', num2str(gui_SX.defaults.variables.box_elm_nx));
    set(gui_SX.handles.mesh.box_elm_nz_val, 'String', num2str(gui_SX.defaults.variables.box_elm_nz));
    set(gui_SX.handles.mesh.radial_divi_val, 'String', num2str(gui_SX.defaults.variables.radial_divi));
    
    if gui_SX.variables.meshquality == 2
        gui_SX.variables.mesh_quality_lvl = 1;
    elseif gui_SX.variables.meshquality == 3
        gui_SX.variables.mesh_quality_lvl = 2;
    elseif gui_SX.variables.meshquality == 4
        gui_SX.variables.mesh_quality_lvl = 3;
    elseif gui_SX.variables.meshquality == 5
        gui_SX.variables.mesh_quality_lvl = 4;
    end
    
    gui_SX.variables.box_elm_nx      = round(str2num(get(gui_SX.handles.mesh.box_elm_nx_val, 'String')) * gui_SX.variables.mesh_quality_lvl);
    gui_SX.variables.box_elm_nz      = round(str2num(get(gui_SX.handles.mesh.box_elm_nz_val, 'String')) * gui_SX.variables.mesh_quality_lvl);
    gui_SX.variables.radial_divi     = round(str2num(get(gui_SX.handles.mesh.radial_divi_val, 'String')) * gui_SX.variables.mesh_quality_lvl);
    set(gui_SX.handles.mesh.box_elm_nx_val, 'String', num2str(gui_SX.variables.box_elm_nx));
    set(gui_SX.handles.mesh.box_elm_nz_val, 'String', num2str(gui_SX.variables.box_elm_nz));
    set(gui_SX.handles.mesh.radial_divi_val, 'String', num2str(gui_SX.variables.radial_divi));
    
    % else
    %     gui_SX.variables.box_elm_nx       = round(str2num(get(gui_SX.handles.mesh.box_elm_nx_val, 'String')) * gui_SX.variables.mesh_quality_lvl);
    %     gui_SX.variables.box_elm_nz       = round(str2num(get(gui_SX.handles.mesh.box_elm_nz_val, 'String')) * gui_SX.variables.mesh_quality_lvl);
    
end

%% Definition of mesh/geometry variables
% Indenter variables
gui_SX.variables.tipRadius = str2num(get(gui_SX.handles.mesh.tipRadius_val, 'String')); % Radius of cono-spherical indenter (in µm)
gui_SX.variables.coneAngle = str2num(get(gui_SX.handles.mesh.coneAngle_val, 'String')); % Full Angle of cono-spherical indenter (in °)
gui_SX.variables.h_indent  = str2num(get(gui_SX.handles.mesh.h_indent_val, 'String')); % Depth of indentation (in µm)
% Sample variables
gui_SX.variables.D_sample        = str2num(get(gui_SX.handles.mesh.D_sample_val, 'String'));
gui_SX.variables.h_sample        = str2num(get(gui_SX.handles.mesh.h_sample_val, 'String'));
gui_SX.variables.r_center_frac   = str2num(get(gui_SX.handles.mesh.r_center_frac_val, 'String'));
gui_SX.variables.box_xfrac       = str2num(get(gui_SX.handles.mesh.box_xfrac_val, 'String'));
gui_SX.variables.box_zfrac       = str2num(get(gui_SX.handles.mesh.box_zfrac_val, 'String'));
gui_SX.variables.sample_rep      = str2num(get(gui_SX.handles.mesh.sample_rep_val, 'String'));
gui_SX.variables.box_elm_nx      = round(str2num(get(gui_SX.handles.mesh.box_elm_nx_val, 'String')));
gui_SX.variables.box_elm_nz      = round(str2num(get(gui_SX.handles.mesh.box_elm_nz_val, 'String')));
gui_SX.variables.radial_divi     = round(str2num(get(gui_SX.handles.mesh.radial_divi_val, 'String')));
gui_SX.variables.box_bias_x      = str2num(get(gui_SX.handles.mesh.box_bias_x_val, 'String'));
gui_SX.variables.box_bias_z      = str2num(get(gui_SX.handles.mesh.box_bias_z_val, 'String'));
gui_SX.variables.box_bias_conv_x = str2num(get(gui_SX.handles.mesh.box_bias_conv_x_val, 'String'));

% Setting of the small value (smv), when sample_rep is too high ==> Distorsion of elements...
if gui_SX.variables.sample_rep == 32 || gui_SX.variables.sample_rep == 48
    gui_SX.variables.smv = 0.001;
else
    gui_SX.variables.smv = 0.01;
end

%% Set valid inputs in case of wrong inputs
guidata(gcf, gui_SX);
femproc_set_valid_inputs_SX;
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

%% Setting of the FEM interface
gui_SX.config_CPFEM.fem_interface_val = get(gui_SX.handles.pm_FEM_interface, 'Value');
gui_SX.config_CPFEM.fem_interface_all_str = get(gui_SX.handles.pm_FEM_interface, 'String');
gui_SX.config_CPFEM.fem_solver_str_cell = gui_SX.config_CPFEM.fem_interface_all_str(gui_SX.config_CPFEM.fem_interface_val);
gui_SX.config_CPFEM.fem_solver_used = gui_SX.config_CPFEM.fem_solver_str_cell{:};
gui_SX.config_CPFEM.fem_solver_version = sscanf(gui_SX.config_CPFEM.fem_solver_used, 'Mentat_%f');

%% Calculation of the transition depth between spherical and conical parts of the indenter
gui_SX.variables.h_trans = femproc_indentation_transition_depth(gui_SX.variables.tipRadius, gui_SX.variables.coneAngle/2);
gui_SX.variables.h_trans = round(gui_SX.variables.h_trans*100)/100;
set(gui_SX.handles.trans_depth , 'String', strcat('Transition depth (µm) : ',num2str(gui_SX.variables.h_trans)));

%% Definition of geometry points coordinates
% Radial coordinates of points for the mesh of indenter
jj = 0;
for ii = 1:41
    gui_SX.variables.indenter_mesh_x(ii) = jj*femproc_indentation_transition_depth(gui_SX.variables.tipRadius, gui_SX.variables.coneAngle/2);
    jj = jj+0.025;
    gui_SX.variables.indenter_mesh_y(ii) = 0;
end

gui_SX.variables.coneHeight=gui_SX.variables.h_sample/4;

% Coordinates of points for the mesh of indenter before indentation
gui_SX.variables.indenter_mesh_z   = -(((gui_SX.variables.tipRadius.^2)-(gui_SX.variables.indenter_mesh_x.^2)).^0.5)+gui_SX.variables.tipRadius;
gui_SX.variables.indenter_mesh_con = [max(gui_SX.variables.indenter_mesh_x) 0 max(gui_SX.variables.indenter_mesh_z);...
    ((max(gui_SX.variables.indenter_mesh_x)+((max(gui_SX.variables.indenter_mesh_z)+gui_SX.variables.coneHeight)/(tand(90-gui_SX.variables.coneAngle/2)))))...
    0 (max(gui_SX.variables.indenter_mesh_z)+gui_SX.variables.coneHeight)];

% Coordinates of points for the mesh of indenter after indentation
gui_SX.variables.indenter_mesh_z_post   = -(((gui_SX.variables.tipRadius.^2)-(gui_SX.variables.indenter_mesh_x.^2)).^0.5)+gui_SX.variables.tipRadius-gui_SX.variables.h_indent;
gui_SX.variables.indenter_mesh_con_post = [max(gui_SX.variables.indenter_mesh_x) 0 max(gui_SX.variables.indenter_mesh_z_post); ...
    ((max(gui_SX.variables.indenter_mesh_x)+((max(gui_SX.variables.indenter_mesh_z_post)+gui_SX.variables.coneHeight+gui_SX.variables.h_indent)/(tand(90-gui_SX.variables.coneAngle/2)))))...
    0 (max(gui_SX.variables.indenter_mesh_z_post)+gui_SX.variables.coneHeight)];

% Coordinates of points for the mesh of sample
gui_SX.variables.box_x_start = gui_SX.variables.r_center_frac * gui_SX.variables.box_xfrac * gui_SX.variables.D_sample/2;
gui_SX.variables.box_x_end   = gui_SX.variables.box_xfrac * gui_SX.variables.D_sample/2;
gui_SX.variables.box_z_end   = -gui_SX.variables.box_zfrac * gui_SX.variables.h_sample;

gui_SX.variables.sample_allpts = [0 0 0;...
    gui_SX.variables.D_sample/2 0 0;...
    gui_SX.variables.D_sample/2 0 -gui_SX.variables.h_sample;...
    0 0 -gui_SX.variables.h_sample;
    gui_SX.variables.box_x_end 0 0;
    gui_SX.variables.box_x_end 0 gui_SX.variables.box_z_end;
    0 0 gui_SX.variables.box_z_end;
    gui_SX.variables.box_x_start 0 0;
    gui_SX.variables.box_x_start 0 -gui_SX.variables.h_sample];

% Set faces for the mesh of sample
gui_SX.variables.faces_sample = [1 2 3 4;...
    1 5 6 7;...
    1 8 9 4;...
    6 3 3 6];

%% Meshing (Cross section view of the sample + indenter)
%    / <--Indenter
%   /
% ---|------|-----|
%    |      |     |
%  1 |  3   |  4  |
% ---|------|     |
%    |       \    |
%    |        \   |
%  2 |    5    \  |
%    |          \ |
%  --|-----------\|

% Meshgrid for the upper cylinder (1)
%gui_SX.variables.cyl1_x_pts = mentat_bias(0, gui_SX.variables.box_x_start, gui_SX.variables.box_elm_nx, 0);
gui_SX.variables.cyl1_x_pts = mentat_bias(0, gui_SX.variables.box_x_start, gui_SX.variables.sample_rep/4, 0);
gui_SX.variables.cyl1_z_pts = mentat_bias(0, gui_SX.variables.box_z_end, gui_SX.variables.box_elm_nz, -gui_SX.variables.box_bias_z);
[gui_SX.variables.cyl1_x, gui_SX.variables.cyl1_z] = meshgrid(gui_SX.variables.cyl1_x_pts, gui_SX.variables.cyl1_z_pts);

% Meshgrid for the lower cylinder (2)
%gui_SX.variables.cyl2_x_pts = mentat_bias(0, gui_SX.variables.box_x_start, gui_SX.variables.box_elm_nx, 0);
gui_SX.variables.cyl2_x_pts = mentat_bias(0, gui_SX.variables.box_x_start, gui_SX.variables.sample_rep/4, 0);
gui_SX.variables.cyl2_z_pts = mentat_bias(gui_SX.variables.box_z_end, -gui_SX.variables.h_sample, gui_SX.variables.radial_divi, -gui_SX.variables.box_bias_conv_x);
[gui_SX.variables.cyl2_x, gui_SX.variables.cyl2_z] = meshgrid(gui_SX.variables.cyl2_x_pts, gui_SX.variables.cyl2_z_pts);

% Meshgrid for the box part (3)
gui_SX.variables.box_x_pts = mentat_bias(gui_SX.variables.box_x_start, gui_SX.variables.box_x_end, gui_SX.variables.box_elm_nx, -gui_SX.variables.box_bias_x);
gui_SX.variables.box_z_pts = mentat_bias(0, gui_SX.variables.box_z_end, gui_SX.variables.box_elm_nz, -gui_SX.variables.box_bias_z);
[gui_SX.variables.box_x, gui_SX.variables.box_z] = meshgrid(gui_SX.variables.box_x_pts, gui_SX.variables.box_z_pts);

% Meshgrid for the outer part (4)
gui_SX.variables.outer_x_pts = mentat_bias(gui_SX.variables.box_x_end, gui_SX.variables.D_sample/2, gui_SX.variables.radial_divi, -gui_SX.variables.box_bias_conv_x);
gui_SX.variables.outer_z_pts = gui_SX.variables.box_z_pts;
[gui_SX.variables.outer_x, gui_SX.variables.outer_z] = meshgrid(gui_SX.variables.outer_x_pts, gui_SX.variables.outer_z_pts);
for ix = 1:size(gui_SX.variables.outer_z,2)
    for iz = 1:size(gui_SX.variables.outer_z,1)
        gui_SX.variables.outer_z(iz, ix) = gui_SX.variables.outer_z(iz, ix) - gui_SX.variables.outer_z_pts(iz)/gui_SX.variables.box_z_end * ...
            (gui_SX.variables.outer_x_pts(ix) - gui_SX.variables.box_x_end) / (gui_SX.variables.D_sample/2 - gui_SX.variables.box_x_end) * ...
            (gui_SX.variables.h_sample + gui_SX.variables.box_z_end);
    end
end

% Meshgrid for the lower part (5)
gui_SX.variables.lower_x_pts = gui_SX.variables.box_x_pts;
gui_SX.variables.lower_z_pts = mentat_bias(gui_SX.variables.box_z_end, -gui_SX.variables.h_sample, gui_SX.variables.radial_divi, -gui_SX.variables.box_bias_conv_x);
[gui_SX.variables.lower_x, gui_SX.variables.lower_z] = meshgrid(gui_SX.variables.lower_x_pts, gui_SX.variables.lower_z_pts);
for iz = 1:size(gui_SX.variables.lower_x,1)
    for ix = 1:size(gui_SX.variables.lower_x,2)
        gui_SX.variables.lower_x(iz, ix) = gui_SX.variables.lower_x(iz, ix) + (gui_SX.variables.lower_x_pts(ix)-gui_SX.variables.box_x_start)/(gui_SX.variables.box_x_end-gui_SX.variables.box_x_start) * ...
            abs((gui_SX.variables.lower_z_pts(iz) - gui_SX.variables.box_z_end)) / (gui_SX.variables.h_sample + gui_SX.variables.box_z_end) *...
            (gui_SX.variables.D_sample/2 - gui_SX.variables.box_x_end);
    end
end

%% Plot
% Plot of the cono-spherical indenter
gui_SX.handles.ind_SX_1 = plot3(gui_SX.variables.indenter_mesh_x, gui_SX.variables.indenter_mesh_y, gui_SX.variables.indenter_mesh_z); hold on;
gui_SX.handles.ind_SX_2 = plot3(gui_SX.variables.indenter_mesh_con(:,1), gui_SX.variables.indenter_mesh_con(:,2), gui_SX.variables.indenter_mesh_con(:,3),'LineStyle','-'); hold on;
gui_SX.handles.ind_SX_3 = plot3(gui_SX.variables.indenter_mesh_x, gui_SX.variables.indenter_mesh_y, gui_SX.variables.indenter_mesh_z_post); hold on;
gui_SX.handles.ind_SX_4 = plot3(gui_SX.variables.indenter_mesh_con_post(:,1), gui_SX.variables.indenter_mesh_con_post(:,2), gui_SX.variables.indenter_mesh_con_post(:,3),'LineStyle','-'); hold on;

% Plot of the sample
gui_SX.handles.sample_patch = patch('Vertices', gui_SX.variables.sample_allpts,'Faces', gui_SX.variables.faces_sample,'FaceAlpha',0.05);

% Plot of the mesh
gui_SX.handles.meshSX_1 = surf(gui_SX.variables.box_x, zeros(size(gui_SX.variables.box_x)), gui_SX.variables.box_z, 'FaceColor', 'w'); hold on;
gui_SX.handles.meshSX_2 = surf(gui_SX.variables.outer_x, zeros(size(gui_SX.variables.outer_x)), gui_SX.variables.outer_z, 'FaceColor', 'w'); hold on;
gui_SX.handles.meshSX_3 = surf(gui_SX.variables.cyl1_x, zeros(size(gui_SX.variables.cyl1_x)), gui_SX.variables.cyl1_z, 'FaceColor', 'w'); hold on;
gui_SX.handles.meshSX_4 = surf(gui_SX.variables.cyl2_x, zeros(size(gui_SX.variables.cyl2_x)), gui_SX.variables.cyl2_z, 'FaceColor', 'w'); hold on;
gui_SX.handles.meshSX_5 = surf(gui_SX.variables.lower_x, zeros(size(gui_SX.variables.lower_x)), gui_SX.variables.lower_z, 'FaceColor', 'w'); hold on;

% Axis setting
axis tight; % Axis tight to the sample
axis equal; % Axis aspect ratio
view(0,0); % X-Z view

% if isfield(gui_SX, 'config_map')
%     if isfield(gui_SX.config_map, 'unit_string')
%         xlabel_str = strcat('x axis_', gui_SX.config_map.unit_string);
%         zlabel_str = strcat('z axis_', gui_SX.config_map.unit_string);
%     end
%     xlabel_str = 'x axis';
%     ylabel_str = 'y axis';
%     zlabel_str = 'z axis';
% else
%     xlabel_str = 'x axis';
%     zlabel_str = 'z axis';
% end
%
% xlabel(xlabel_str);
% zlabel(zlabel_str);

%% Calculation of the number of elements
guidata(gcf, gui_SX);
femproc_indentation_number_elements_SX;
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

%% Update of the CPFEM configuration
femproc_config_CPFEM_updated
end
