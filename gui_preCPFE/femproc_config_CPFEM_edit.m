% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_config_CPFEM_edit()
%% Function to edit CPFEM configuration from YAML files.
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);
% ensure that user config file exists
% if not copy the default settings
% this is not ideal because any change in the default will be not reflected
% in the users config, since user settings overwrite default settings.
if ~exist(gui.config_CPFEM_user_full, 'file')
    % maybe replace by readyaml-writeyaml cycle?
    % this would allow to exclude some fieldnames from being changed
    % or do variable replacement for e.g. <usernames>
    copyfile(gui.config_CPFEM_full, gui.config_CPFEM_user_full);
else
    % check if user only uses valid fieldnames and values
    % that correspond to the current version
    femproc_confi_CPFEM_check_user_config();
end
edit(gui.config_CPFEM_user_full);

end