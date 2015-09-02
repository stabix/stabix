% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config = load_YAML_config_file
%% Importation of data from YAML config file (Matlab settings)
% See in http://code.google.com/p/yamlmatlab/

% author : d.mercier@mpie.de

configYAML = 'config.yaml';

if exist(configYAML, 'file') == 2
    config = ReadYaml(configYAML);
else
    warning_commwin('Missing YAML configuration file for Matlab...');
end

end