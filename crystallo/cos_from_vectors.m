% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function cosine = cos_from_vectors(v1, v2)
%% Return dot product between the 2 vectors (v1 and v2)
% Function used in the functions for slip transmission (N-factor 
% from Livingston and Chamlers, M from Shen and m' from Luster and Morris)

assert(numel(v1) == 3);
assert(numel(v2) == 3);

% normalize the input vectors
v1 = v1 ./ norm(v1);
v2 = v2 ./ norm(v2);

cosine = dot(v1, v2);

return