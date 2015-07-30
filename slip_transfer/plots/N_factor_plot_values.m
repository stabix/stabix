% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: N_factor_plot_values.m 1279 2014-08-28 12:25:08Z d.mercier $
function n_fact = N_factor_plot_values(color_map, varargin)
%% Function to plot the geometric compatibility parameter, N-factor in function of angles
% after Livingston, J.D. and Chalmers, B. - Acta Metall. (1957) 5, 322.
% "Multiple slip in bicrystal deformation"  / DOI ==> 10.1016/0001-6160(57)90044-5
%
% n1 = normal of first slip system
% d1 = slip direction / Burgers vector of first slip system
% n2 = normal of 2nd slip system
% d2 = slip direction / Burgers vector of 2nd slip system
%
%     N_factor = [(n1.n2)(d1.d2) + (n1.d2)(n2.d1)]
%     N_factor = cos(phi)*cos(kappa) + cos(gamma)*cos(delta)
%
% author: d.mercier@mpie.de

if nargin == 0
    color_map = 'hot';
end

phi = (0:1:180)';
A = cos(phi*pi/180);
kappa = 0:1:180;
B = cos(kappa*pi/180);

gamma = (0:1:180)';
C = cos(gamma*pi/180);
delta = 0:1:180;
D = cos(delta*pi/180);

n_fact = A*B + C*D;

figure(...
    'Name', 'N_factor distribution',...
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

surf(phi, kappa, n_fact, 'FaceColor', 'interp', 'EdgeColor','none');
axis tight; 
xlabel('Angle between normals (°)'); 
ylabel('Angle between directions (°)');
view(0,90); 
colorbar;

end