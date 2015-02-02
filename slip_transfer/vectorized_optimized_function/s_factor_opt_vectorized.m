% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function s = s_factor_opt_vectorized(n1, d1, l1, n2, d2, l2, varargin)
%% Function used to calculate the geometric compatibility parameter, m',
% after Bieler et al. 2014 Current Opinion in Solid State and Mater. Sc. 18
% DOI ==> 10.1016/j.cossms.2014.05.003
%
% n1 = N-vector for normal of first slip system
% d1 = N-vector for Burgers vector of first slip system (= slip direction)
% n2 = N-vector for normal of 2nd slip system
% d2 = N-vector for Burgers vector of 2nd slip system (= slip direction)
% l1 = N-vector for slip plane intersection with the grain boundary
% l2 = N-vector for slip plane intersection with the grain boundary
% N = Number of slip system
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
    for ii = 1:5
        d1(ii,:) = random_direction();
        n1(ii,:) = perpendicular_vector(d1(ii,:));
        l1(ii,:) = perpendicular_vector(d1(ii,:));
        d2(ii,:) = random_direction();
        n2(ii,:) = perpendicular_vector(d2(ii,:));
        l2(ii,:) = perpendicular_vector(d2(ii,:));
    end
    s1 = s_factor_opt_vectorized(n1,d1,l1,n2,d2,l2)
    s2 = s_factor_opt_vectorized(n2,d2,l2,n1,d1,l1)
    %assert(s1 == s2)
    s = s_factor_opt_vectorized(n1,d1,l1,n2,d2,l2);
    commandwindow;
    return
end

s = (n1 * n2') .* (d1 * d2') .* (l1 * l2');

end