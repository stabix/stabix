% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function hPatch = vis_hex(eulers, slip, shiftXYZ, szFac, plotAxes, fast, numph, line_width, varargin)
%% Visualization of an hexagonal unit cell in a given orientation
% eulers: Bunge Euler angles in degrees
% slip : slip to plot
% shiftXYZ: translate the cell
% szFac: sizeFactor multiplier
% plotAxes
% fast: do not change daspect or axis modes to gain performance
% numph : phase_number
% line_width
% authors: d.mercier@mpie.de/c.zambaldi@mpie.de

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
    eulers = randBunges;
end

g_glob = eulers2g(eulers)';

% Lattice constants (theoritical values)
a = 1;
c = 1.633;

% Indexation counterclockwise
hcp = [0           0         0; % bottom 1
    a           0         0; %2
    a*cosd(60)  a*sind(60)    0; %3
    -a*cosd(60)  a*sind(60)    0; %4
    -a           0         0; %5
    -a*cosd(60) -a*sind(60)    0; %6
    a*cosd(60) -a*sind(60)    0; %7
    a/2      a/3*sind(60)  c/2; % center 8
    -a/2      a/3*sind(60)  c/2; %9
    0      -2*a/3*sind(60) c/2; %10
    0            0         c; % top %11
    a            0         c; %12
    a*cosd(60)  a*sind(60)    c;%13
    -a*cosd(60)  a*sind(60)    c;%14
    -a            0         c; %15
    -a*cosd(60) -a*sind(60)    c;%16
    a*cosd(60) -a*sind(60)    c;%17
    0            0         3*c]; % 3*top %18

hcp(:,3) = hcp(:,3)-c/2;

% if nargin == 0
%     %clc
%     %newFigure
%     figure
%     for i = 1:size(hcp,1)
%         plot3(hcp(i,1),hcp(i,2),hcp(i,3),'+'),hold on;
%         text(hcp(i,1),hcp(i,2),hcp(i,3),sprintf('%i',i),'VerticalAlignment','bottom');
%         view([0 0 1]);
%     end
%     daspect111;
%     xyzlabel;
%     newFigure
% end
%% Rotate the lattice cell points
gg  = g_glob;
pts = (gg*hcp');
pts = pts';
pts = pts*szFac;
pts(:,1) = pts(:,1)+shiftXYZ(1);
pts(:,2) = pts(:,2)+shiftXYZ(2);
pts(:,3) = pts(:,3)+shiftXYZ(3);
if ~fast
    axis;
    hold on;
end
%% plot the axes a1,a2,a3,c
if plotAxes
    hax(1) = plot3([shiftXYZ(1)+pts(1,1) pts(2,1)],...
        [shiftXYZ(2)+pts(1,2) pts(2,2)],...
        [shiftXYZ(3)+pts(1,3) pts(2,3)],'Color','k');
    haxt(1) = text(pts(2,1),pts(2,2),pts(2,3),'   a_1');
    hax(2) = plot3([shiftXYZ(1)+pts(1,1) pts(4,1)],...
        [shiftXYZ(2)+pts(1,2) pts(4,2)],...
        [shiftXYZ(3)+pts(1,3) pts(4,3)],'Color','k');
    haxt(2) = text(pts(4,1),pts(4,2),pts(4,3),'   a_2');
    hax(3) = plot3([shiftXYZ(1)+pts(1,1) pts(6,1)],[shiftXYZ(2)+pts(1,2) pts(6,2)],[shiftXYZ(3)+pts(1,3) pts(6,3)],'Color','k');
    haxt(3) = text(pts(6,1),pts(6,2),pts(6,3),'a_3   ','HorizontalAlignment','right');
    hax(4) = plot3([shiftXYZ(1)+pts(1,1) pts(11,1)],...
        [shiftXYZ(2)+pts(1,2) pts(11,2)],...
        [shiftXYZ(3)+pts(1,3) pts(11,3)],'Color','k');
    haxt(4) = text(pts(11,1),pts(11,2),pts(11,3),'   c');
end
%% definition and plotting of the planes
% basal <a> - glide [Cd Be Zn Mg Re Ti Re] - {00.1} <11.0> - slips number : 1-3
basalfaces = [
    2 3 4 5 6 7;
    12 13 14 15 16 17];
%-------------------------------------------------------------------------------------------------------------------------------------------
% prisma1 <a> - glide [Ti Zr Re Be Re Mg] - 1st order - {10.0} <11.0> - slips number : 4-6
prisma1 = [
    3 13 14 4;
    2 12 13 3;
    4 14 15 5;
    6 16 17 7;
    5 15 16 6;
    7 17 12 2];

% prisma2 <a> - 2nd order - {11.0}<10.0> - slips number : 7-9
prisma2 = [
    6 4 14 16;
    5 3 13 15;
    7 5 15 17;
    3 7 17 13;
    2 6 16 12;
    4 2 12 14
    ];
%-------------------------------------------------------------------------------------------------------------------------------------------
% pyramidal <a> - glide [Mg Ti] - 1st order - {-11.1} <11.0> - slips number : 10-15
pyramidal_a = [
    6 7 11;
    2 3 11;
    4 5 11;
    7 2 11;
    3 4 11;
    5 6 11];

% pyramidal <c+a> - glide - 1st order - {-10.1} <11.3> - slips number : 16-27
pyramidal_ac = [
    4 5 11;4 5 11;
    2 3 11;2 3 11;
    6 7 11;6 7 11;
    7 2 11;7 2 11;
    5 6 11;5 6 11;
    3 4 11;3 4 11];

%  pyramidal <c+a> - glide - 2nd order - {-1-1.2} <11.3> - slips number : 28-33
pyramidal2_ac = [
    4 6 17 13;
    6 2 13 15;
    2 4 15 17;
    7 3 14 16;
    3 5 16 12;
    5 7 12 14];
%-------------------------------------------------------------------------------------------------------------------------------------------
% {10.2}<-10.1> T1 - Tension twins twshzr = 0.17; corr = -1.3; [all but compression for Zn and Cd] - Index : 34-39
twin1 = [
    4 5 17 12;
    2 3 15 16;
    6 7 13 14;
    7 2 14 15;
    5 6 12 13;
    3 4 16 17];
% {-1-1.1}<11.6> T2 - Tension twins: twshzr = 0.63;  corr = -0.4; [Ti Zr Re] - Index : 40-45
twin2 = [
    7 3 11;
    3 5 11;
    5 7 11;
    4 6 11;
    6 2 11;
    2 4 11;];
% {10.1}<10.-2> C1 - Compression twins: twshzr = 0.10; corr = 1.1; [Ti Zr Mg] - Index : 46-51
twin3 = [
    4 5 16 13;
    2 3 14 17;
    6 7 12 15;
    7 2 13 16;
    5 6 17 14;
    3 4 15 12];

% {11.2}<11.-3> C2 - Compression twins:; twshzr = 0.22; corr = 1.2; [Ti Zr] - Index : 52-57
twin4 = [
    7 3 14 16;
    3 5 16 12;
    5 7 12 14;
    4 6 17 13;
    6 2 13 15;
    2 4 15 17];

%-------------------------------------------------------------------------------------------------------------------------------------------
%% Patch definition
if ~fast
    daspect([1 1 1])
end

fAlph = 0.7;

hBas = patch('Vertices',pts,'Faces',basalfaces);
hPri = patch('Vertices',pts,'Faces',prisma1);

if numph ==  0
    colorph = [0.8 0.8 0.8]; % grey
elseif numph ==  1
    colorph = 'g';
elseif numph == 2
    colorph = 'r';
end

% Plot of unit cell
set([hPri, hBas],'FaceColor',colorph,'FaceAlpha',...
    fAlph,'LineWidth',line_width);

if  slip == 0
    hPatch = [hBas, hPri];
else
    set([hPri, hBas],'FaceColor',colorph,'FaceAlpha',...
        fAlph*.8,'LineWidth',line_width);
    %Basal <a>
    if slip >=  1 && slip <= 3
        hslip = patch('Vertices',pts,'Faces',basalfaces,...
            'FaceColor','b','FaceAlpha',fAlph);
        
        %Prismatic <a> - 1st order
    elseif slip >=  4 && slip <= 6
        index_slip = slip-3;
        prisma1 = [prisma1(index_slip,:);prisma1(index_slip+3,:)];
        hslip = patch('Vertices',pts,'Faces',prisma1,...
            'FaceColor','r','FaceAlpha',fAlph);
        
        %Prismatic <a> - 2nd order
    elseif slip >=  7 && slip <= 9
        index_slip = slip-6;
        prisma2 = [prisma2(index_slip,:);prisma2(index_slip+3,:)];
        hslip = patch('Vertices',pts,'Faces',prisma2,...
            'FaceColor',[1,0.412,0.706],'FaceAlpha',fAlph);%[0.137,0.545,0.137] = Hot Pink
        
        %Pyramidal 1st order <a>
    elseif slip >=  10 && slip <= 15
        index_slip = slip-9;
        pyramidal_a = pyramidal_a(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',pyramidal_a,...
            'FaceColor',[1,0.647,0],'FaceAlpha',fAlph);%[1,0.647,0] = orange
        
        %Pyramidal 1st order <c+a>
    elseif slip >=  16 && slip <= 27
        index_slip = slip-15;
        pyramidal_ac = pyramidal_ac(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',pyramidal_ac,...
            'FaceColor','y','FaceAlpha',fAlph);
        
        %Pyramidal 2nd order <c+a>
    elseif slip >=  28 && slip <= 33
        index_slip = slip-27;
        pyramidal2_ac = pyramidal2_ac(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',pyramidal2_ac,...
            'FaceColor',[0.678,1,0.184],'FaceAlpha',fAlph);%[1,0.647,0] = yellow-green
        
        %Twins
    elseif slip >=  34 && slip <= 39
        index_slip = slip-33;
        twin1 = twin1(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',twin1,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137] = Green forest
        
    elseif slip >=  40 && slip <= 45
        index_slip = slip-39;
        twin2 = twin2(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',twin2,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137] = Green forest
        
    elseif slip >=  46 && slip <= 51
        index_slip = slip-45;
        twin3 = twin3(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',twin3,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137] = Green forest
        
    elseif slip >=  52 && slip <= 57
        index_slip = slip-51;
        twin4 = twin4(index_slip,:);
        hslip = patch('Vertices',pts,'Faces',twin4,...
            'FaceColor',[0.137,0.545,0.137],'FaceAlpha',fAlph);% [0.137,0.545,0.137] = Green forest
    end
    hPatch = [hBas,hPri,hslip];
    
end

if ~fast
    axis off;
    axis tight;
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

return