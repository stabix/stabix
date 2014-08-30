% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function open_file_web(path_file, varargin)
%% Function to open a picture or an html file in a browser
% path_file : path of the file to open
% default software is used to open the file (e.g. Internet Explorer for
% .html file or VLC for a .avi file...)

if nargin < 1
    if ismac || isunix
        path_file = '.././README_Matlab.html/';
    else
        path_file = '..\.\README_Matlab.html';
    end
end

[pathstr, name, ext] = fileparts(mfilename('fullpath'));
web(fullfile(pathstr, path_file));

end
