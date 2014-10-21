% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config = load_YAML_config_file
%% Importation of data from YAML config file (Matlab settings)
% See in http://code.google.com/p/yamlmatlab/
% author : d.mercier@mpie.de

configYAML = sprintf('config.yaml');

if exist(configYAML, 'file') == 2
    config = ReadYaml(configYAML);
else
    warndlg('Missing YAML configuration file for Matlab...', 'Warning');
    warning('Missing YAML configuration file for Matlab...');
end

%% Setting of OpenGL
if isfield(config, 'matlab_opengl')
    if strcmp(config.matlab_opengl, 'software') && ~ismac  % see: "doc opengl"
        opengl software;
        
    elseif strcmp(config.matlab_opengl, 'hardware')
        opengl hardware;
        
    elseif strcmp(config.matlab_opengl, 'autoselect')
        opengl autoselect;
        
    end
    
elseif ~ismac
    opengl software;
    
end

end