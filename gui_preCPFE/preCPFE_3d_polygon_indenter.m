% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [handle_indenter, ptc] = preCPFE_3d_polygon_indenter(...
    N, ang, height, zShift, tipRadius, varargin)
%% Function to plot a 3D polygon indenter
% N: Number of sides of the polygon (e.g.: N = 3 ==> three-sided indenter,
% N = 4 ==> four-sided indenter). N > 2

% ang: Opening angle between vertical axis and faces (in degrees).
% 0° < ang < 90°

% height: Height of the indenter.
% zShift: Shift of the indenter along z-axis.
% tipRadius: Radius used to round the pyramidal tip. Zero keeps it sharp.

% See A.C. Fischer-Cripps "Nanoindentation" - Springer 2nd Ed. (2004)
% Berkovich indenter = three-sided pyramid and angle = 65.3°
% Cube-corner indenter = three-sided pyramid and angle = 35.26°
% Vickers indenter = four-sided pyramid and angle = 68°

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin < 4
    zShift = 0;
end

if nargin < 5
    tipRadius = 0;
end

if ~isnumeric(tipRadius) || ~isscalar(tipRadius) || ...
        ~isreal(tipRadius) || ~isfinite(tipRadius) || tipRadius < 0
    error('preCPFE_3d_polygon_indenter:InvalidTipRadius', ...
        'The pyramidal tip radius must be a finite, nonnegative scalar.');
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

sz = tand(ang) / cosd(deg_inc/2);

vts = zeros(N+1, 3);
vts(1,:) = [0,0,0];
fcs = zeros(N, 3);
for iN = 1:N
    vts(iN+1, :) = [cosd(iN * deg_inc) * sz, ...
        sind(iN * deg_inc) * sz, 1] * height;
    fcs(iN, :) = [1, iN+1, mod(iN, N)+2];
end

vts(:,3) = vts(:,3) + zShift;

ptc = struct();
if tipRadius == 0
    ptc.vertices = vts;
    ptc.faces = fcs;
else
    pyramidVertices = vts;
    pyramidVertices(:,3) = pyramidVertices(:,3) + tipRadius;
    sphereCenter = pyramidVertices(1,:);
    % The convex hull blends a sampled sphere into the pyramid apex.
    sphereVertices = sample_sphere(tipRadius, 800) + sphereCenter;
    points = unique([pyramidVertices; sphereVertices], 'rows');
    faces = convhulln(points);
    usedVertices = unique(faces(:));
    vertexMap = zeros(size(points, 1), 1);
    vertexMap(usedVertices) = (1:numel(usedVertices))';
    ptc.vertices = points(usedVertices, :);
    ptc.faces = vertexMap(faces);
end
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

function vertices = sample_sphere(radius, sampleCount)
index = (0:sampleCount-1)';
z = 1 - 2*(index + 0.5)/sampleCount;
angle = pi*(3 - sqrt(5))*index;
radial = sqrt(1 - z.^2);
directions = [radial .* cos(angle), radial .* sin(angle), z];
directions = [directions; 0 0 -1; 0 0 1];
vertices = radius * directions;
end