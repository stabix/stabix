% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function close_windows(window_name, varargin)
%% Function used to close Matlab windows
% window_name : Name or handle of the window

if nargin == 0
    delete(findall(0,'Type','figure'));
    com.mathworks.mlservices.MatlabDesktopServices.getDesktop.closeGroup('Web Browser')
else
    close(window_name);
end

end