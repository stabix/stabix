% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [slip_vec, flag_error] = ...
    vector_calculations(grain, material, ...
    phase, euler, slip_syst, stress_tensor, flag_error)
%% Vector calculation for a given grain

% author: d.mercier@mpie.de

% Loop to set grain properties (identity, Euler angles, position)
for ig = grain
    lattice_parameters = latt_param(material, phase);  % Get the lattice parameter for the grain
    if lattice_parameters(1) == 0 || flag_error == 1
        warning_commwin('Wrong input for material and structure !!!');
        euler = 0;
        flag_error = 1;
    else
        flag_error = 0;
    end
    
    if flag_error == 0
        ss_cart = zeros(2,3,size(slip_syst, 3));
        ss_cart_norm = zeros(2,3,size(slip_syst, 3));
        if strcmp(phase, 'hcp') == 1
            for ss_ind = 1:size(slip_syst, 3)
                ss_cart(1,:,ss_ind) = millerbravaisplane2cart(...
                    slip_syst(1,:,ss_ind), lattice_parameters(1));
                ss_cart(2,:,ss_ind) = millerbravaisdir2cart(...
                    slip_syst(2,:,ss_ind), lattice_parameters(1));
                ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind) / ...
                    norm(ss_cart(1,:,ss_ind));
                ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind) / ...
                    norm(ss_cart(2,:,ss_ind));
            end
        else
            for ss_ind = 1:size(slip_syst, 3)
                ss_cart(1,:,ss_ind) = slip_syst(1,:,ss_ind);
                ss_cart(2,:,ss_ind) = slip_syst(2,:,ss_ind);
                ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind) / ...
                    norm(ss_cart(1,:,ss_ind));
                ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind) / ...
                    norm(ss_cart(2,:,ss_ind));
            end
        end
    end
end

if flag_error == 0
    if lattice_parameters(1) ~= 0
        % Preallocation
        slip_vec = zeros(size(slip_syst, 3), 15);
        g_mat    = zeros(3, 3, grain);
        
        for ig = grain
            g_mat(:,:,ig) = eulers2g(euler);
            
            for ii = 1:1:size(slip_syst, 3)
                slip_vec(ii,1:3) = g_mat(:,:,ig).'*ss_cart_norm(1,1:3,ii)';   % Plane normal (n vector normalized)
                slip_vec(ii,4:6) = g_mat(:,:,ig).'*ss_cart_norm(2,1:3,ii)';   % Slip direction (b vector normalized)
                slip_vec(ii,7:9) = g_mat(:,:,ig).'*ss_cart(2,1:3,ii)';        % Slip direction (b vector non normalized)
                slip_vec(ii,10:12) = g_mat(:,:,ig).'*-ss_cart(2,1:3,ii)';     % Slip direction (b vector non normalized and in the opposite direction)
                
                % Generalized Schmid Factor
                slip_vec(ii,13)   = generalized_schmid_factor(...
                    ss_cart_norm(1,:,ii), ss_cart_norm(2,:,ii), ...
                    stress_tensor.sigma, g_mat(:,:,ig));
                
                if isnan(slip_vec(ii,13))
                    slip_vec(ii,14) = 0;
                else
                    slip_vec(ii,14) = abs(slip_vec(ii,13));
                end
                
                % Resolved Shear Stress
                slip_vec(ii,15) = resolved_shear_stress(...
                    euler, ...
                    ss_cart_norm(2,:,ii), ...
                    ss_cart_norm(1,:,ii), ...
                    stress_tensor.sigma_n);
                if isnan(slip_vec(ii,15))
                    slip_vec(ii,16) = 0;
                else
                    slip_vec(ii,16) = abs(slip_vec(ii,15));
                end
                
                slip_vec(ii,17) = ii;                                         % Index of slip (number from 1 to 57 for hcp)
                
            end
        end
    end
end

end