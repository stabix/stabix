% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: plotGB_Bicrystal_mprime_calculator_bc.m 1218 2014-08-08 15:04:06Z d.mercier $
function plotGB_Bicrystal_mprime_calculator_all(listslipA, listslipB)
%% Script used to calculate m' parameter values for all a bicrystal
% listslipA: list of slip systems for grainA from popup menu
% listslipB: list of slip systems for grainB from popup menu
%
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

gui.calculations = struct();

%% Vectors calculation for GrainA
for ig = gui.GB.GrainA                                                     % Loop to set GrainA properties (identity, Euler angles, position)
    clear sortbvA lattice_parameters ss ss_cart ss_cart_norm slip_vec;
    lattice_parameters_A = latt_param(gui.GB.Material_A, gui.GB.Phase_A);  % Get the lattice parameter for GrainA
    if lattice_parameters_A(1) == 0
        errordlg('Wrong input for material and structure !!!');
        break;
    end
    
    ss_grA = slip_systems(gui.GB.Phase_A); % listslipA (see plotGB_Bicrystal_mprime_calculator_bc)
    if strcmp(gui.GB.Phase_A, 'hcp') == 1
        for ss_ind = 1:size(ss_grA, 3)
            ss_cart(1,:,ss_ind) = millerbravaisplane2cart(ss_grA(1,:,ss_ind), lattice_parameters_A(1));
            ss_cart(2,:,ss_ind) = millerbravaisdir2cart(ss_grA(2,:,ss_ind), lattice_parameters_A(1));
            ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind)/norm(ss_cart(1,:,ss_ind));
            ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind)/norm(ss_cart(2,:,ss_ind));
        end
    else
        for ss_ind = 1:size(ss_grA, 3)
            ss_cart(1,:,ss_ind) = ss_grA(1,:,ss_ind);
            ss_cart(2,:,ss_ind) = ss_grA(2,:,ss_ind);
            ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind)/norm(ss_cart(1,:,ss_ind));
            ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind)/norm(ss_cart(2,:,ss_ind));
        end
    end
end

if lattice_parameters_A(1) ~= 0
    % Preallocation
    sortbvA   = NaN(size(ss_grA, 3), 15, gui.GB.GrainA);
    slip_vecA = NaN(size(ss_grA, 3), 15);
    vectA     = NaN(size(ss_grA, 3), 16, gui.GB.GrainA);
    g_A       = NaN(3, 3, gui.GB.GrainA);
    
    for ig = gui.GB.GrainA
        % Setting of Euler angles
        guidata(gcf, gui);
        gui.GB.eulerA = plotGB_Bicrystal_update_euler(gui.GB.eulerA_ori, gui.handles.getEulangGrA);
        gui = guidata(gcf);
        g_A(:,:,ig) = eulers2g(gui.GB.eulerA);
        
        for ii = 1:1:size(ss_grA, 3)
            slip_vecA(ii,1:3) = g_A(:,:,ig).'*ss_cart_norm(1,1:3,ii)';     % Plane normal (n vector normalized)
            slip_vecA(ii,4:6) = g_A(:,:,ig).'*ss_cart_norm(2,1:3,ii)';     % Slip direction (b vector normalized)
            % Generalized Schmid Factor
            slip_vecA(ii,7)   = generalized_schmid_factor(ss_cart_norm(1,:,ii), ss_cart_norm(2,:,ii), gui.stress_tensor.bc_sigma, g_A(:,:,ig));
            if isnan(slip_vecA(ii,7))
                slip_vecA(ii,8) = 0;
            else
                slip_vecA(ii,8) = abs(slip_vecA(ii,7));                    % Abs(Generalized Schmid Factor)
            end
            slip_vecA(ii,9) = ii;                                          % Index of slip (number from 1 to 57 for hcp)
            slip_vecA(ii,10:12) = ss_cart(2,1:3,ii);                       % Slip direction (b vector non normalized)
            slip_vecA(ii,13:15) = -ss_cart(2,1:3,ii);                      % Slip direction (b vector non normalized and in the opposite direction)
        end
        sortbvA(:,:,ig)  = sortrows(slip_vecA, -8);                        % Sort slip systems by Generalized Schimd factor
        gui.calculations.vectA(:,1:15,ig) = slip_vecA;                     % Matrix with slip systems, Burgers vectors, index of slips for GrainA...
        gui.calculations.vectA(:,16,ig)   = size(ss_grA, 3);
        gui.calculations.vectA(:,17,ig)   = sortbvA(:,8,ig);               % Highest Generalized Schmid Factor
    end
    
    guidata(gcf, gui);
end

%% Vectors calculation for GrainB
for ig = gui.GB.GrainB                                                     % Loop to set GrainB properties (identity, Euler angles, position)
    clear sortbvB lattice_parameters ss ss_cart ss_cart_norm slip_vec;
    lattice_parameters_B = latt_param(gui.GB.Material_B, gui.GB.Phase_B);  % Get the lattice parameter for GrainB
    if lattice_parameters_B(1) == 0
        errordlg('Wrong input for material and structure !!!');
        break;
    end
    
    ss_grB = slip_systems(gui.GB.Phase_B); % listslipB (see plotGB_Bicrystal_mprime_calculator_bc)
    if strcmp(gui.GB.Phase_B, 'hcp') == 1
        for ss_ind = 1:size(ss_grB, 3)
            ss_cart(1,:,ss_ind) = millerbravaisplane2cart(ss_grB(1,:,ss_ind), lattice_parameters_B(1));
            ss_cart(2,:,ss_ind) = millerbravaisdir2cart(ss_grB(2,:,ss_ind), lattice_parameters_B(1));
            ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind)/norm(ss_cart(1,:,ss_ind));
            ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind)/norm(ss_cart(2,:,ss_ind));
        end
    else
        for ss_ind = 1:size(ss_grB, 3)
            ss_cart(1,:,ss_ind) = ss_grB(1,:,ss_ind);
            ss_cart(2,:,ss_ind) = ss_grB(2,:,ss_ind);
            ss_cart_norm(1,:,ss_ind) = ss_cart(1,:,ss_ind)/norm(ss_cart(1,:,ss_ind));
            ss_cart_norm(2,:,ss_ind) = ss_cart(2,:,ss_ind)/norm(ss_cart(2,:,ss_ind));
        end
    end
end

if lattice_parameters_B(1) ~= 0
    % Preallocation
    sortbvB   = NaN(size(ss_grB, 3), 15, gui.GB.GrainB);
    slip_vecB = NaN(size(ss_grB, 3), 15);
    vectB     = NaN(size(ss_grB, 3), 16, gui.GB.GrainB);
    g_B         = NaN(3, 3, gui.GB.GrainB);
    
    for ig = gui.GB.GrainB
        % Setting of Euler angles
        guidata(gcf, gui);
        gui.GB.eulerB = plotGB_Bicrystal_update_euler(gui.GB.eulerB_ori, gui.handles.getEulangGrB);
        gui = guidata(gcf);
        g_B(:,:,ig) = eulers2g(gui.GB.eulerB);
        
        for ii = 1:1:size(ss_grB, 3)
            slip_vecB(ii,1:3) = g_B(:,:,ig).'*ss_cart_norm(1,1:3,ii)';     % Plane normal (n vector normalized)
            slip_vecB(ii,4:6) = g_B(:,:,ig).'*ss_cart_norm(2,1:3,ii)';     % Slip direction (b vector normalized)
            % Generalized Schmid Factor
            slip_vecB(ii,7)   = generalized_schmid_factor(ss_cart_norm(1,:,ii), ss_cart_norm(2,:,ii), gui.stress_tensor.bc_sigma, g_B(:,:,ig));
            if isnan(slip_vecB(ii,7))
                slip_vecB(ii,8) = 0;
            else
                slip_vecB(ii,8) = abs(slip_vecB(ii,7));                    % Abs(Generalized Schmid Factor)
            end
            slip_vecB(ii,9) = ii;                                          % Index of slip (number from 1 to 57 for hcp)
            slip_vecB(ii,10:12) = ss_cart(2,1:3,ii);                       % Slip direction (b vector non normalized)
            slip_vecB(ii,13:15) = -ss_cart(2,1:3,ii);                      % Slip direction (b vector non normalized and in the opposite direction)
        end
        sortbvB(:,:,ig)  = sortrows(slip_vecB, -8);                        % Sort slip systems by Generalized Schimd factor
        gui.calculations.vectB(:,1:15,ig) = slip_vecB;                     % Matrix with slip systems, Burgers vectors, index of slips for grain B...
        gui.calculations.vectB(:,16,ig)   = size(ss_grB, 3);
        gui.calculations.vectB(:,17,ig)   = sortbvB(:,8,ig);               % Highest Generalized Schmid Factor
    end
    
    guidata(gcf, gui);
end

if lattice_parameters_A(1) ~= 0 && lattice_parameters_B(1) ~= 0
    %% m', residual Burgers vector, N-factor and SF(GB) calculations
    gui = guidata(gcf);
    gui.flag.flag_dir_vectA = NaN(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));           % Preallocation
    gui.flag.flag_dir_vectB = NaN(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));           % Preallocation
    
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            
            if get(gui.handles.pmchoicecase, 'Value') < 8 || get(gui.handles.pmchoicecase, 'Value') > 28 % To speed up calculations
            % m prime (Luster and Morris) (abs value)
            gui.calculations.mprime_val_bc_all(jj,kk) = mprime(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
            
            elseif get(gui.handles.pmchoicecase, 'Value') > 7 && get(gui.handles.pmchoicecase, 'Value') < 15
            % residual Burgers vector
            rbv_bc_val(1) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
            rbv_bc_val(2) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
            %rbv_bc_val(3) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
            %rbv_bc_val(4) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
            gui.calculations.residual_Burgers_vector_val_bc_all(jj,kk) = min(rbv_bc_val);
            ind = find(rbv_bc_val == min(min(rbv_bc_val)));
            
            if ind == 1
                gui.flag.flag_dir_vectA(jj,kk) = 0;
                gui.flag.flag_dir_vectB(jj,kk) = 0;
            elseif ind == 2
                gui.flag.flag_dir_vectA(jj,kk) = 1;
                gui.flag.flag_dir_vectB(jj,kk) = 0;
                %             elseif ind == 3
                %                 flag_dir_gui.calculations.vectA(jj,kk) = 0;
                %                 flag_dir_gui.calculations.vectB(jj,kk) = 1;
                %             elseif ind == 4
                %                 flag_dir_gui.calculations.vectA(jj,kk) = 1;
                %                 flag_dir_gui.calculations.vectB(jj,kk) = 1;
            end
            
            elseif get(gui.handles.pmchoicecase, 'Value') > 14 && get(gui.handles.pmchoicecase, 'Value') < 22
            % N factor (Livingston and Chamlers) (abs value)
            gui.calculations.n_fact_val_bc_all(jj,kk) = N_factor(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
            
            elseif get(gui.handles.pmchoicecase, 'Value') > 21 && get(gui.handles.pmchoicecase, 'Value') < 29
            % LRB paramter (Shen) (abs value)
            gui.calculations.LRB_val_bc_all(jj,kk) = LRB_parameter(cross(gui.GB_geometry.d_gb,gui.calculations.vectA(kk,4:6,gui.GB.GrainA)), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                cross(gui.GB_geometry.d_gb,gui.calculations.vectB(jj,4:6,gui.GB.GrainB)), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
            
            elseif get(gui.handles.pmchoicecase, 'Value') == 29
            %             % GB Schmid Factor (Abuzaid) % Done in plotGB_Bicrystal_mprime_calculator_bc
            %             GB_Schmid_Factor_max = gui.calculations.vectA(1,17,gui.GB.GrainA) + gui.calculations.vectB(1,17,gui.GB.GrainB);
            
            end
        end
    end
    
    guidata(gcf, gui);
    plotGB_Bicrystal_mprime_calculator_bc(listslipA, listslipB);
    gui = guidata(gcf); guidata(gcf, gui);
    
    % Reshape the matrix of transmission parameters results calculated for
    % all slip families, in function of user-specified slip families, to
    % get maximum/minimum values....
    %
    %     slip_system_A = slip_systems(gui.GB.Phase_A, listslipA);
    %     [jj_A, kk_A] = find(~isnan(slip_system_A(1,1,:)));
    %     slip_system_B = slip_systems(gui.GB.Phase_B, listslipB);
    %     [jj_B, kk_B] = find(~isnan(slip_system_B(1,1,:)));
    %
    %     gui.GB.mprime_val_bc = gui.GB.mprime_val_bc_all(kk_B, kk_A);
    %     gui.GB.residual_Burgers_vector_val_bc = gui.GB.residual_Burgers_vector_val_bc_all(kk_B, kk_A);
    %     gui.GB.n_fact_val_bc = gui.GB.n_fact_val_bc_all(kk_B, kk_A);
    %     gui.GB.LRB_val_bc = gui.GB.LRB_val_bc_all(kk_B, kk_A);
    
    gui.flag.error = 0;
else
    
    gui.flag.error = 1;
end
guidata(gcf, gui);
end
