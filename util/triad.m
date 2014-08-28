% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h_trd = triad(sz, pos, col, dim, varargin)
%% Function used to plots triad
% sz: Size of the triad
% pos: Position of the center of the triad
% col: Color of the triad
% dim: Dimenstion of the triad

% Uses the function "arrow3D" in the ThirdPartCode folder

if nargin<1
    sz = .35;
end
if nargin<2
    pos = [0,0,0];
end
if nargin<3
    col = {'r', 'g', 'b'};
elseif length(col) == 1
    col = {col,col,col};
end

e1 = [1;0;0];
e2 = [0;1;0];
e3 = [0;0;1];
end1 = pos+e1'*sz;
end2 = pos+e2'*sz;
end3 = pos+e3'*sz;

if 1
    h1 = arrow3(pos+[0,0,0],end1,col{1});
    h2 = arrow3(pos+[0,0,0],end2,col{2});
    h3 = arrow3(pos+[0,0,0],end3,col{3});
else
    h1 = arrow3d(pos+[0,0,0],end1,20);
    h2 = arrow3d(pos+[0,0,0],end2,20);
    h3 = arrow3d(pos+[0,0,0],end3,20);
end

FszTr = 14;
htxt(1) = text(end1(1)+sz*.17,end1(2),end1(3),'X','FontSize',FszTr);
htxt(2) = text(end2(1),end2(2)+sz*.17,end2(3),'Y','FontSize',FszTr,...
    'HorizontalAlignment','center');
htxt(3) = text(end3(1)+sz*.25,end3(2)+sz*.25,end3(3)+sz*.2,'Z','FontSize',FszTr);

set(htxt,'HorizontalAlignment','center');
% if 1
%     delete(htxt);
% end
h_trd = [h1,h2,h3];

return
