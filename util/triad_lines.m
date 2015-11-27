% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h_struct = triad_lines(sz, shiftXYZ, labels, interpreter, varargin)
%% Function used to plots triad lines
% sz: Size of the triad
% shiftXYZ: Position of the line

if nargin < 4
    %interpreter = 'none';
    interpreter = 'latex';
end
if nargin < 3
    %labels = {'RD','TD','ND'};
    labels = {'X','Y','Z'};
end
if nargin < 2
    shiftXYZ = [0,0,0];
end
if nargin < 1
    scale_factor = 0.25;
else
    scale_factor = sz;
end

shiftXYZ = [shiftXYZ(1); shiftXYZ(2); shiftXYZ(3)];

Xend=[1,0,0]';Yend=[0,1,0]';Zend=[0,0,1]';
%shiftXYZ=[0,0,10]';
Xstart = [0,0,0]'+shiftXYZ;
Ystart = [0,0,0]'+shiftXYZ;
Zstart = [0,0,0]'+shiftXYZ;

Xend = Xend*scale_factor+shiftXYZ;
Yend = Yend*scale_factor+shiftXYZ;
Zend = Zend*scale_factor+shiftXYZ;

XYZ(1) = plot3([Xstart(1),Xend(1)],[Xstart(2),Xend(2)], ...
    [Xstart(3),Xend(3)],'-k'); hold on;
XYZ(2) = plot3([Ystart(1),Yend(1)],[Ystart(2),Yend(2)], ...
    [Ystart(3),Yend(3)],'-k'); hold on;
XYZ(3) = plot3([Zstart(1),Zend(1)],[Zstart(2),Zend(2)], ...
    [Zstart(3),Zend(3)],'-k'); hold on;
set(XYZ,'LineWidth',1.6);

% Labels
Xpos = Xstart+(Xend-Xstart)*1.4;
Ypos = Xstart+(Yend-Ystart)*1.4;
Zpos = Xstart+(Zend-Zstart)*1.4;
XYZtxt(1) = text(Xpos(1),Xpos(2),Xpos(3),labels(1));
XYZtxt(2) = text(Ypos(1),Ypos(2),Ypos(3),labels(2));
[az,el] = view();

if abs(abs(el)-90)<1e-4
    labels(3) = {''}; % do not plot Z-label for top view
end

XYZtxt(3) = text(Zpos(1),Zpos(2),Zpos(3),labels(3));

set(XYZtxt, 'FontSize',floor(10+scale_factor*10), ...
    'HorizontalAlignment','center'); %,'Rotation',crang)

% Plots and graphics disappear if 'Latex' is used
% as an text interpreter for Matlab2014a...
config = get_config;
if config.matlab_version_year > 2014
    set(XYZtxt, 'Interpreter', interpreter);
else
    set(XYZtxt, 'Interpreter', 	'none');
end

% Create handle structure
h_struct = struct();
h_struct.txt = XYZtxt;
h_struct.lines = XYZ;

end