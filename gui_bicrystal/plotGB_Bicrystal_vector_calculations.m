function [vect, euler, sortbv] = plotGB_Bicrystal_vector_calculations(listslip, grain, material, phase, euler_ori, handle_euler, stress_tensor, flag_error)
%% Vector calculation for a given grain

% Loop to set grain properties (identity, Euler angles, position)
for ig = grain
    lattice_parameters = latt_param(material, phase);  % Get the lattice parameter for the grain
    if lattice_parameters(1) == 0
        % errordlg('Wrong input for material and structure !!!', 'Error');
        warning('Wrong input for material and structure !!!');
        flag_error = 1;
    end

    if flag_error == 0
        slip_syst = slip_systems(phase, listslip);
         ss_cart = zeros(2,3,size(slip_syst, 3));
         ss_cart_norm = zeros(2,3,size(slip_syst, 3));
        if strcmp(phase, 'hcp') == 1
            for ss_ind = 1:size(slip_syst, 3)
                ss_cart(1,:,ss_ind) = millerbravaisplane2cart(slip_syst(1,:,ss_ind), lattice_parameters(1));
                ss_cart(2,:,ss_ind) = millerbravaisdir2cart(slip_syst(2,:,ss_ind), lattice_parameters(1));
                ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind)/norm(ss_cart(1,:,ss_ind));
                ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind)/norm(ss_cart(2,:,ss_ind));
            end
        else
            for ss_ind = 1:size(slip_syst, 3)
                ss_cart(1,:,ss_ind) = slip_syst(1,:,ss_ind);
                ss_cart(2,:,ss_ind) = slip_syst(2,:,ss_ind);
                ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind)/norm(ss_cart(1,:,ss_ind));
                ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind)/norm(ss_cart(2,:,ss_ind));
            end
        end
    end
end

if flag_error == 0
    if lattice_parameters(1) ~= 0
        % Preallocation
        sortbv   = zeros(size(slip_syst, 3), 15, grain);
        slip_vec = zeros(size(slip_syst, 3), 15);
        g_mat    = zeros(3, 3, grain);
        vect = zeros(size(slip_syst, 3), 16, grain);
        
        for ig = grain
            % Setting of Euler angles
            euler = plotGB_Bicrystal_update_euler(euler_ori, handle_euler);
            g_mat(:,:,ig) = eulers2g(euler);
            
            for ii = 1:1:size(slip_syst, 3)
                slip_vec(ii,1:3) = g_mat(:,:,ig).'*ss_cart_norm(1,1:3,ii)';   % Plane normal (n vector normalized)
                slip_vec(ii,4:6) = g_mat(:,:,ig).'*ss_cart_norm(2,1:3,ii)';   % Slip direction (b vector normalized)
                % Generalized Schmid Factor
                slip_vec(ii,7)   = generalized_schmid_factor(ss_cart_norm(1,:,ii), ss_cart_norm(2,:,ii), stress_tensor, g_mat(:,:,ig));
                if isnan(slip_vec(ii,7))
                    slip_vec(ii,8) = 0;
                else
                    slip_vec(ii,8) = abs(slip_vec(ii,7));                     % Abs(Generalized Schmid Factor)
                end
                slip_vec(ii,9) = ii;                                          % Index of slip (number from 1 to 57 for hcp)
                slip_vec(ii,10:12) = ss_cart(2,1:3,ii);                       % Slip direction (b vector non normalized)
                slip_vec(ii,13:15) = -ss_cart(2,1:3,ii);                      % Slip direction (b vector non normalized and in the opposite direction)
            end
            sortbv(:,:,ig)  = sortrows(slip_vec, -8);                         % Sort slip systems by Generalized Schimd factor
            vect(:,1:15,ig) = slip_vec;                                       % Matrix with slip systems, Burgers vectors, index of slips for GrainA...
            vect(:,16,ig)   = size(slip_syst, 3);
            vect(:,17,ig)   = sortbv(:,8,ig);                                 % Highest Generalized Schmid Factor
        end
    end
end

end