% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function rbv_norm = ...
    residual_Burgers_vector_opt(rotated_b_in, rotated_b_out, varargin)
%% Vectorized calculation of residual Burgers vector norms
% 
% Optimized version for calculating the norm of multiple residual Burgers vectors
% from Marcinkowski et al. => Metallurgical Transactions 1,12 (1970) pp 3397-3401
% from Lee T.C. et al. - Scripta Metall. 23,799 (1989)
% and de Koning et al. - Journal of Nuclear Materials 323 (2003) pp 281–289
%
% This function is vectorized to handle multiple Burgers vector pairs at once.
%
% INPUTS:
%   rotated_b_in  = incoming Burgers vectors, shape (3, n_pairs) or (3, 1)
%   rotated_b_out = outgoing Burgers vectors, shape (3, n_pairs) or (3, 1)
%
% OUTPUT:
%   rbv_norm = norm(s) of residual Burgers vector(s), shape (1, n_pairs)
%
% rbv = R_in'*b_in' - R_out'*b_out'
%
% author: d.mercier@mpie.de
% optimized: 2026

if nargin == 0
    % Test case
    b_in  = rand(3, 5);  % 5 test vectors
    b_out = rand(3, 5);
    eul_in = randBunges(5, 1);
    eul_out = randBunges(5, 1);
    R_in  = eulers2g(eul_in);
    R_out = eulers2g(eul_out);
    rotated_b_in = R_in' * b_in;
    rotated_b_out = R_out' * b_out;
    disp(b_in);
    disp(b_out);
    
elseif nargin < 2
    disp('Not enough inputs');
    return
end

try
    % Ensure inputs are column vectors or matrices
    if size(rotated_b_in, 1) ~= 3
        rotated_b_in = rotated_b_in';
    end
    if size(rotated_b_out, 1) ~= 3
        rotated_b_out = rotated_b_out';
    end
    
    % Compute dot product between all input and output vectors
    % Shape: (1, n_pairs) if single pairs, scalar if one pair
    dot_product = sum(rotated_b_in .* rotated_b_out, 1);
    
    % Vectorized conditional: add or subtract based on sign of dot product
    % If dot_product > 0: rbv = rotated_b_in - rotated_b_out
    % If dot_product <= 0: rbv = rotated_b_in + rotated_b_out
    sign_mask = dot_product > 0;
    
    % Initialize result with size matching input
    n_pairs = size(rotated_b_in, 2);
    rbv = zeros(3, n_pairs);
    
    % Apply conditional logic vectorized
    if any(sign_mask)
        rbv(:, sign_mask) = rotated_b_in(:, sign_mask) - rotated_b_out(:, sign_mask);
    end
    if any(~sign_mask)
        rbv(:, ~sign_mask) = rotated_b_in(:, ~sign_mask) + rotated_b_out(:, ~sign_mask);
    end
    
    % Compute norms vectorized: sqrt(sum of squares along rows)
    rbv_norm = sqrt(sum(rbv .* rbv, 1));
    
    % If single input, return scalar
    if n_pairs == 1
        rbv_norm = rbv_norm(1);
    end
    
catch err
    commandwindow;
    disp(strcat(err.message, ' Or missing function eulers2g...'));
end

end
