% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function rbv_norm = residual_Burgers_vector_vectorized(b_in, b_out, eul_in, eul_out, varargin)
%% Function used to calculate the norm of the residual Burgers vector
% from Marcinkowski et al. ==> Metallurgical Transactions 1,12 (1970) pp 3397-3401
% DOI ==> DOI 10.1007/BF03037870

% from Lee T.C. et al. - Scripta Metall. 23,799 (1989).
% DOI ==> 10.1080/01418619008244340
%
% and de Koning et al. - Journal of Nuclear Materials 323 (2003) pp 281–289
% DOI ==> 10.1016/j.jnucmat.2003.08.008
%
% b1 = Burgers vector of first slip system in grain 1
% b2 = Burgers vector of 2nd slip system in grain 2
%
%     br = b_in - R.b_out
% with
%     b_in  = the Burgers vector of the incident slip dislocation
%     b_out = Burgers vector of the transmitted slip dislocation
%     R = rotation matrix that characterizes the misorientation across the GB
%
% Modified equation to be in the labs coordinate system :
%
%     rbv = R_in'*b_in' - R_out'*b_out'
%
% with
%     b_in  = Burgers vector of the incident slip dislocation
%     b_out = Burgers vector of the transmitted slip dislocation
%     R_in  = rotation matrix to set the incident slip dislocation
%     R_out = rotation matrix to set the transmitted slip dislocation
%
% author: d.mercier@mpie.de

if nargin == 0
    GB_number = 5;
    b_in = zeros(3, 3, GB_number);
    b_out = zeros(3, 3 ,GB_number);
    eul_in = zeros(3, GB_number);
    eul_out = zeros(3, GB_number);
    for ii = 1:GB_number
        b_in(:, 1, ii) = random_direction();
        b_out(:, 1, ii) = random_direction();
        eul_in(:, ii)  = randBunges;
        eul_out(:, ii) = randBunges;
    end
    
elseif nargin < 4
    display('Not enough inputs');
    return
end

R_in = zeros(3, 3, size(b_in, 3));
R_out = zeros(3, 3, size(b_out, 3));
for ii = 1:size(b_in, 3)
    R_in(:, :, ii)  = eulers2g(eul_in(:, ii));
    R_in(:, :, ii) = R_in(:, :, ii)';
    R_out(:, :, ii) = eulers2g(eul_out(:, ii));
    R_out(:, :, ii) = R_out(:, :, ii)';
end

try
%% FIXME: Error with .* for rot_b_in
    rot_b_in = R_in .* b_in;
    rot_b_in = rot_b_in(:,1,:);
    rot_b_out = R_out .* b_out;
    rot_b_out = rot_b_out(:,1,:);
    
    rbv_norm = zeros(size(b_in, 3), size(b_in, 3));
    for ii = 1:size(b_in, 3)
        for jj = 1:size(b_in, 3)
            rbv = rot_b_in(:,:,ii) - rot_b_out(:,:,jj);
            rbv_norm(ii,jj) = norm(rbv);
        end
    end
catch err
    commandwindow;
    display(strcat(err.message, ' Or missing function eulers2g...'));
end

end