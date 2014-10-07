% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = plotGB_Bicrystal_init
%% Initialization of preCPFE GUIs

% author: c.zambaldi@mpie.de

get_stabix_root;

%% Set the GUI
gui.config = load_YAML_config_file;
gui.config.username = get_username;

gui.version_str = num2str(gui.config.version_toolbox);
gui.module_name = 'Bicrystal GUI';

end