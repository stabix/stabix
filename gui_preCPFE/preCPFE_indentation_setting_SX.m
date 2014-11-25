% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_indentation_setting_SX
%% Function to set SX indentation inputs (tip radius, indentation depth...) and plot of meshing
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gdata = guidata(gcf);

%% Set positive values in case of missing parameters
% Indenter parameters
set_default_values_txtbox(gdata.handles.indenter.coneAngle_val, num2str(gdata.defaults.variables.coneAngle));
set_default_values_txtbox(gdata.handles.indenter.tipRadius_val, num2str(gdata.defaults.variables.tipRadius));
set_default_values_txtbox(gdata.handles.indenter.h_indent_val, num2str(gdata.defaults.variables.h_indent));
% Mesh parameters
set_default_values_txtbox(gdata.handles.mesh.box_xfrac_val, num2str(gdata.defaults.variables.box_xfrac));
set_default_values_txtbox(gdata.handles.mesh.box_zfrac_val, num2str(gdata.defaults.variables.box_zfrac));
set_default_values_txtbox(gdata.handles.mesh.D_sample_val, num2str(gdata.defaults.variables.D_sample));
set_default_values_txtbox(gdata.handles.mesh.h_sample_val, num2str(gdata.defaults.variables.h_sample));
set_default_values_txtbox(gdata.handles.mesh.r_center_frac_val, num2str(gdata.defaults.variables.r_center_frac));
set_default_values_txtbox(gdata.handles.mesh.sample_rep_val, num2str(gdata.defaults.variables.sample_rep));
set_default_values_txtbox(gdata.handles.mesh.box_elm_nx_val, num2str(gdata.defaults.variables.box_elm_nx));
set_default_values_txtbox(gdata.handles.mesh.box_elm_nz_val, num2str(gdata.defaults.variables.box_elm_nz));
set_default_values_txtbox(gdata.handles.mesh.radial_divi_val, num2str(gdata.defaults.variables.radial_divi));
% Bias parameters
if strfind(gdata.config.CPFEM.fem_solver_used, 'Abaqus')
    set_default_values_txtbox(gdata.handles.mesh.box_bias_x_val, num2str(gdata.defaults.variables.box_bias_x_abaqus));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_z_val, num2str(gdata.defaults.variables.box_bias_z_abaqus));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_conv_x_val, num2str(gdata.defaults.variables.box_bias_conv_x_abaqus));
elseif strfind(gdata.config.CPFEM.fem_solver_used, 'Mentat')
    set_default_values_txtbox(gdata.handles.mesh.box_bias_x_val, num2str(gdata.defaults.variables.box_bias_x_mentat));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_z_val, num2str(gdata.defaults.variables.box_bias_z_mentat));
    set_default_values_txtbox(gdata.handles.mesh.box_bias_conv_x_val, num2str(gdata.defaults.variables.box_bias_conv_x_mentat));
end

%% Set mesh level
gdata.variables.mesh_quality_lvl = ...
    str2num(get(gdata.handles.other_setting.mesh_quality_lvl_val, 'String'));

gdata.variables.box_elm_nx  = round(gdata.defaults.variables.box_elm_nx * gdata.variables.mesh_quality_lvl);
gdata.variables.box_elm_nz  = round(gdata.defaults.variables.box_elm_nz * gdata.variables.mesh_quality_lvl);
gdata.variables.radial_divi = round(gdata.defaults.variables.radial_divi * gdata.variables.mesh_quality_lvl);
set(gdata.handles.mesh.box_elm_nx_val, 'String', num2str(gdata.variables.box_elm_nx));
set(gdata.handles.mesh.box_elm_nz_val, 'String', num2str(gdata.variables.box_elm_nz));
set(gdata.handles.mesh.radial_divi_val, 'String', num2str(gdata.variables.radial_divi));

guidata(gcf, gdata);

%% Definition of mesh/geometry variables
preCPFE_set_indenter;
gdata = guidata(gcf);
% Sample variables
gdata.variables.D_sample        = str2num(get(gdata.handles.mesh.D_sample_val, 'String'));
gdata.variables.h_sample        = str2num(get(gdata.handles.mesh.h_sample_val, 'String'));
gdata.variables.r_center_frac   = str2num(get(gdata.handles.mesh.r_center_frac_val, 'String'));
gdata.variables.box_xfrac       = str2num(get(gdata.handles.mesh.box_xfrac_val, 'String'));
gdata.variables.box_zfrac       = str2num(get(gdata.handles.mesh.box_zfrac_val, 'String'));
gdata.variables.sample_rep      = str2num(get(gdata.handles.mesh.sample_rep_val, 'String'));
gdata.variables.box_elm_nx      = round(str2num(get(gdata.handles.mesh.box_elm_nx_val, 'String')));
gdata.variables.box_elm_nz      = round(str2num(get(gdata.handles.mesh.box_elm_nz_val, 'String')));
gdata.variables.radial_divi     = round(str2num(get(gdata.handles.mesh.radial_divi_val, 'String')));
gdata.variables.box_bias_x      = str2num(get(gdata.handles.mesh.box_bias_x_val, 'String'));
gdata.variables.box_bias_z      = str2num(get(gdata.handles.mesh.box_bias_z_val, 'String'));
gdata.variables.box_bias_conv_x = str2num(get(gdata.handles.mesh.box_bias_conv_x_val, 'String'));

% Setting of the small value (smv), when sample_rep is too high ==> Distorsion of elements...
if gdata.variables.sample_rep == 32 || gdata.variables.sample_rep == 48
    gdata.variables.smv = 0.001;
else
    gdata.variables.smv = 0.01;
end

%% Set valid inputs in case of wrong inputs
guidata(gcf, gdata);
preCPFE_set_valid_inputs_SX;
gdata = guidata(gcf);

%% Definition of geometry points coordinates
% Radial coordinates of points for the mesh of indenter
jj = 0;
for ii = 1:41
    gdata.variables.indenter_mesh_x(ii) = ...
        jj*preCPFE_indentation_transition_depth(...
        gdata.variables.tipRadius, gdata.variables.coneAngle/2);
    jj = jj+0.025;
    gdata.variables.indenter_mesh_y(ii) = 0;
end

gdata.variables.coneHeight = gdata.variables.h_sample/4;

% Coordinates of points for the mesh of indenter before indentation
gdata.variables.indenter_mesh_z = -(((gdata.variables.tipRadius.^2)-(gdata.variables.indenter_mesh_x.^2)).^0.5)+gdata.variables.tipRadius;
gdata.variables.indenter_mesh_con = [max(gdata.variables.indenter_mesh_x) 0 max(gdata.variables.indenter_mesh_z);...
    ((max(gdata.variables.indenter_mesh_x)+((max(gdata.variables.indenter_mesh_z)+gdata.variables.coneHeight)/(tand(90-gdata.variables.coneAngle/2)))))...
    0 (max(gdata.variables.indenter_mesh_z)+gdata.variables.coneHeight)];

% Coordinates of points for the mesh of indenter after indentation
gdata.variables.indenter_mesh_z_post = -(((gdata.variables.tipRadius.^2)-(gdata.variables.indenter_mesh_x.^2)).^0.5)+gdata.variables.tipRadius-gdata.variables.h_indent;
gdata.variables.indenter_mesh_con_post = [max(gdata.variables.indenter_mesh_x) 0 max(gdata.variables.indenter_mesh_z_post); ...
    ((max(gdata.variables.indenter_mesh_x)+((max(gdata.variables.indenter_mesh_z_post)+gdata.variables.coneHeight+gdata.variables.h_indent)/(tand(90-gdata.variables.coneAngle/2)))))...
    0 (max(gdata.variables.indenter_mesh_z_post)+gdata.variables.coneHeight)];

% Coordinates of points for the mesh of sample
gdata.variables.box_x_start = gdata.variables.r_center_frac * gdata.variables.box_xfrac * gdata.variables.D_sample/2;
gdata.variables.box_x_end   = gdata.variables.box_xfrac * gdata.variables.D_sample/2;
gdata.variables.box_z_end   = -gdata.variables.box_zfrac * gdata.variables.h_sample;


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
%gdata.variables.cyl1_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used,0, gdata.variables.box_x_start, gdata.variables.box_elm_nx, 0);
gdata.variables.cyl1_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, 0, gdata.variables.box_x_start, gdata.variables.sample_rep/4, 0);
gdata.variables.cyl1_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, 0, gdata.variables.box_z_end, gdata.variables.box_elm_nz, -gdata.variables.box_bias_z);
[gdata.variables.cyl1_x, gdata.variables.cyl1_z] = meshgrid(gdata.variables.cyl1_x_pts, gdata.variables.cyl1_z_pts);

% Meshgrid for the lower cylinder (2)
%gdata.variables.cyl2_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, 0, gdata.variables.box_x_start, gdata.variables.box_elm_nx, 0);
gdata.variables.cyl2_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, 0, gdata.variables.box_x_start, gdata.variables.sample_rep/4, 0);
gdata.variables.cyl2_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.box_z_end, -gdata.variables.h_sample, gdata.variables.radial_divi, -gdata.variables.box_bias_conv_x);
[gdata.variables.cyl2_x, gdata.variables.cyl2_z] = meshgrid(gdata.variables.cyl2_x_pts, gdata.variables.cyl2_z_pts);

% Meshgrid for the box part (3)
gdata.variables.box_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.box_x_start, gdata.variables.box_x_end, gdata.variables.box_elm_nx, -gdata.variables.box_bias_x);
gdata.variables.box_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, 0, gdata.variables.box_z_end, gdata.variables.box_elm_nz, -gdata.variables.box_bias_z);
[gdata.variables.box_x, gdata.variables.box_z] = meshgrid(gdata.variables.box_x_pts, gdata.variables.box_z_pts);

% Meshgrid for the outer part (4)
gdata.variables.outer_x_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.box_x_end, gdata.variables.D_sample/2, gdata.variables.radial_divi, -gdata.variables.box_bias_conv_x);
gdata.variables.outer_z_pts = gdata.variables.box_z_pts;
[gdata.variables.outer_x, gdata.variables.outer_z] = meshgrid(gdata.variables.outer_x_pts, gdata.variables.outer_z_pts);
for ix = 1:size(gdata.variables.outer_z,2)
    for iz = 1:size(gdata.variables.outer_z,1)
        gdata.variables.outer_z(iz, ix) = gdata.variables.outer_z(iz, ix) - gdata.variables.outer_z_pts(iz)/gdata.variables.box_z_end * ...
            (gdata.variables.outer_x_pts(ix) - gdata.variables.box_x_end) / (gdata.variables.D_sample/2 - gdata.variables.box_x_end) * ...
            (gdata.variables.h_sample + gdata.variables.box_z_end);
    end
end

% Meshgrid for the lower part (5)
gdata.variables.lower_x_pts = gdata.variables.box_x_pts;
gdata.variables.lower_z_pts = preCPFE_bias(gdata.config.CPFEM.fem_solver_used, gdata.variables.box_z_end, -gdata.variables.h_sample, gdata.variables.radial_divi, -gdata.variables.box_bias_conv_x);
[gdata.variables.lower_x, gdata.variables.lower_z] = meshgrid(gdata.variables.lower_x_pts, gdata.variables.lower_z_pts);
for iz = 1:size(gdata.variables.lower_x,1)
    for ix = 1:size(gdata.variables.lower_x,2)
        gdata.variables.lower_x(iz, ix) = gdata.variables.lower_x(iz, ix) + (gdata.variables.lower_x_pts(ix)-gdata.variables.box_x_start)/(gdata.variables.box_x_end-gdata.variables.box_x_start) * ...
            abs((gdata.variables.lower_z_pts(iz) - gdata.variables.box_z_end)) / (gdata.variables.h_sample + gdata.variables.box_z_end) *...
            (gdata.variables.D_sample/2 - gdata.variables.box_x_end);
    end
end

guidata(gcf, gdata);

%% Initialization
cla;

%% Plot of the indenter
gdata.handle_indenter = preCPFE_indenter_plot;
guidata(gcf, gdata);
hold on;

%% Plot the sample mesh
gdata.handles.sample = preCPFE_mesh_plot_SX;
guidata(gcf, gdata);

%% Calculation of the number of elements
preCPFE_indentation_number_elements_SX;

%% Update of the CPFEM configuration
preCPFE_config_CPFEM_updated;

end
