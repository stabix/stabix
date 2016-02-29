% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function lambdaValues = lambda_plot_values(material_1, phase_1, material_2, phase_2, ...
    angleStep, phi2, phi_c, kappa_c, varargin)
%% Function used to calculate the geometric compatibility function lambda,
% defined by Werner and Prantl (1990)
% DOI ==> 10.1016/0956-7151(90)90159-E
%
% author: d.mercier@mpie.de

if nargin < 8
    % Critical angle between slip directions
    kappa_c = 45; % Given in Werner and Prantl (1990) paper
end

if nargin < 7
    % Critical angle between normals
    phi_c = 15; % Given in Werner and Prantl (1990) paper
end

if nargin < 6
    phi2 = 0; %9 %27 %45 see in Werner and Prantl (1990) paper
end

if nargin < 5
    angleStep = 3; %3 for more accurate rsults or 9 to accelerater calculations
end

if nargin < 4
    phase_2 = 'bcc';
end

if nargin < 3
    material_2 = 'Fe';
end


if nargin < 2
    phase_1 = 'bcc';
end

if nargin < 1
    material_1 = 'Fe';
end

%% Check Angle Step
remainVal = mod(90,angleStep);

if remainVal > 1e-9
    error('Wrong input for angleStep');
end

%% Definition of Euler angles
ii = 1;
eulerTot = (1+(90/(angleStep)))^2;
euler = zeros(1,3,eulerTot);

for phi1 = 0:angleStep:90
    for PHI = 0:angleStep:90
        euler(:,:,ii) = [phi1 PHI phi2];
        ii = ii + 1;
    end
end

%% Definition of slip system for fcc
slip_syst_1 = slip_systems(phase_1, 1); % 1 for only slip systems...
slip_syst_2 = slip_systems(phase_2, 1); % 1 for only slip systems...

% To remove NaN values...
for ii = 1:size(slip_syst_1, 3)
    if ~isnan(slip_syst_1(1,1,ii))
        slip_syst_cleaned_1(:,:,ii) = slip_syst_1(:,:,ii);
    end
end
slip_syst_1 = slip_syst_cleaned_1;
for ii = 1:size(slip_syst_2, 3)
    if ~isnan(slip_syst_2(1,1,ii))
        slip_syst_cleaned_2(:,:,ii) = slip_syst_2(:,:,ii);
    end
end
slip_syst_2 = slip_syst_cleaned_2;

slip_vec_1 = zeros(size(slip_syst_1, 3), 17, eulerTot);
slip_vec_2 = zeros(size(slip_syst_2, 3), 17, eulerTot);
for ii = 1:eulerTot
    [slip_vec_1(:,:,ii), flag_error] = ...
        vector_calculations(ii, material_1, phase_1, euler(:,:,ii), slip_syst_1);
end
for ii = 1:eulerTot
    [slip_vec_2(:,:,ii), flag_error] = ...
        vector_calculations(ii, material_2, phase_2, euler(:,:,ii), slip_syst_2);
end

% to remove useless values
vectCleaned_1(:,:,:) = slip_vec_1(:,1:6,:);
vectCleaned_2(:,:,:) = slip_vec_2(:,1:6,:);

if flag_error
    error('Error in the calculations of the vectors for slip direction and slip normal !');
end

for ii = 1:eulerTot
    for jj = 1:1:size(slip_syst_1,3)
        for kk = 1:1:size(slip_syst_2,3)
            n1 = vectCleaned_1(jj,1:3,1); % Euler = [0 0 0] ==> Reference
            n2 = vectCleaned_2(kk,1:3,ii);
            d1 = vectCleaned_1(jj,4:6,1); % Euler = [0 0 0] ==> Reference
            d2 = vectCleaned_2(kk,4:6,ii);
            
            test_vectors_orthogonality(n1, d1);
            test_vectors_orthogonality(n2, d2);

            cos_phi(jj,kk,ii) = cosFromVectors(n1, n2);
            cos_kappa(jj,kk,ii) = cosFromVectors(d1, d2);
            
            % Next checks used to avoid complex values returned 
            % by acosd function for phi and kappa calculations
            
            if cos_phi(jj,kk,ii) > 1
                cos_phi(jj,kk,ii) = 1;
            end
            if cos_kappa(jj,kk,ii) > 1
                cos_kappa(jj,kk,ii) = 1;
            end
            if cos_phi(jj,kk,ii) < -1
                cos_phi(jj,kk,ii) = -1;
            end
            if cos_kappa(jj,kk,ii) < -1
                cos_kappa(jj,kk,ii) = -1;
            end

            phi(jj,kk,ii) = round(acosd(abs(cos_phi(jj,kk,ii))));
            kappa(jj,kk,ii) = round(acosd(abs(cos_kappa(jj,kk,ii))));
            
            % mod ==> 180° = 0°
            phi(jj,kk,ii) = mod(phi(jj,kk,ii),180);
            kappa(jj,kk,ii) = mod(kappa(jj,kk,ii),180);

            if phi(jj,kk,ii) < phi_c && kappa(jj,kk,ii) < kappa_c
                lambdaValues(jj,kk,ii) = cosd(90 * phi(jj,kk,ii)/phi_c) *...
                    cosd(90 * kappa(jj,kk,ii)/kappa_c);
            else
                lambdaValues(jj,kk,ii) = 0;
            end
        end
    end
    lambda_val_sum(ii) = sum(sum(lambdaValues(:,:,ii)));
end

lambda_val_sum_mat = vec2mat(lambda_val_sum, 1+90/angleStep);

figure;
surf((0:angleStep:90), (0:angleStep:90), lambda_val_sum_mat, ...
    'FaceColor', 'interp', 'EdgeColor','none');
axis tight; 
xlabel('\phi_1 (°)'); ylabel('\Phi (°)'); zlabel('\lambda');
title('\lambda distribution - \phi_2 = 0°');
view(28,32);
colorbar;

end