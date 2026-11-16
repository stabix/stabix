function chi = chi_factor(n1, d1, n2, d2, n_gb)
%% Function used to calculate the geometric slip transfer factor, chi,
% after Jimenez et al. (2019) Scripta Materialia 162, pp. 261-265
% DOI ==> 10.1016/j.scriptamat.2018.11.014
% and Beyerlein et al. (2012) JOM 64(10), pp. 1192-1207.
%
% n1   = normal of the incoming slip plane
% d1   = slip direction of the incoming slip system
% n2   = normal of the outgoing slip plane
% d2   = slip direction of the outgoing slip system
% n_gb = normal of the grain boundary plane
% (all vectors expressed in the same reference frame)
%
%     chi = cos(alpha) * cos(delta)
% with
%     alpha = twist angle, angle between the traces of the two slip planes
%             on the grain boundary plane (trace_i = n_i x n_gb)
%     delta = angle between the incoming and outgoing slip directions
%
% Both angles are taken in [0, 90] deg (bidirectional slip), so chi is in [0, 1].
% To get the best outgoing system of a plane, maximize chi over its slip directions.

if nargin == 0 % run test cases if called without arguments
    n1 = [1 1 1]; d1 = [0 1 -1];
    assert(abs(chi_factor(n1, d1, n1, d1, [1 0 0]) - 1) < 1e-12);
    assert(abs(chi_factor(n1, d1, [1 -1 1], [1 0 -1], [1 0 0])) <= 1);
    chi = NaN;
    return
end

test_vectors_orthogonality(n1, d1);
test_vectors_orthogonality(n2, d2);

t1 = cross(n1(:)', n_gb(:)');
t2 = cross(n2(:)', n_gb(:)');

chi = abs(cosFromVectors(t1, t2)) * abs(cosFromVectors(d1, d2));

end
