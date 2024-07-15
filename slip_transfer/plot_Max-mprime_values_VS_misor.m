% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plot_Max-mprime_values_VS_misor
%% Example of function used to calculate mprime parameter

% author: d.mercier@mpie.de

tabularasa;
mis_all = [];
mp_all_max = [];

material = 'Ti';
phase = 'hcp';
% Lattice parameters
ca_ratio = listLattParam(material, phase);

%% Data of user
for ll = 0:5:180
    for mm = 0:5:180
        for nn = 0:5:180
            euler_1 = [ll mm nn]; % Bunge notation (in degrees)
            euler_2 = [45 45 0]; % Bunge notation (in degrees)
            all_slips = slip_systems(phase);
            mis = misorientation(euler_1, euler_2, phase, phase);
            mis_all =  [mis_all,mis];

            mp_all = [];
            for ii = 4:6 % Change for 1:3 in case of basal...Etc see slip_systems function to get slip family indices.
                for jj = 4:6 % Same as previous line, and don't forget to change title of plot at the end
                    ind_slip_in = ii;
                    ind_slip_out = jj;
                    incoming_slip = all_slips(:,:,ind_slip_in);
                    outgoing_slip = all_slips(:,:,ind_slip_out);

                    %% Calculations
                    % Eulers angle to rotation matrix
                    rot_mat1 = eulers2g(euler_1);
                    rot_mat2 = eulers2g(euler_2);

                    if strcmp(phase, 'hcp') == 1
                        % Miller-Bravais to Cartesian coordinates
                        n1_cart = millerbravaisplane2cart(incoming_slip(1,:), ca_ratio(1))';
                        d1_cart = millerbravaisdir2cart(incoming_slip(2,:), ca_ratio(1))';
                        n2_cart = millerbravaisplane2cart(outgoing_slip(1,:), ca_ratio(1))';
                        d2_cart = millerbravaisdir2cart(outgoing_slip(2,:), ca_ratio(1))';
                    end

                    % Apply rotation matrix to slip systems
                    n1_cart_rot = rot_mat1.'*n1_cart';
                    d1_cart_rot = rot_mat1.'*d1_cart';
                    n2_cart_rot = rot_mat2.'*n2_cart';
                    d2_cart_rot = rot_mat2.'*d2_cart';

                    % Normalization of input vectors
                    n1 = n1_cart_rot ./ norm(n1_cart_rot);
                    n2 = n2_cart_rot ./ norm(n2_cart_rot);
                    d1 = d1_cart_rot ./ norm(d1_cart_rot);
                    d2 = d2_cart_rot ./ norm(d2_cart_rot);

                    % Get cosine from the dot product
                    cosine_n = cosFromVectors(n1, n2);
                    cosine_d = cosFromVectors(d1, d2);
                    cosine_n_inv = cosFromVectors(n2, n1);
                    cosine_d_inv = cosFromVectors(d2, d1);

                    % m' calculation
                    mp = abs(cosine_n * cosine_d);
                    mp_all = [mp_all,mp];

                end
            end

            mp_all_max = [mp_all_max, max(mp_all)];
        end
    end
end

%% Display
figure
scatter(mis_all, mp_all_max)
xlabel('Misorientation (°)');
ylabel('m'' values');
title('Maximum m'' values vs. misorientation for prismatic <a>-prismatic <a> slip transmission');
grid on;
end