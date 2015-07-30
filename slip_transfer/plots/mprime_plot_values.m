% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: mprime_plot_values.m 1199 2014-08-05 09:46:20Z d.mercier $
function mprime_plot_values(color_map, varargin)
%% Function to plot the geometric compatibility parameter, m' in function of angles
% after Luster & Morris 1995 MetallMaterTrans 26A 1745-
% DOI ==> 10.1007/BF02670762
%
% Luster % Morris (1995):
%     m' = cos(\phi) * cos(\kappa)
% with
%     phi = angle between normals
%     kappa = angle between slip directions
%
% author: d.mercier@mpie.de

if nargin == 0
    color_map = 'hot';
end

phi = (0:1:180)';
A = cos(phi*pi/180);
kappa = 0:1:180;
B = cos(kappa*pi/180);
mprime = A*B;

figure(...
    'Name', 'mprime distribution',...
    'NumberTitle', 'off',...
    'PaperUnits', get(0,'defaultfigurePaperUnits'),...
    'Color', [0.9 0.9 0.9],...
    'Colormap', get(0,'defaultfigureColormap'));

try
    colormap(color_map);
catch err
    display(err);
    colormap('hot');
end

surf(phi, kappa, mprime, 'FaceColor', 'interp', 'EdgeColor','none');
axis tight; 
xlabel('Angle between normals (°)'); 
ylabel('Angle between directions (°)');
view(0,90); 
colorbar;

end
