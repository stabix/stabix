% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function hPatch = vis_bcc_atoms(eulers, slip, shiftXYZ, szFac, plotAxes, fast, ...
    numph, line_width, varargin)
%% Visualization of a bcc unit cell in a given orientation
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
    fast=0; % adjust axis in every plot, slows plotting down significantly
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
    eulers = [0, 0, 0];
end

g_glob = eulers2g(eulers)';

% Lattice constants (normalized value)
a = 1;

% Indexation counterclockwise
cub = [-a/2   -a/2    -a/2; %1 (bottom)
    a/2   -a/2    -a/2; %2
    a/2    a/2    -a/2; %3
    -a/2    a/2    -a/2; %4
    -a/2   -a/2     a/2; %5 (top)
    a/2   -a/2     a/2; %6
    a/2    a/2     a/2; %7
    -a/2    a/2     a/2; %8
    
    0     -a/2    -a/2; %9=(1+2)/2
    a/2    0      -a/2; %10=(2+3)/2
    0      a/2    -a/2; %11=(3+4)/2
    -a/2    0      -a/2; %12=(4+1)/2
    0     -a/2     a/2; %13=(1+2)/2
    a/2    0       a/2; %14=(2+3)/2
    0      a/2     a/2; %15=(3+4)/2
    -a/2    0       a/2; %16=(4+1)/2
    -a/2   -a/2       0; %17=(1+5)/2
    a/2   -a/2       0; %18=(2+6)/2
    a/2    a/2       0; %19=(3+7)/2
    -a/2    a/2       0; %20=(4+8)/2
    
    -a/6   -a/2    -a/2;%21
    a/6   -a/2    -a/2;%22
    a/2   -a/6    -a/2;%23
    a/2    a/6    -a/2;%24
    a/6    a/2    -a/2;%25
    -a/6    a/2    -a/2;%26
    -a/2    a/6    -a/2;%27
    -a/2   -a/6    -a/2;%28
    -a/2   -a/2    -a/6;%29
    a/2   -a/2    -a/6;%30
    a/2    a/2    -a/6;%31
    -a/2    a/2    -a/6;%32
    -a/2   -a/2     a/6;%33
    a/2   -a/2     a/6;%34
    a/2    a/2     a/6;%35
    -a/2    a/2     a/6;%36
    -a/6   -a/2     a/2;%37
    a/6   -a/2     a/2;%38
    a/2   -a/6     a/2;%39
    a/2    a/6     a/2;%40
    a/6    a/2     a/2;%41
    -a/6    a/2     a/2;%42
    -a/2    a/6     a/2;%43
    -a/2   -a/6     a/2;%44
    ];

bcc = [...
    0 0 0;
    0 0 a;
    0 0 -a];

fcc = [...
    0   0    -a/2; % bottom 1
    0   0   a/2; %2
    0    a/2    0; %3
    0    -a/2   0; %4
    -a/2   0    0; %5
    a/2    0     0]; %6

tet = [...
    0 a/4 -a/2];

%% Rotate the lattice cell points
gg  = g_glob;
pts = (gg*cub');
pts = pts';
pts = pts*szFac;
pts(:,1) = pts(:,1) + shiftXYZ(1);
pts(:,2) = pts(:,2) + shiftXYZ(2);
pts(:,3) = pts(:,3) + shiftXYZ(3);

pts2 = bcc;
pts2 = pts2*szFac;
pts2(:,1) = pts2(:,1)+shiftXYZ(1);
pts2(:,2) = pts2(:,2)+shiftXYZ(2);
pts2(:,3) = pts2(:,3)+shiftXYZ(3);

pts3 = fcc;
pts3 = pts3*szFac;
pts3(:,1) = pts3(:,1)+shiftXYZ(1);
pts3(:,2) = pts3(:,2)+shiftXYZ(2);
pts3(:,3) = pts3(:,3)+shiftXYZ(3);

pts4 = tet;
pts4 = pts4*szFac;
pts4(:,1) = pts4(:,1)+shiftXYZ(1);
pts4(:,2) = pts4(:,2)+shiftXYZ(2);
pts4(:,3) = pts4(:,3)+shiftXYZ(3);

if ~fast
    axis;
    hold on;
end

%% definition and plotting of the planes

% planes
slip_planes1 = [
    3 4 5 6;3 4 5 6;% slips 1&2
    1 2 7 8;1 2 7 8;% slips 3&4
    2 3 8 5;2 3 8 5;% slips 5&6
    1 4 7 6;1 4 7 6;% slips 7&8
    2 4 8 6;2 4 8 6;% slips 9&10
    1 3 7 5;1 3 7 5];% slips 11&12

slip_planes2 = [
    9  4 5; %slips 13
    9  3 6; %slips 14
    1 11 8; %slips 15
    1 13 8; %slips 16
    2 12 5; %slips 17
    6 10 1; %slips 18
    3 12 8; %slips 19
    6 16 1; %slips 20
    2 17 4; %slips 21
    1 18 3; %slips 22
    1 20 3; %slips 23
    6 17 8]; %slips 24

slip_planes3 = [
    2 12 29; %slips 25
    1 10 30; %slips 26
    3 12 32; %slips 27
    6 16 33; %slips 28
    2 28 17; %slips 29
    1 23 18; %slips 30
    6 33 16; %slips 31
    6 44 17; %slips 32
    9  4 29; %slips 33
    9  3 30; %slips 34
    11  1 32; %slips 35
    13  8 33; %slips 36
    9 28  5; %slips 37
    9 23  6; %slips 38
    11 27  8; %slips 39
    13 44  1; %slips 40
    21  4 17; %slips 41
    9  3 18; %slips 42
    26  1 20; %slips 43
    37  8 17; %slips 44
    21 12  5; %slips 45
    22 10  6; %slips 46
    26 12  8; %slips 47
    37 16  1;]; %slips 48
%-------------------------------------------------------------------------------------------------------------------------------------------
% twins
twins_planes = [9  4 5;
    9  3 6;
    1 11 8;
    1 13 8;
    2 12 5;
    6 10 1;
    3 12 8;
    6 16 1;
    2 17 4;
    1 18 3;
    1 20 3;
    6 17 8;
    ];
%-------------------------------------------------------------------------------------------------------------------------------------------
%% Patch definition
fAlph = 0.7; % Transparency

top = [
    1 2 3 4;
    5 6 7 8];

hTop = patch('Vertices',pts,'Faces',top);

faces = [
    1 2 6 5;
    2 3 7 6;
    3 4 8 7;
    4 1 5 8];

hFac = patch('Vertices',pts,'Faces',faces);

if numph == 0
    colorph = [0.8 0.8 0.8]; % grey
elseif numph == 1
    colorph = 'g';
elseif numph == 2
    colorph = 'r';
end

% Plot of unit cell
set([hTop, hFac],'FaceColor',colorph,'FaceAlpha',...
    fAlph,'LineWidth',line_width);

if  slip == 0
    hPatch = [hTop hFac];
else
    set(hTop,'FaceColor',colorph,'FaceAlpha',...
        fAlph*.8,'LineWidth',line_width);
    set(hFac,'FaceColor',colorph,'FaceAlpha',...
        fAlph*.8,'LineWidth',line_width);
    % Slips
    if slip >= 1 && slip <= 12
        slip_planes1 = slip_planes1(slip,:);
        hslip = patch('Vertices',pts,'Faces',slip_planes1,...
            'FaceColor','b','FaceAlpha',fAlph);
        
    elseif slip >= 13 && slip <= 24
        slip_planes2 = slip_planes2(slip-12,:);
        hslip = patch('Vertices',pts,'Faces',slip_planes2,...
            'FaceColor','r','FaceAlpha',fAlph);
        
    elseif slip >= 25 && slip <= 48
        slip_planes3 = slip_planes3(slip-24,:);
        hslip = patch('Vertices',pts,'Faces',slip_planes3,...
            'FaceColor',[1,0.647,0],'FaceAlpha',fAlph);%[1,0.647,0]=orange
        
        % Twins
    elseif slip >= 49 && slip <= 60
        twins_planes = twins_planes(slip-48,:);
        hslip = patch('Vertices',pts,'Faces',twins_planes,...
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

%xyzlabel;
%axisticksoff;
%view([1 -1 .8])
%set(hPatch,'EdgeColor','w')
%axis equal
%rotate3d on

% Plot of atoms as spheres
hold on;
sphRAtom = 0.04;
sphRInst = 0.02;
colorAtom = 'k';
colorInstOct = 'r';
colorInstTet = 'b';

for ii = 1:8
    [x,y,z] = sphere(30);
    x = (x.*sphRAtom)+pts(ii,1);
    y = (y.*sphRAtom)+pts(ii,2);
    z = (z.*sphRAtom)+pts(ii,3);
    surf(x,y,z, 'FaceColor', colorAtom,'EdgeColor','none');
    hold on;
end

for ii = 1:size(bcc,1)
    [x,y,z] = sphere(30);
    x = (x.*sphRAtom)+pts2(ii,1);
    y = (y.*sphRAtom)+pts2(ii,2);
    z = (z.*sphRAtom)+pts2(ii,3);
    surf(x,y,z, 'FaceColor', colorAtom,'EdgeColor','none');
    hold on;
end

[x,y,z] = sphere(30);
x = (x.*sphRInst)+pts3(2,1);
y = (y.*sphRInst)+pts3(2,2);
z = (z.*sphRInst)+pts3(2,3);
OctSite = surf(x,y,z, 'FaceColor', colorInstOct,'EdgeColor','none');
hold on;

[x,y,z] = sphere(30);
x = (x.*sphRInst)+pts4(1,1);
y = (y.*sphRInst)+pts4(1,2);
z = (z.*sphRInst)+pts4(1,3);
TetSite = surf(x,y,z, 'FaceColor', colorInstTet,'EdgeColor','none');
hold on;

legend([OctSite, TetSite], 'Octahedral site', 'Tetrahedral site', ...
    'Location', 'SouthOutside');

axis equal;
view([100 15]);

facesOct = [45 5 6;
    45 6 7;
    45 7 8;
    45 8 5;
    46 5 6;
    46 6 7;
    46 7 8;
    46 8 5];

facesTet = [45 3 4;
    47 3 4;
    45 47 3;
    45 47 4];

% Plot of octohedral and tetragonal sites
hOct = patch('Vertices',[pts; pts2],'Faces',facesOct,...
    'FaceColor',colorInstOct,'FaceAlpha',fAlph/2);

hTet = patch('Vertices',[pts; pts2],'Faces',facesTet,...
    'FaceColor',colorInstTet,'FaceAlpha',fAlph/2);

return