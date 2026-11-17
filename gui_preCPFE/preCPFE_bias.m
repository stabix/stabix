% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function biased_elem = ...
    preCPFE_bias(fem_software, x0, xN, num_elements, bias)
%% Function used to select bais function to use (Mentat or Abaqus)
% fem_software: mentat or abaqus
% x0: First point
% xn: End point
% num_elements: Number of intervals
% bias: Bias
% biased_elem: Seed points for biased elements

% author: d.mercier@mpie.de

if strcmp(strtok(fem_software, '_'), 'Abaqus') == 1
    ensure_bias_helper('abaqus', 'abaqus_bias');
    % 0 is used for Mentat and 1 for Abaqus, when no bias is applied to the mesh.
    if bias == 0
        bias = 1;
    end
    biased_elem = abaqus_bias(x0, xN, num_elements, bias);
    
elseif strcmp(strtok(fem_software, '_'), 'Mentat') == 1
    ensure_bias_helper('marc_mentat', 'mentat_bias');
    biased_elem = mentat_bias(x0, xN, num_elements, bias);
else
    error('STABiX:UnsupportedMeshSolver', ...
        'Unsupported mesh-bias solver: %s.', fem_software);
end

end

function ensure_bias_helper(directory, name)
helper_directory = fullfile(fileparts(mfilename('fullpath')), directory);
helper_file = fullfile(helper_directory, [name, '.m']);
if exist(helper_file, 'file') ~= 2
    error('STABiX:MissingMeshBiasHelper', ...
        ['The bundled mesh helper is missing: %s. Upload the complete ' ...
        'gui_preCPFE folder, including its solver subfolders.'], helper_file);
end
if ~strcmp(which(name), helper_file)
    addpath(helper_directory, '-begin');
end
end