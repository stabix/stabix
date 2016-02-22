% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function mp = mprime(n1, d1, n2, d2, varargin)
%% Function used to calculate the geometric compatibility parameter, m',
% after Luster & Morris 1995 MetallMaterTrans 26A 1745-1476
% DOI ==> 10.1007/BF02670762
%
% n1 = normal of first slip system
% d1 = Burgers vector of first slip system (= slip direction)
% n2 = normal of 2nd slip system
% d2 = Burgers vector of 2nd slip system (= slip direction)
%
% Luster and Morris (1995):
%     m' = dot(n1,n2)*dot(d1,d2) = cos(\phi) * cos(\kappa)
% with
%     phi = angle between normals
%     kappa = angle between slip directions
%
% author: c.zambaldi@mpie.de

if nargin == 0 % run test cases if called without arguments
    n1 = random_direction();
    d1 = orthogonal_vector(n1);
    n2 = random_direction();
    d2 = orthogonal_vector(n2);
    m1 = mprime(n1,d1,n2,d2)
    m2 = mprime(n2,d2,n1,d1)
    assert(m1 == m2);
    mp = NaN;
    return
end

test_vectors_orthogonality(n1, d1);
test_vectors_orthogonality(n2, d2);

% abs is introduced to get the maximum value of m' because of the bidirectionnality of the slip
% but for the twins the sense of the slip direction has to be taken into account
mp = cos_from_vectors(n1, n2) * cos_from_vectors(d1, d2);
mp = abs(mp); % dealing with bidirectional slip here

end

%function test_mprime
%maybe use xUnit for testing in future