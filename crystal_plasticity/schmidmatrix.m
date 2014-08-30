% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function s = schmidmatrix(d, n, varargin)
%% Function used to calculate the Schmid matrix (d,n)
% d = direction
% n = normal
% author: c.zambaldi@mpie.de

if nargin == 0
    d = [1,1,1];
    n = [1,0,1];
end

s = zeros(3,3);

for ii = 1:3
    for jj = 1:3
        s(ii,jj) = s(ii,jj)+d(ii)*n(jj);
    end
end

end