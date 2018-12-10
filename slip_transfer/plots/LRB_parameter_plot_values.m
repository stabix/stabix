% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: LRB_parameter_plot_values.m 1279 2014-08-28 12:25:08Z d.mercier $
function LRB_parameter_plot_values(color_map, varargin)
%% Function used plot the geometric compatibility parameter, LRB in function of angles
% after Shen et al. (1986) Scripta Metallurgica, 20(6), pp. 921–926.
% DOI ==> 10.1016/0036-9748(86)90467-9
%
% l1 = slip plane intersection with the grain boundary
% d1 = Burgers vector of first slip system (= slip direction)
% l2 = slip plane intersection with the grain boundary
% d2 = Burgers vector of 2nd slip system (= slip direction)
%
% Shen et al. (1986):
%     LRB = dot(l1,l2)*dot(d1,d2) = cos(\kappa) * cos(\theta)
% with
%     kappa = angle between slip directions
%     theta = is the angle between the two slip plane intersections with the grain boundary
%
% author: d.mercier@mpie.de

if nargin == 0
    color_map = 'hot';
end

kappa = (0:1:180)';
A = cos(kappa*pi/180);
theta = 0:1:180;
B = cos(theta*pi/180);
LRB = A*B;

figure(...
    'Name', 'LRB distribution',...
    'NumberTitle', 'off',...
    'PaperUnits', get(0,'defaultfigurePaperUnits'),...
    'Color', [0.9 0.9 0.9],...
    'Colormap', get(0,'defaultfigureColormap'));

try
    colormap(color_map);
catch err
    disp(err);
    colormap('hot');
end

surf(kappa, theta, LRB, 'FaceColor', 'interp', 'EdgeColor','none');
axis tight; 
xlabel('Angle between directions (°)'); 
ylabel('Angle between slip plane intersections and GB (°)');
view(0,90); 
colorbar;

return
