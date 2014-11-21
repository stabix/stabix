% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function hstruct = plot_slip_plane(slip_normal, slip_direction, shiftXYZ, radius, color, varargin)
%% Returns the plot of a choosen slip by plotting the corresponding plane
% slip_normal : slip normal (vector normal to the slip plane)
% slip_direction : slip direction (Burgers vector)
% shiftXYZ : shift to apply to the slip plane
% radius : slip plane plotted as a circle with a given radius
% color : color of the slip plane

% author: c.zambaldi@mpie.de

if nargin < 5
    color = 'k';
end
if nargin < 4
    radius = 1;
end
if nargin < 3
    shiftXYZ = [0,0,0];
end
if nargin < 1
    commandwindow;
    warning('Testing')
    %close all
    slip_normal = rand(1,3);
    slip_normal = slip_normal./norm(slip_normal);
    slip_direction = orthogonal_vector(slip_normal);
end
shiftXYZ = [shiftXYZ(1), shiftXYZ(2), shiftXYZ(3)];
%slip_normal = slip_normal./norm(slip_normal);

hPlane = plotCircle3D(slip_normal, shiftXYZ, radius);
hold on;
plot3(shiftXYZ(1), shiftXYZ(2), shiftXYZ(3),'.k','MarkerSize',10);
if nargin > 1 || nargin == 0
    if strfind(version('-release'), '2014')
        hArr = plot3([shiftXYZ(1) shiftXYZ(1)+slip_direction(1)*radius], ...
            [shiftXYZ(2) shiftXYZ(2)+slip_direction(2)*radius], ...
            [shiftXYZ(3) shiftXYZ(3)+slip_direction(3)*radius], ...
            'Color', color, 'LineWidth', 4);
        warning('Arrow not display for Matlab R2014b...');
    else
        hArr = arrow(shiftXYZ, shiftXYZ+slip_direction*radius,...
            'FaceColor', color, 'Length', 5, 'TipAngle', 45);
    end
end

hstruct = struct();
hstruct.plane = hPlane;
hstruct.arrow = hArr;
axis off;
axis tight;

end