% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: screenSize.m 978 2014-05-26 14:57:32Z d.mercier $
function scSz = screenSize()
% Returns screensize in pixels
% See also:
% http://www.mathworks.com/matlabcentral/fileexchange/10957-get-screen-size
% -dynamic
scSz = get(0, 'ScreenSize');

return