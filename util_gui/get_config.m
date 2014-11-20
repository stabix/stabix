% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config = get_config
%% Function to set configuration of GUIs

% author: d.mercier@mpie.de

config = load_YAML_config_file;
config.username = username_get;
config.matlab_version = version('-release');

config.toolbox_version_str = num2str(config.toolbox_version);

end