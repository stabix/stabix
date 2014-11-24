% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function nw = pixelwidth2normalizedwidth(pw)
%% Normalized a width in pixels
% pw: width in pixels
% nw: normalized width

scr = get(0);    % Get screen size  
scr.width = scr.ScreenSize(3);

nw = pw / scr.width;

end