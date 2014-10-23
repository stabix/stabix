% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function path_management(varargin)
%% Set Matlab search path
% http://www.mathworks.de/de/help/matlab/ref/addpath.html
commandwindow;
% http://stackoverflow.com/questions/2720140/find-location-of-current-m-file-in-matlab
S = dbstack('-completenames');
[folder, name, ext] = fileparts(S(1).file);
display(folder)

if nargin > 0 && ischar(varargin{1})
    answer = varargin{1};
else
    display('Add the above folder with subfolders to the MATLAB search path?')
    answer = input('([y](default)/n/rm(remove))','s');
end

path_to_add = genpath(folder);

% Add path for 'util' folder to use 'cells_filter', 'cell2path' and
% 'path2cell' functions
addpath(fullfile(folder, 'util'));

path_cell = path2cell(path_to_add);
% Do not put version control metadata on the search path
path_cell_filtered = cellstr_filter(path_cell, {'.git'});

n_dirs = numel(path_cell_filtered);
%n_filtered_entries = numel(path_cell) - n_dirs;

path_to_add = cell2path(path_cell_filtered);

if strcmpi(answer, 'y') || isempty(answer)
    fprintf('Adding %i entries to matlab search path\n', n_dirs);
    addpath(path_to_add);
    %savepath;
    setenv('SLIP_TRANSFER_TBX_ROOT', folder)
elseif strcmpi(answer, 'rm')
    fprintf('Removing %i entries from matlab search path\n', n_dirs);
    rmpath(path_to_add);
    % delete environment variable, TODO: works on Linux?
    setenv('SLIP_TRANSFER_TBX_ROOT', '') 
else
    display('doing nothing');
end

%% Optionally display the matlab search path after modifications with the 'path' command
%path
end
