% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function n_fact = N_factor_opt_vectorized(n1, d1, n2, d2, varargin)
%% Function used to calculate the N factor from Livingston and Chamlers
% after Livingston, J.D. and Chalmers, B. - Acta Metall. (1957) 5, 322.
% "Multiple slip in bicrystal deformation"  / DOI ==> 10.1016/0001-6160(57)90044-5
%
% n1 = normal of first slip system
% d1 = slip direction / Burgers vector of first slip system
% n2 = normal of 2nd slip system
% d2 = slip direction / Burgers vector of 2nd slip system
%
%     N_factor = [(n1.n2)(d1.d2) + (n1.d2)(n2.d1)]
%
%     NB : (dot(n1,n2))*(dot(b1,b2))) = mprime
%
% author: d.mercier@mpie.de

if nargin == 0 % run test cases if called without arguments
    for ii = 1:5
        n1(ii,:) = random_direction();
        d1(ii,:) = perpendicular_vector(n1(ii,:));
        n2(ii,:) = random_direction();
        d2(ii,:) = perpendicular_vector(n2(ii,:));
    end
    n_factor = N_factor_opt_vectorized(n1,d1,n2,d2)
    n_fact = NaN;
    return
end

%check_vectors_orthogonality(n1, d1);
%check_vectors_orthogonality(n2, d2);

N1 = ((n1 * n2') .* (d1 * d2')');
N2 = ((n1 * d2') .* (n2 * d1')');

n_fact = N1 + N2;

end