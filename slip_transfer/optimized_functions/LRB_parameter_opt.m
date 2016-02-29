% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function LRB = LRB_parameter_opt(l1, d1, l2, d2, varargin)
%% Function used to calculate the geometric compatibility parameter, LRB,
% after Shen et al. (1986) Scripta Metallurgica, 20(6), pp. 921–926.
% DOI ==> 10.1016/0036-9748(86)90467-9
%
% l1 = slip plane intersection with the grain boundary
% d1 = Burgers vector of first slip system (= slip direction)
% l2 = slip plane intersection with the grain boundary
% d2 = Burgers vector of 2nd slip system (= slip direction)
%
% Shen et al. (1986):
%     LRB = dot(l1,l2)*dot(d1,d2) = cos(\kappa) * cos(\theta)
% with
%     kappa = angle between slip directions
%     theta = is the angle between the two slip plane intersections with the grain boundary
%
% author: d.mercier@mpie.de

if nargin == 0 % run test cases if called without arguments
    l1 = random_direction();
    d1 = orthogonal_vector(l1);
    l2 = random_direction();
    d2 = orthogonal_vector(l2);
    LRB_test = LRB_parameter_opt(l1,d1,l2,d2)
    LRB = NaN;
    return
end

LRB = cosFromVectors(l1, l2) * cosFromVectors(d1, d2);

end