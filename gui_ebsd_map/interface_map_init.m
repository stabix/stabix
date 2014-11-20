% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = interface_map_init
%% Initialization of interface map GUIs

% author: c.zambaldi@mpie.de

get_stabix_root;

gui.config = get_config;

gui.module_name = 'EBSD map GUI';
gui.description = 'Analysis of Slip Transmission for an EBSD map - ';

end