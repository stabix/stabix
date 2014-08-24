% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: open_file_browser.m 1204 2014-08-05 13:29:53Z d.mercier $
function open_file_browser(loc, varargin)
%% Function to open default file browser
% http://stackoverflow.com/questions/16808965/how-to-open-a-directory-in-the-default-file-manager-from-matlab
% loc : Location of the file to load/open

if nargin < 1
    loc = cd;
end

% Windows
if ispc
    C = evalc(['!explorer ' loc]);
    % Unix or derivative
elseif isunix
    % Mac
    if ismac
        C = evalc(['!open ' loc]);
        % Linux
    else
        fMs = {...
            'xdg-open'   % most generic one
            'gvfs-open'  % successor of gnome-open
            'gnome-open' % older gnome-based systems
            'kde-open'   % older KDE systems
            };
        C = '.';
        ii = 1;
        while ~isempty(C)
            C = evalc(['!' fMs{ii} ' ' loc]);
            ii = ii +1;
        end
    end
else
    error('Unrecognized operating system.');
end

if ~isempty(C)
    error(['Error while opening directory in default file manager.\n',...
        'The reported error was:\n%s'], C);
end

end
