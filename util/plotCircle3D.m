% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function hPatch = plotCircle3D(normale, center, radius, varargin)
% normale: Normale to the circle plane
% center: Position of the center of the circle
% radius: Radius of the circle

% author: c.zambaldi@mpie.de

if nargin < 3
    radius = 1;
end
if nargin < 2
    center = [0,0,0];
end

if nargin < 1
    warning('Testing');
    center = rand(1,3);
    normale = rand(1,3);
    normale = normale/norm(normale);
    radius = rand + 1;
    close all
end

normale = normale./norm(normale);
    
theta = 0:0.01:2*pi;
%theta=linspace(0,2*pi,100)';%:0.01:2*pi;
v = null(normale);
%center
points = repmat(center',1,size(theta,2)) + ...
    radius*(v(:,1)*cos(theta)+v(:,2)*sin(theta));
%hCirc = plot3(points(1,:), points(2,:), points(3,:), 'r-');
hPatch = patch(points(1,:), points(2,:), points(3,:), 'k-', ...
    'LineWidth', 1.5, 'FaceAlpha', .1);
axis equal
%rotate3d on

end