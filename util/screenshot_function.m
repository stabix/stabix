% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: screenshot_function.m 1148 2014-07-10 14:55:45Z d.mercier $
function SCREENSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCREENSHOT_NUM, varargin)
%% Function to save screenshots of the Matlab window
% SCREENSHOT : Name of the screenshot
% SCREENSHOT_DIR : Path to the directory to save the screenshot
% SCREENSHOT_NUM : Number of the screenshot if sequential screenshots...

if nargin == 0
SCREENSHOT = strcat(date_time_string, 'screenshots');
SCREENSHOT_DIR = cd;
SCREENSHOT_NUM = 0;
end

if SCREENSHOT
    im = screencapture(gcf);
    imwrite(im, fullfile(SCREENSHOT_DIR,[SCREENSHOT, '_', num2str(SCREENSHOT_NUM), '.png']),'png');
end

SCREENSHOT_NUM = SCREENSHOT_NUM + 1;

end