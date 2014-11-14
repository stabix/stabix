% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config_map = interface_map_load_YAML_config_file
%% Importation of data from YAML config file (samples, paths...)
% See in http://code.google.com/p/yamlmatlab/
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

username = username_get;
    
configYAML = sprintf('config_gui_EBSDmap_%s.yaml', username);

if ~exist(configYAML, 'file')
    warning_str = ...
        strcat('YAML config file not found for the user : ', ...
        username, ...
        ' ! Create your YAML config file and load it from the menu...');
    warning(warning_str);
    config_map = ReadYaml('config_gui_EBSDmap_defaults.yaml');
    config_map.default_grain_file_type2              ...
        = 'validation_grain_file_type2.txt';
    config_map.default_reconstructed_boundaries_file ...
        = 'validation_reconstructed_boundaries.txt';
else
    config_map = ReadYaml(configYAML);
end

%% Setting of EBSD results data (filenames of GF2 and RB files)
if ~isfield(config_map, 'default_grain_file_type2')
    config_map.default_grain_file_type2 ...
        = 'validation_grain_file_type2.txt';
end

if ~isfield(config_map, 'default_reconstructed_boundaries_file')
    config_map.default_reconstructed_boundaries_file ...
        = 'validation_reconstructed_boundaries.txt';
end

end