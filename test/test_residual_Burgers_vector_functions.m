% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function test_residual_Burgers_vector_functions(GB_number, varargin)
%% Function to check residual Burgers vector functions
% GBnumber: Number of grain boundaries

% author: d.mercier@mpie.de

if nargin == 0
    GB_number = 1;
end

b_in = zeros(3, 3, GB_number);
b_out = zeros(3, 3, GB_number);
eul_in = zeros(3, GB_number);
eul_out = zeros(3, GB_number);
for ii = 1:GB_number
    b_in(:, 1, ii) = random_direction();
    b_out(:, 1, ii) = random_direction();
    eul_in(:, ii)  = randBunges;
    eul_out(:, ii) = randBunges;
end
display(b_in);
display(b_out);
display(eul_in);
display(eul_out);

rbv_val = zeros(GB_number);
for jj = 1:1:GB_number
    for kk = 1:1:GB_number
        rbv_val(jj,kk) = residual_Burgers_vector(...
            b_in(:,1,jj)', b_out(:,1,kk)', ...
            eul_in(:,jj)', eul_out(:,kk)');
    end
end

rbv_vect_val = residual_Burgers_vector_vectorized(...
    b_in, b_out, eul_in, eul_out);

display(rbv_val);
display(rbv_vect_val);

Tol = 1e-15;
for jj = 1:GB_number
    for kk = 1:1:GB_number
        commandwindow;
        assert(abs(rbv_val(jj,kk) - rbv_vect_val(jj,kk)) < Tol);
    end
end
end