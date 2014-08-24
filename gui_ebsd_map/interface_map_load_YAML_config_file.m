% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: interface_map_load_YAML_config_file.m 1230 2014-08-14 11:37:09Z d.mercier $
function config_map = interface_map_load_YAML_config_file
%% Importation of data from YAML config file (samples, paths...)
% See in http://code.google.com/p/yamlmatlab/
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if ismac
    username = getenv('USER');
else
    username = getenv('USERNAME');
end

configYAML = sprintf('config_gui_EBSDmap_%s.yaml', username);

if ~exist(configYAML, 'file')
    errordlg_str = strcat('YAML config file not found for the user : ', username, ' ! Create your YAML config file and load it from the menu...');
    errordlg(errordlg_str, 'File Error');
    config_map.Sample_IDs   = 'Sample_A';
    config_map.Sample_ID    = 'Sample_A';
    config_map.Material_IDs = 'Material_A';
    config_map.Material_ID  = 'Material_A';
    config_map.default_grain_file_type2            = 'validation_grain_file_type2.txt';
    config_map.default_reconstructed_boundaries_file = 'validation_reconstructed_boundaries.txt';
    %     config_map.default_grain_file_type2 = 'random_GF2data.txt';
    %     config_map.default_reconstructed_boundaries_file = 'random_RBdata.txt';
else
    config_map = ReadYaml(configYAML);
end

%% Setting of EBSD results data (filenames of GF2 and RB files)
if ~isfield(config_map, 'default_grain_file_type2')
    config_map.default_grain_file_type2 = 'validation_grain_file_type2.txt';
end

if ~isfield(config_map, 'default_reconstructed_boundaries_file')
    config_map.default_reconstructed_boundaries_file = 'validation_reconstructed_boundaries.txt';
end

end
