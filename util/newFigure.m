% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: newFigure.m 1142 2014-07-09 17:06:07Z d.mercier $
function h = newFigure(currentPosition, figWidth, maxWidth, varargin)
%% Function to create a new figure
% currentPosition : Position where to create the new figure
% figWidth : Width of the new figure
% maxWidth : Maximum width

scSz = screenSize();
spacingX = 5;
spacingY = 70;

if nargin < 3
    maxWidth = scSz(3);
end

if nargin < 2
    perRow = 3;
    figWidth = floor((maxWidth-(spacingX*perRow-1))/perRow);
    %figWidth = floor(maxWidth/(maxWidth/figWidth+spacingX*perRow));
    figHeight = figWidth;
end

if nargin < 1
    currFig = get(0,'CurrentFigure');
    if ~isempty(currFig)
        currentPosition = get(currFig,'position');
    else
        currentPosition = [0  scSz(4)-figHeight-spacingY  figWidth  figHeight];
    end
end

if ~isempty(currFig)
    figPos = currentPosition+[currentPosition(3)+spacingX 0 0 0];
else
    figPos = currentPosition;
end

if figPos(1)+spacingX+figWidth > maxWidth
    figPos = [0 figPos(2)-figHeight-spacingY figWidth figHeight];
end

if figPos(2)-figHeight <- figHeight % at lower bottom
    figPos = [0 scSz(4)-figHeight-spacingY figWidth figHeight]; % start again from top
end

h = figure('position', figPos);
figure(gcf);

return