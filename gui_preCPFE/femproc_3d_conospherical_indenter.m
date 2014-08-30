% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_3d_conospherical_indenter(tipRadius, coneAngle, N, X_position, Y_position, Z_position, varargin)
%% Function to plot a 3D conospherical indenter
% tipRadius : Radius of the spherical part of the indenter.
% coneAngle : Full angle in degree of the conical part of the indenter.
% N : Quality of the spherical part of the indenter (e.g. = quality = 50)
% X_position, Y_position, Z_position : Coordinates of the center of the
% spherical part of the indenter.

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 6
    Z_position = 1;
end

if nargin < 5
    Y_position = 1;
end

if nargin < 4
    X_position = 1;
end

if nargin < 3
    N = 50;
end

if nargin < 2
    coneAngle = 90;
end

if nargin < 1
    tipRadius = 1;
end

%% Calculation of the transition depth between the conical and spherical part of the indenter
h_trans = femproc_indentation_transition_depth(tipRadius,coneAngle/2);
h_trans = round(h_trans*100)/100;

%% Plot of the spherical part of the indenter
[x_hs, y_hs, z_hs] = sphere(N);
x_hs = (tipRadius * x_hs) + X_position;
y_hs = (tipRadius * y_hs) + Y_position;
z_hs = (tipRadius * z_hs) + Z_position;
if (Z_position - tipRadius) > 0
    z_hs(find(z_hs >= 1.2*(h_trans + Z_position - tipRadius))) = NaN;
elseif (Z_position - tipRadius) < 0
    z_hs(find(z_hs >= 0.8*(h_trans + Z_position - tipRadius))) = NaN;
elseif (Z_position - tipRadius) == 0
    z_hs(find(z_hs >= 1.05*(h_trans + Z_position - tipRadius))) = NaN;
end
surf(x_hs, y_hs, z_hs, 'Facecolor', 'w'); hold on;

%% Plot of the conical part of the indenter
ang = 0:0.04:2 * pi;
calRadius = (tipRadius^2 - (tipRadius - h_trans)^2)^0.5;
dz = 0;
deltaR = 0.05 * calRadius;
for ii = 1:1:25
    x(ii,:) = (calRadius * cos(ang)) + X_position;
    y(ii,:) = (calRadius * sin(ang)) + Y_position;
    z(ii) = (Z_position - tipRadius + h_trans + dz);
    dz = dz + (deltaR * tand(90-coneAngle/2));
    calRadius = calRadius + deltaR;
end
z = z.';
for ii = 2:1:size(x,2)
    z(:,ii) = z(:,1);
end
surf(x,y,z); hold on;
colormap white;

return
