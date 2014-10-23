% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function pos = figure_position(L_B_W_HoW)
%% Function to set position of the GUI
% lbwh : [left, bottom, width, height/width]
% pos : [left, bottom, width, height]

% author: c.zambaldi@mpie.de

scr = get(0);    % Get screen size  
scr.width = scr.ScreenSize(3);
scr.height = scr.ScreenSize(4);
WX = L_B_W_HoW(1) * scr.width;  % horiz X Position (left edge)
WY = L_B_W_HoW(2) * scr.height;  % vert Y Position (bottom edge)
WW = L_B_W_HoW(3) * scr.width;  % Width
WH = L_B_W_HoW(4) * WW;  % Height

while WH > scr.height * .9  || WW > scr.width * .9;
    WW = .9 * WW;  % Width
    WH = L_B_W_HoW(4) * WW;  % Height
end

WX = min([scr.width - WW, WX]);
WY = min([scr.height - WH - 100, WY]); % leave at least 100 px for menu bar

pos = [WX WY WW WH];

end