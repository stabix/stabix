% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function mp = mprime_opt_vectorized(n1, d1, n2, d2, varargin)
%% Function used to calculate the geometric compatibility parameter, m',
% after Luster & Morris 1995 MetallMaterTrans 26A 1745-1476
% DOI ==> 10.1007/BF02670762
%
% n1 = N-vector for normal of first slip system
% d1 = N-vector for Burgers vector of first slip system (= slip direction)
% n2 = N-vector for normal of 2nd slip system
% d2 = N-vector for Burgers vector of 2nd slip system (= slip direction)
% N = Number of slip system
%
% Luster % Morris (1995):
%     m' = dot(n1,n2)*dot(d1,d2) = cos(\phi) * cos(\kappa)
% with
%     phi = angle between normals
%     kappa = angle between slip directions
%
% author: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0 % run test cases if called without arguments
    for ii = 1:5
        d1(ii,:) = random_direction();
        n1(ii,:) = perpendicular_vector(d1(ii,:));
        d2(ii,:) = random_direction();
        n2(ii,:) = perpendicular_vector(n2(ii,:));
    end
    m1 = mprime_opt_vectorized(n1,d1,n2,d2)
    m2 = mprime_opt_vectorized(n2,d2,n1,d1)
    %assert(m1 == m2)
    mp = mprime_opt_vectorized(n1,d1,n2,d2);
    commandwindow;
    return
end

% abs is introduced to get the maximum value of m' because of the bidirectionnality of the slip
% but for the twins the sense of the slip direction has to be taken into account

mp = (n1 * n2') .* (d1 * d2');

mp = abs(mp); % dealing with bidirectional slip here

end