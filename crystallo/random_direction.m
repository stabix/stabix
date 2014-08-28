% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function vec = random_direction()
%% Return random direction (vector)

vec = rand(3,1);
vec = vec ./ norm(vec);

return