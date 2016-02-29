% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function angle_from_cos = ang_from_vectors(v1, v2)
%% Return the angle in degress from the dot product between the 2 vectors (v1 and v2)

cosine = cosFromVectors(v1, v2);

angle_from_cos = acosd(cosine);

return