% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function scSz = screenSize()
% Returns screensize in pixels
% See also:
% http://www.mathworks.com/matlabcentral/fileexchange/10957-get-screen-size
% -dynamic
scSz = get(0, 'ScreenSize');

return