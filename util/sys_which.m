% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function locations = sys_which(cmd_str)
%% Locate executables outside of Matlab
% uses
% - "which" for linux
% - "where" for windows
%
% cmd_str: string of command to look for
%
% not tested for MACs
%
% author: c.zambaldi@mpie.de

if isunix || ismac
    evalc_str = sprintf('system(''which -a %s'');', cmd_str);
    locs = strtrim(evalc(evalc_str));
    locations = regexp(locs, '\n', 'split');
end

if ispc
    evalc_str = sprintf('system(''where %s'');', cmd_str);
    locs = strtrim(evalc(evalc_str));
    locations = regexp(locs, '\n', 'split');
    for ii = 1:numel(locations)
        loc = strtrim(locations(ii));
        locations(1) = loc;
    end
end

end