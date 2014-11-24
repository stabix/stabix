% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [handle_indenter, ptc] = preCPFE_3d_polygon_indenter(...
    N, ang, height, zShift, varargin)
%% Function to plot a 3D polygon indenter
% N: Number of sides of the polygon (e.g.: N = 3 ==> three-sided indenter,
% N = 4 ==> four-sided indenter). N > 2

% ang: Opening angle between vertical axis and faces (in degrees).
% 0° < ang < 90°

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

if N < 2
   warning_commwin('N should be higher than 2 !');
end

if ang <=0 || ang >=90
   warning_commwin('ang should be comprised between 0° and 90° ! ');
end
    
deg_inc = 360/N;

vts(1,:) = [0,0,0];
sz = tand(ang) / cosd(deg_inc/2);

fcs = zeros(N+1, 4);
for iN = 1:N+1
    vts(iN+1, :) = [cosd(iN * deg_inc) * sz, ...
        sind(iN * deg_inc) * sz, 1] * height;
        fcs(iN, :) = [1 iN iN+1 1];
end

% FIXME: faces with 4 vertices are needed with 2 times the same vertice
% because only rectangular elements can be converted in surfaces in Mentat.

% for iF = 1:N
%     sNd = (iF-1)*2+2
%     vts(sNd, :) = [cosd((sNd-1) * deg_inc) * sz, ...
%                    sind((sNd-1) * deg_inc) * sz, ...
%                    1] * height;
%     vts(sNd+1, :) = [cosd(sNd * deg_inc) * sz, ...
%                      sind(sNd * deg_inc) * sz, ...
%                      1] * height;
%     
%     %if iN > 2
%     fcs(iF, :) = [1 sNd sNd+1 1];
%     %end
% end

vts(:,3) = vts(:,3) + zShift;

ptc = struct();
ptc.vertices = vts;
ptc.faces = fcs;
handle_indenter = patch(ptc, 'FaceColor', 'w', 'FaceAlpha', 0.75);

if nargin == 0
    close all;
    handle_indenter = patch(ptc, 'FaceColor', 'w', 'FaceAlpha', 0.75);
    rotate3d on;
    axis off;
    axis equal;
    view(20,10);
end

end