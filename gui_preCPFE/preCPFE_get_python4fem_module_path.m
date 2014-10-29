% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function python4fem_module_path = preCPFE_get_python4fem_module_path
%% Function used to get the "python4fem module" path
% author: d.mercier@mpie.de

python4fem_module_path = fullfile(get_stabix_root, 'third_party_code', 'python');

end