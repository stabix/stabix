% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function XYZtxt = interface_map_plot_coordsys(CCM, scale_factor, shiftXYZ, varargin)
%% Function used to set the coordinates system for the map interface
% CCM : Coordinate Convention Matrix
% scale_factor : Scale factor
% shiftXYZ : Shift in x,y and z directions

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 3
    shiftXYZ = [0,0,0];
end
if nargin < 2
    scale_factor = 0.25;
end
if nargin < 1
    e1 = [1;0;0];
    e2 = [0;1;0];
    e3 = [0;0;1];
	CCM = [e1, e2, e3];
end

shiftXYZ = [shiftXYZ(1); shiftXYZ(2); shiftXYZ(3)];
labels = {'RD', 'TD', 'ND'};
%labels = {'X', 'Y', 'Z'};

Xend = [1,0,0]';
Yend = [0,1,0]';
Zend = [0,0,1]';

%Apply coordinate sytem for plotting
Xend = CCM * Xend;
Yend = CCM * Yend;
Zend = CCM * Zend;

%shiftXYZ=[0,0,10]';
Xstart = [0,0,0]' + shiftXYZ;
Ystart = [0,0,0]' + shiftXYZ;
Zstart = [0,0,0]' + shiftXYZ;

Xend = Xend * scale_factor + shiftXYZ;
Yend = Yend * scale_factor + shiftXYZ;
Zend = Zend * scale_factor + shiftXYZ;

%arrow3d(Xstart',Xend',20); hold on;
%arrow3d(Ystart',Yend',20); hold on;
%arrow3d(Zstart',Zend',20); hold on;

XYZ(1) = plot3([Xstart(1),Xend(1)], [Xstart(2),Xend(2)], [Xstart(3),Xend(3)], '-k'); hold on;
XYZ(2) = plot3([Ystart(1),Yend(1)], [Ystart(2),Yend(2)], [Ystart(3),Yend(3)], '-k'); hold on;
XYZ(3) = plot3([Zstart(1),Zend(1)], [Zstart(2),Zend(2)], [Zstart(3),Zend(3)], '-k'); hold on;
set(XYZ,'LineWidth',1.6);

% Labels
Xpos = Xstart + (Xend-Xstart) * 1.4;
Ypos = Xstart + (Yend-Ystart) * 1.4;
Zpos = Xstart + (Zend-Zstart) * 1.4;
XYZtxt(1) = text(Xpos(1), Xpos(2), Xpos(3), labels(1), 'HorizontalAlignment', 'center');%,'Rotation',crang)
XYZtxt(2) = text(Ypos(1), Ypos(2), Ypos(3), labels(2), 'HorizontalAlignment', 'center');%,'Rotation',crang)
[~,el] = view();

if abs(el) ~= 90
    XYZtxt(3) = text(Zpos(1), Zpos(2), Zpos(3), labels(3), 'HorizontalAlignment', 'center');%,'Rotation',crang)
end
set(XYZtxt, 'FontSize', floor(10));

end
