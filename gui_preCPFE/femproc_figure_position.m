% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function pos = femproc_figure_position(lbwh)
%% Function to set position of the GUI
% lbwh : [left, bottom, width, height/width]
% pos : [left, bottom, width, height]

% author: c.zambaldi@mpie.de

scr = get(0);    % Get screen size  
scr.width = scr.ScreenSize(3);
scr.height = scr.ScreenSize(4);
WX = lbwh(1) * scr.width;  % horiz X Position
WY = lbwh(2) * scr.height;  % vert Y Position
WW = lbwh(3) * scr.width;  % Width
WH = lbwh(4) * WW;  % Height

while WH > scr.height * .9  || WW > scr.width * .9;
    WW = .9 * WW;  % Width
    WH = lbwh(4) * WW;  % Height
end

WX = min([scr.width - WW, WX]);
WY = min([scr.height - WH - 100, WY]); % leave at least 100 px for menu bar

pos = [WX WY WW WH];

end