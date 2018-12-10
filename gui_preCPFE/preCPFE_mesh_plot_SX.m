% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h_sample = preCPFE_mesh_plot_SX()

gui_SX = guidata(gcf);
h_sample = struct;

%% Store old view settings
if isfield(gui_SX.handles, 'sample')
    [old_az, old_el] = view;
else
    old_az = 0; % old azimuth value
    old_el = 0; % old elevation value
end

%% Plot of the sample
try
    [cylX, cylY, cylZ] = cylinder(gui_SX.variables.D_sample/2, ...
        gui_SX.variables.sample_rep);
    cylZ = -cylZ * gui_SX.variables.h_sample;
    h_sample.cyl = surf(cylX, cylY, cylZ);
catch id
    disp(id)
    h_sample.cyl(1) = plotCircle3D([0,0,1], ...
        [0,0,0], gui_SX.variables.D_sample/2);
    h_sample.cyl(2) = plotCircle3D([0,0,1], ...
        [0,0,-gui_SX.variables.h_sample], gui_SX.variables.D_sample/2);
end

meshSX(1) = surf(gui_SX.variables.box_x, ...
    zeros(size(gui_SX.variables.box_x)), gui_SX.variables.box_z);
meshSX(2) = surf(gui_SX.variables.outer_x, ...
    zeros(size(gui_SX.variables.outer_x)), gui_SX.variables.outer_z);
meshSX(3) = surf(gui_SX.variables.cyl1_x, ...
    zeros(size(gui_SX.variables.cyl1_x)), gui_SX.variables.cyl1_z);
meshSX(4) = surf(gui_SX.variables.cyl2_x, ...
    zeros(size(gui_SX.variables.cyl2_x)), gui_SX.variables.cyl2_z);
meshSX(5) = surf(gui_SX.variables.lower_x, ...
    zeros(size(gui_SX.variables.lower_x)), gui_SX.variables.lower_z);

h_sample.meshSX = meshSX;

set([h_sample.meshSX, h_sample.cyl], ...
    'FaceColor', [1 1 1], 'FaceAlpha', 0, 'Linewidth', 1);
set(h_sample.cyl, 'EdgeAlpha', 0.1);

view(old_az, old_el);

preCPFE_mesh_plot_finalize;

end