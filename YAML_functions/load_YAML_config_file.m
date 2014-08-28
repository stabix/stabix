% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config_Matlab = load_YAML_config_file
%% Importation of data from YAML config file (Matlab settings)
% See in http://code.google.com/p/yamlmatlab/
% author : d.mercier@mpie.de

if ismac
    username = getenv('USER');
else
    username = getenv('USERNAME');
end

configYAML = sprintf('config_Matlab_%s.yaml', username);

if exist(configYAML, 'file') == 0
    config_Matlab.matlab_opengl = 'autoselect';
else
    config_Matlab = ReadYaml(configYAML);
end

%% Setting of OpenGL
if isfield(config_Matlab, 'matlab_opengl')
    if strcmp(config_Matlab.matlab_opengl, 'software') && ~ismac  % see: "doc opengl"
        opengl software;
        
    elseif strcmp(config_Matlab.matlab_opengl, 'hardware')
        opengl hardware;
        
    elseif strcmp(config_Matlab.matlab_opengl, 'autoselect')
        opengl autoselect;
        
    end
    
elseif ~ismac
    opengl software;
    
end

config_Matlab.username = username;

end