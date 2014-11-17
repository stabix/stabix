% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function test_N_factor_functions(GB_number, varargin)
%% Function to check N_factor functions
% GBnumber: Number of grain boundaries

% author: d.mercier@mpie.de

if nargin == 0
    GB_number = 5;
end

n1 = zeros(3, GB_number);
d1 = zeros(3, GB_number);
n2 = zeros(3, GB_number);
d2 = zeros(3, GB_number);
for ii = 1:GB_number
    n1(:, ii) = random_direction();
    d1(:, ii) = perpendicular_vector(n1(:, ii));
    n2(:, ii) = random_direction();
    d2(:, ii) = perpendicular_vector(n2(:, ii));
end

N_factor_val = zeros(GB_number);
N_factor_opt_val = zeros(GB_number);
for jj = 1:1:GB_number
    for kk = 1:1:GB_number
        N_factor_val(jj,kk) = N_factor(...
            n1(:,jj), d1(:,jj), ...
            n2(:,kk), d2(:,kk));
        N_factor_opt_val(jj,kk) = N_factor_opt(...
            n1(:,jj), d1(:,jj), ...
            n2(:,kk), d2(:,kk));
    end
end

N_factor_opt_vect_val = N_factor_opt_vectorized(n1', d1', n2', d2');

display(N_factor_val);
display(N_factor_opt_val);
display(N_factor_opt_vect_val);

Tol = 1e-15;
for jj = 1:GB_number
    for kk = 1:1:GB_number
        assert(abs(N_factor_val(jj,kk) - N_factor_opt_val(jj,kk)) < Tol);
        assert(abs(N_factor_val(jj,kk) - N_factor_opt_vect_val(jj,kk)) < Tol);
        assert(abs(N_factor_opt_val(jj,kk) - N_factor_opt_vect_val(jj,kk)) < Tol);
    end
end
end