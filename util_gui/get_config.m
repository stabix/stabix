% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config = get_config
%% Function to set configuration of GUIs

% author: d.mercier@mpie.de

config = load_YAML_config_file;

if isfield(config, 'matlab_opengl')
    config.opengl = set_opengl(config.matlab_opengl);
else
    config.opengl = set_opengl;
end

config.username = username_get;
config.matlab_version = version('-release');
config.matlab_version_year = strread(config.matlab_version);

config.toolbox_version_str = num2str(config.toolbox_version);

end