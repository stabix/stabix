% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function s = s_factor_opt(n1, d1, l1, n2, d2, l2, varargin)
%% Function used to calculate the geometric compatibility parameter, m',
% after Bieler et al. 2014 Current Opinion in Solid State and Mater. Sc. 18
% DOI ==> 10.1016/j.cossms.2014.05.003
%
% n1 = normal of first slip system
% d1 = Burgers vector of first slip system (= slip direction)
% n2 = normal of 2nd slip system
% d2 = Burgers vector of 2nd slip system (= slip direction)
% l1 = slip plane intersection with the grain boundary
% l2 = slip plane intersection with the grain boundary
%
% Bieler et al. (2014):
%     s = dot(n1,n2)*dot(d1,d2)*dot(l1,l2)
%     s = cos(\phi) * cos(\kappa) * cos(\theta)
% with
%     phi = angle between normals
%     kappa = angle between slip directions
%     theta = is the angle between the two slip plane intersections with the grain boundary
%
% author: d.mercier@mpie.de

if nargin == 0 % run test cases if called without arguments
    n1 = random_direction();
    d1 = orthogonal_vector(n1);
	l1 = orthogonal_vector(n1);
    n2 = random_direction();
    d2 = orthogonal_vector(n2);
    l2 = orthogonal_vector(n2);
    s1 = s_factor_opt(n1,d1,l1,n2,d2,l2)
    s2 = s_factor_opt(n2,d2,l2,n1,d1,l1)
    assert(s1 == s2);
    s = NaN;
    return
end

s = cosFromVectors(n1, n2) * cosFromVectors(d1, d2) * cosFromVectors(l1, l2);

end

%function test_mprime
%maybe use xUnit for testing in future