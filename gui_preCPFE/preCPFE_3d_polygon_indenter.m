% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [ptc, handle_indax] = preCPFE_3d_polygon_indenter(N, ang, height, zShift, varargin)
%% Function to plot a 3D polygon indenter
% N: Number of sides of the polygon (e.g.: N = 3 ==> three-sided indenter,
% N = 4 ==> four-sided indenter).
% ang: Opening angle between vertical axis and faces (in degrees).
% height: Height of the indenter.
% zShift: Shift of the indenter along z-axis.

% See A.C. Fischer-Cripps "Nanoindentation" - Springer 2nd Ed. (2004)
% Berkovich indenter = three-sided pyramid and angle = 65.3°
% Cube-corner indenter = three-sided pyramid and angle = 35.26°
% Vickers indenter = four-sided pyramid and angle = 68°

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin < 4
    zShift = 0;
end

if nargin < 3
    height = 1;
end

if nargin < 2
    ang = 65.3; % Berkovich indenter
end

if nargin < 1
    N = 3; % Berkovich indenter
end

deg_inc = 360/N;

vts(1,:) = [0,0,0];
sz = tand(ang) / cosd(deg_inc/2);

for iN = 1:N+2
    vts(iN+1, :) = [cosd(iN * deg_inc) * sz, ...
        sind(iN * deg_inc) * sz, 1] * height;
    if iN > 2
        fcs(iN-2, :) = [1 iN-1 iN];
    end
end

vts(:,3) = vts(:,3) + zShift;

ptc = struct();
ptc.vertices = vts;
ptc.faces = fcs;
handle_indax = patch(ptc, 'FaceColor', 'w', 'FaceAlpha', 0.75);

if nargin == 0
    close all;
    patch(ptc, 'FaceColor', 'w', 'FaceAlpha', 0.75);
    rotate3d on;
    axis off;
    axis equal;
    view(0,0);
end

end