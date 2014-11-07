% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function biased_elem = preCPFE_bias(fem_software, x0, xN, num_elements, bias)
%% Function used to select bais function to use (Mentat or Abaqus)
% fem_software: mentat or abaqus
% x0: First point
% xn: End point
% num_elements: Number of intervals
% bias: Bias
% biased_elem: Seed points for biased elements

% author: d.mercier@mpie.de

if strcmp(strtok(fem_software, '_'), 'Abaqus') == 1
    biased_elem = abaqus_bias(x0, xN, num_elements, bias);
    
elseif strcmp(strtok(fem_software, '_'), 'Mentat') == 1
    biased_elem = mentat_bias(x0, xN, num_elements, bias);
end

end