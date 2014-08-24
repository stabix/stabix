% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function path_management
%% Set Matlab search path
% http://www.mathworks.de/de/help/matlab/ref/addpath.html
commandwindow;
% http://stackoverflow.com/questions/2720140/find-location-of-current-m-file-in-matlab
S = dbstack('-completenames');
[folder, name, ext] = fileparts(S(1).file);
display (folder);
answer = input('Add the above folder with subfolders to the MATLAB search path ?\n ([y](default)/n/rm(remove))','s');
path_to_add = genpath(folder);

if strcmpi(answer, 'y') || isempty(answer)
    display 'adding it';
    addpath(path_to_add);
    %rmpath(path_to_ignore)
    %savepath;
    setenv('SLIP_TRANSFER_TBX_ROOT', folder)
elseif strcmpi(answer, 'rm')
    display 'removing it';
    rmpath(path_to_add);
    setenv('SLIP_TRANSFER_TBX_ROOT', '')
else
    display 'doing nothing';
end

%% Optionally display the matlab search path after modifications with the 'path' command
%path
