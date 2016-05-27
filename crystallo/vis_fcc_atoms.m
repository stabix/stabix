% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function hPatch = vis_fcc_atoms(eulers, slip, shiftXYZ, szFac, plotAxes, fast, ...
    numph, line_width, varargin)
%% Visualization of a fcc unit cell in a given orientation
% eulers: Bunge Euler angles in degrees
% slip : slip to plot
% shiftXYZ: translate the cell
% szFac: sizeFactor multiplier
% plotAxes
% fast: do not change daspect or axis modes to gain performance
% numph : phase_number
% line_width
% authors: d.mercier@mpie.de/c.zambaldi@mpie.de
tabularasa;
if nargin < 8
    line_width = 2;
end
if nargin < 7
    numph = 0;
end
if nargin < 6
    fast = 0; % adjust axis in every plot, slows plotting down significantly
end
if nargin < 5
    plotAxes = 0;
end
if nargin < 4
    szFac = 0.5;
end
if nargin < 3
    shiftXYZ = [0 0 0];
end
if nargin < 2
    slip = 0;
    %randi([1,66]);
end
if nargin < 1
    eulers = [0,0,0];
end

g_glob = eulers2g(eulers)';

% Lattice constants (normalized value)
a = 1;

% Indexation counterclockwise
cub = [...
    -a/2   -a/2    -a/2; % bottom 1
    a/2   -a/2    -a/2; %2
    a/2    a/2    -a/2; %3
    -a/2    a/2    -a/2; %4
    -a/2   -a/2     a/2; %5
    a/2   -a/2     a/2; %6
    a/2    a/2     a/2; %7
    -a/2    a/2     a/2];%8

fcc = [...
    0   0    -a/2; % bottom 1
    0   0   a/2; %2
    0    a/2    0; %3
    0    -a/2   0; %4
    -a/2   0    0; %5
    a/2    0     0];%6

%% Rotate the lattice cell points
gg  = g_glob;
pts =(gg*cub');
pts = pts';
pts = cub;
pts = pts*szFac;
pts(:,1) = pts(:,1)+shiftXYZ(1);
pts(:,2) = pts(:,2)+shiftXYZ(2);
pts(:,3) = pts(:,3)+shiftXYZ(3);

pts2 = fcc;
pts2 = pts2*szFac;
pts2(:,1) = pts2(:,1)+shiftXYZ(1);
pts2(:,2) = pts2(:,2)+shiftXYZ(2);
pts2(:,3) = pts2(:,3)+shiftXYZ(3);

if ~fast
    axis;
    hold on;
end

%% definition and plotting of the planes
% planes
slip_planes1 = [2 4 5];
slip_planes2 = [2 4 7];
slip_planes3 = [4 5 7];
slip_planes4 = [2 5 7];
%-------------------------------------------------------------------------------------------------------------------------------------------
% twins
twins_planes1 = [2 4 5];
twins_planes2 = [2 4 7];
twins_planes3 = [4 5 7];
twins_planes4 = [2 5 7];
%-------------------------------------------------------------------------------------------------------------------------------------------
%% Patch definition
fAlph = 0.7; % Transparency

top = [1 2 3 4;
    5 6 7 8];

hTop = patch('Vertices',pts,'Faces',top);
set(hTop,'FaceColor','none','FaceAlpha',fAlph,'LineWidth',line_width);

faces = [1 2 6 5;
    2 3 7 6;
    3 4 8 7;
    4 1 5 8];

hFac = patch('Vertices',pts,'Faces',faces);
set(hFac,'FaceColor','none','FaceAlpha',fAlph,'LineWidth',line_width);

if numph == 0
    colorph = [0.8 0.8 0.8]; % grey
elseif numph == 1
    colorph = 'g';
elseif numph ==2
    colorph = 'r';
end

% Plot of unit cell
set([hTop, hFac],'FaceColor',colorph,'FaceAlpha',fAlph);

if  slip == 0
    hPatch = [hTop hFac];
else
    set([hTop, hFac],'FaceAlpha',fAlph*.8);
    % Slips
    if slip >= 1 && slip <= 3
        hslip = patch('Vertices',pts,'Faces',slip_planes1,...
            'FaceColor','b','FaceAlpha',fAlph);
    elseif slip >= 3 && slip <= 6
        hslip = patch('Vertices',pts,'Faces',slip_planes2,...
            'FaceColor','b','FaceAlpha',fAlph);
    elseif slip >= 7 && slip <= 9
        hslip = patch('Vertices',pts,'Faces',slip_planes3,...
            'FaceColor','b','FaceAlpha',fAlph);
    elseif slip >= 10 && slip <= 12
        hslip = patch('Vertices',pts,'Faces',slip_planes4,...
            'FaceColor','b','FaceAlpha',fAlph);
        
        % Twins
    elseif slip >= 13 && slip <= 15
        hslip = patch('Vertices',pts,'Faces',twins_planes1,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137]=Green forest
    elseif slip >= 16 && slip <= 18
        hslip = patch('Vertices',pts,'Faces',twins_planes2,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137]=Green forest
    elseif slip >= 19 && slip <= 21
        hslip = patch('Vertices',pts,'Faces',twins_planes3,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137]=Green forest
    elseif slip >= 22 && slip <= 24
        hslip = patch('Vertices',pts,'Faces',twins_planes4,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137]=Green forest
    end
    hPatch = [hTop hFac hslip];
end

if ~fast
    axis off;
    %axis tight;
    daspect([1 1 1]);
end

if plotAxes
    axis on;
end

% xyzlabel;
% axisticksoff;
% view([1 -1 .8])
% set(hPatch,'EdgeColor','w')
% axis equal
% rotate3d on

% Plot of atoms as spheres
hold on;
sphR = 0.05;

for ii = 1:length(pts)
    [x,y,z] = sphere(30);
    x = (x.*sphR)+pts(ii,1);
    y = (y.*sphR)+pts(ii,2);
    z = (z.*sphR)+pts(ii,3);
    surf(x,y,z);
    colormap([0 0 0; 0 0 0]);
    hold on;
end

for ii = 1:length(pts2)
    [x,y,z] = sphere(30);
    x = (x.*sphR)+pts2(ii,1);
    y = (y.*sphR)+pts2(ii,2);
    z = (z.*sphR)+pts2(ii,3);
    surf(x,y,z);
    colormap([0 0 0; 0 0 0]);
    hold on;
end

axis equal;
view([30 10]);

return