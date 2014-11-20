% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = plotGB_Bicrystal_init
%% Initialization of Bicrystal GUI

% author: c.zambaldi@mpie.de

get_stabix_root;

gui.config = get_config;

gui.module_name = 'Bicrystal GUI';
gui.description = 'Analysis of Slip Transmission in a Bicrystal -';

end