% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function msc_module_path = femproc_get_msc_module_path
%% Function used to get the "msc module" path
% author: d.mercier@mpie.de

msc_module_path = fullfile(get_stabix_root, 'third_party_code', 'python', 'msc');


end