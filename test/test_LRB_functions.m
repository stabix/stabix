% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function test_LRB_functions(GB_number, varargin)
%% Function to check LRB functions
% GBnumber: Number of grain boundaries

% author: d.mercier@mpie.de

if nargin == 0
    GB_number = 5;
end

l1 = zeros(3, GB_number);
d1 = zeros(3, GB_number);
l2 = zeros(3, GB_number);
d2 = zeros(3, GB_number);
for ii = 1:GB_number
    d1(:, ii) = random_direction();
    l1(:, ii) = orthogonal_vector(d1(:, ii));
    d2(:, ii) = random_direction();
    l2(:, ii) = orthogonal_vector(d2(:, ii));
end

mprime_val = zeros(GB_number);
mprime_opt_val = zeros(GB_number);
for jj = 1:1:GB_number
    for kk = 1:1:GB_number
        mprime_val(jj,kk) = LRB_parameter(...
            l1(:,jj), d1(:,jj), ...
            l2(:,kk), d2(:,kk));
        mprime_opt_val(jj,kk) = LRB_parameter_opt(...
            l1(:,jj), d1(:,jj), ...
            l2(:,kk), d2(:,kk));
    end
end

mprime_opt_vect_val = LRB_parameter_opt_vectorized(l1', d1', l2', d2');

disp(mprime_val);
disp(mprime_opt_val);
disp(mprime_opt_vect_val);

Tol = 1e-15;
for jj = 1:GB_number
    for kk = 1:1:GB_number     
        assert(abs(mprime_val(jj,kk) - mprime_opt_val(jj,kk)) < Tol);
        assert(abs(mprime_val(jj,kk) - mprime_opt_vect_val(jj,kk)) < Tol);
        assert(abs(mprime_opt_val(jj,kk) - mprime_opt_vect_val(jj,kk)) < Tol);
    end
end
end