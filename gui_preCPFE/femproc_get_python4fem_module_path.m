% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function python4fem_module_path = femproc_get_python4fem_module_path
%% Function used to get the "python4fem module" path
% author: d.mercier@mpie.de

% FIXME ==> not the same paths in GitHub and MWN2 repos
python4fem_module_path = fullfile(get_stabix_root, 'third_party_code', 'python');

%python4fem_module_path = fullfile(fileparts(get_stabix_root), 'python'); % Only for MWN2 repo

end