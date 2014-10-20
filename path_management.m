% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function path_management(varargin)
%% Set Matlab search path
% http://www.mathworks.de/de/help/matlab/ref/addpath.html
commandwindow;
% http://stackoverflow.com/questions/2720140/find-location-of-current-m-file-in-matlab
S = dbstack('-completenames');
[folder, name, ext] = fileparts(S(1).file);
display (folder);

if nargin > 0 && ischar(varargin{1})
    answer = varargin{1};
else
    answer = input('Add the above folder with subfolders to the MATLAB search path ?\n ([y](default)/n/rm(remove))','s');
end

path_to_add = genpath(folder);
% TODO: gemove everything under .git/...
% this will be much easier with strsplit, available from matlab2013a (8.1)
path_cell = regexp(path_to_add, pathsep, 'split');
%try
path_cell_genpath = path_cell;
path_cell = cellstr_filter(path_cell, {'.git'});
filtered_entries = numel(path_cell_genpath) - numel(path_cell)

n_dirs = numel(path_cell);

path_to_add = cell2path(path_cell);

if strcmpi(answer, 'y') || isempty(answer)
    display(sprintf('Adding %i entries to matlab search path', n_dirs));
    addpath(path_to_add);
    %rmpath(path_to_ignore)
    %savepath;
    setenv('SLIP_TRANSFER_TBX_ROOT', folder)
elseif strcmpi(answer, 'rm')
    display(sprintf('Removing %i entries from matlab search path', n_dirs));
    rmpath(path_to_add);
    setenv('SLIP_TRANSFER_TBX_ROOT', '') % delete environment variable, TODO: works on Linux?
else
    display 'doing nothing';
end

%% Optionally display the matlab search path after modifications with the 'path' command
%path
end