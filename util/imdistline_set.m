% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h_dist = imdistline_set(x_pos, y_pos, color, label, varargin)
%% Function to set a line on the current axis
% x_pos: x coordinates of endpoints
% y_pos: y coordinates of endpoints
% color: Color of the line

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

% See: http://www.mathworks.fr/help/images/ref/imdistline.html

if nargin < 4
    label = 0;
end

if nargin < 3
    color = 'blue';
end

if nargin < 2
    y_pos = [300, 300];
end

if nargin < 1
    x_pos = [250, 450];
end

h_dist = imdistline(gca, x_pos, y_pos);
api    = iptgetapi(h_dist);
fcn    = makeConstrainToRectFcn('imline',...
    get(gca, 'XLim'),...
    get(gca, 'YLim'));

setLabelVisible(h_dist, label);
setColor(h_dist, color);

api.setDragConstraintFcn(fcn);

end