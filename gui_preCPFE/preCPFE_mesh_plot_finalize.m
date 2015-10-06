% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_mesh_plot_finalize
%% Axis setting
% author: c.zambaldi@mpie.de

axis tight; % Axis tight to the sample
axis equal; % Axis aspect ratio
grid off;
xyzlabel;
rotate3d on;
shg;

end