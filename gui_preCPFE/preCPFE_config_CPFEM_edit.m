% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_config_CPFEM_edit()
%% Function to edit CPFEM configuration from YAML files.
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);
% check if user config file exists
% if not copy the default settings
% this is not ideal because any change in the default will be not reflected
% in the users config, since user settings overwrite default settings.
gui.config.CPFEM.config_file_defaults_full
[pathstr, name, ext] = fileparts(gui.config.CPFEM.config_file_user_full);

if ~ exist(gui.config.CPFEM.config_file_user_full, 'file')
    [pathstr, name, ext] = fileparts(gui.config.CPFEM.config_file_user_full);
    if ~ isdir(pathstr)
        mkdir(pathstr);
    end
    % maybe replace by readyaml-writeyaml cycle?
    % this would allow to exclude some fieldnames from being changed
    % or do variable replacement for e.g. <usernames>
    copyfile(gui.config.CPFEM.config_file_defaults_full, ...
        gui.config.CPFEM.config_file_user_full, 'f');
    assert(exist(gui.config.CPFEM.config_file_user_full, 'file') == 2);
end
edit(gui.config.CPFEM.config_file_user_full);
end