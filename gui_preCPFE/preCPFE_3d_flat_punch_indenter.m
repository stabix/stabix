% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function handle_indenter = preCPFE_3d_flat_punch_indenter(tipRadius, X_position, Y_position, Z_position, szFac, varargin)
%% Function to plot a 3D flat punch indenter
% tipRadius : Radius of the flat punch indenter.
% szFac: Factor to scale the 3D plot.
% X_position, Y_position, Z_position : Coordinates of the center of the indenter.

% author: d.mercier@mpie.de

if nargin < 5
    szFac = 1;
end

if nargin < 4
    Z_position = 0;
end

if nargin < 3
    Y_position = 0;
end

if nargin < 2
    X_position = 0;
end

if nargin < 1
    tipRadius = 1;
end

%% Plot of the flat punch indenter

[X,Y,Z] = cylinder(tipRadius, 100);

x_cyl = X + X_position;
y_cyl = Y + Y_position;
z_cyl = Z * szFac;
z_cyl = z_cyl + Z_position;

handle_indenter = surf(x_cyl, y_cyl, z_cyl);
colormap('white');

if nargin == 0
    close all;
    handle_indenter = surf(x_cyl, y_cyl, z_cyl);
    colormap('white');
    axis off;
    axis equal;
    view(0,30);
end 

end