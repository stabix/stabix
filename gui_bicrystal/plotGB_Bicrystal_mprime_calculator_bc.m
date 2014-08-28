% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_mprime_calculator_bc(listslipA, listslipB)
%% Script used to calculate m' parameter values for all a bicrystal
% listslipA: list of slip systems for grainA from popup menu
% listslipB: list of slip systems for grainB from popup menu
%
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

%% Vectors calculation for GrainA
for ig = gui.GB.GrainA                                                     % Loop to set GrainA properties (identity, Euler angles, position)
    clear sortbvA lattice_parameters ss ss_cart ss_cart_norm slip_vec;
    lattice_parameters_A = latt_param(gui.GB.Material_A, gui.GB.Phase_A);  % Get the lattice parameter for GrainA
    if lattice_parameters_A(1) == 0
        errordlg('Wrong input for material and structure !!!');
        break;
    end
    
    ss_grA = slip_systems(gui.GB.Phase_A, listslipA);
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
    
    ss_grB = slip_systems(gui.GB.Phase_B, listslipB);
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
            
            %if get(gui.handles.pmchoicecase, 'Value') < 8 % To speed up calculations
                % m prime (Luster and Morris)
                gui.calculations.mprime_val_bc(jj,kk) = mprime(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                    gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
                
            %elseif get(gui.handles.pmchoicecase, 'Value') > 7 && get(gui.handles.pmchoicecase, 'Value') < 15
                % residual Burgers vector
                rbv_bc_val(1) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
                rbv_bc_val(2) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
                %rbv_bc_val(3) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
                %rbv_bc_val(4) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
                gui.calculations.residual_Burgers_vector_val_bc(jj,kk) = min(rbv_bc_val);
                ind = find(rbv_bc_val == min(min(rbv_bc_val)));
                
                if ind == 1
                    gui.flag.flag_dir_vectA(jj,kk) = 0;
                    gui.flag.flag_dir_vectB(jj,kk) = 0;
                elseif ind == 0
                    gui.flag.flag_dir_vectA(jj,kk) = 1;
                    gui.flag.flag_dir_vectB(jj,kk) = 0;
                    %             elseif ind == 3
                    %                 flag_dir_gui.calculations.vectA(jj,kk) = 0;
                    %                 flag_dir_gui.calculations.vectB(jj,kk) = 1;
                    %             elseif ind == 4
                    %                 flag_dir_gui.calculations.vectA(jj,kk) = 1;
                    %                 flag_dir_gui.calculations.vectB(jj,kk) = 1;
                end
                
            %elseif get(gui.handles.pmchoicecase, 'Value') > 14 && get(gui.handles.pmchoicecase, 'Value') < 22
                % N factor (Livingston and Chamlers)
                gui.calculations.n_fact_val_bc(jj,kk) = N_factor(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                    gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
                
            %elseif get(gui.handles.pmchoicecase, 'Value') > 21 && get(gui.handles.pmchoicecase, 'Value') < 29
                % LRB paramter (Shen)
                gui.calculations.LRB_val_bc(jj,kk) = LRB_parameter(cross(gui.GB_geometry.d_gb,gui.calculations.vectA(kk,4:6,gui.GB.GrainA)), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                    cross(gui.GB_geometry.d_gb,gui.calculations.vectB(jj,4:6,gui.GB.GrainB)), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
                
            %elseif get(gui.handles.pmchoicecase, 'Value') == 29
                % GB Schmid Factor (Abuzaid)
                gui.calculations.GB_Schmid_Factor_max = gui.calculations.vectA(1,17,gui.GB.GrainA) + gui.calculations.vectB(1,17,gui.GB.GrainB);
                
            %end
            
        end
    end
    
    % When 'User-spec' is selected by user or when bicrystal is defined with a YAML file
    if size(ss_grA, 3) == 1 && size(ss_grB, 3) == 1
        gui.GB.mprime_val_data = struct(...
            'mprime_spec_user',    gui.calculations.mprime_val_bc,...
            'rbv_spec_user',       gui.calculations.residual_Burgers_vector_val_bc,...
            'Nfactor_spec_user',   gui.calculations.n_fact_val_bc,...
            'LRBfactor_spec_user', gui.calculations.LRB_val_bc);
    else
        clearvars testNaN_mpr testNaN_rbv testNaN_nfact mpr rbv nfact LRBfact;
        
        % A matrix with m' values is filled in for each grain
        mpr(:,:,gui.GB.GB_Number)     = gui.calculations.mprime_val_bc;
        %testNaN_mpr(:,:,gui.GB.GB_Number) = isnan(mpr(:,:,gui.GB.GB_Number));
        % A matrix with residual Burgers vector values is filled in for each grain
        rbv(:,:,gui.GB.GB_Number)     = gui.calculations.residual_Burgers_vector_val_bc;
        %testNaN_rbv(:,:,gui.GB.GB_Number) = isnan(rbv(:,:,gui.GB.GB_Number));
        % A matrix with m' values is filled in for each grain
        nfact(:,:,gui.GB.GB_Number)     = gui.calculations.n_fact_val_bc;
        %testNaN_nfact(:,:,gui.GB.GB_Number) = isnan(nfact(:,:,gui.GB.GB_Number));
        LRBfact(:,:,gui.GB.GB_Number)   = gui.calculations.LRB_val_bc;
        %testNaN_nfact(:,:,gui.GB.GB_Number) = isnan(nfact(:,:,gui.GB.GB_Number));
        
        % Sorting m' values (max and min)
        [mp_max1, x_mp_max1, y_mp_max1, mp_max2, x_mp_max2, y_mp_max2, mp_max3, x_mp_max3, y_mp_max3, ...
            mp_min1, x_mp_min1, y_mp_min1, mp_min2, x_mp_min2, y_mp_min2, mp_min3, x_mp_min3, y_mp_min3] = sort_values(mpr(:,:,gui.GB.GB_Number));
        
        % Residual Burgers Vectors (max and min)
        [rbv_max1, x_rbv_max1, y_rbv_max1, rbv_max2, x_rbv_max2, y_rbv_max2, rbv_max3, x_rbv_max3, y_rbv_max3, ...
            rbv_min1, x_rbv_min1, y_rbv_min1, rbv_min2, x_rbv_min2, y_rbv_min2, rbv_min3, x_rbv_min3, y_rbv_min3] = sort_values(rbv(:,:,gui.GB.GB_Number));
        
        % Sorting N-factor values (max and min)
        [nfact_max1, x_nfact_max1, y_nfact_max1, nfact_max2, x_nfact_max2, y_nfact_max2, nfact_max3, x_nfact_max3, y_nfact_max3, ...
            nfact_min1, x_nfact_min1, y_nfact_min1, nfact_min2, x_nfact_min2, y_nfact_min2, nfact_min3, x_nfact_min3, y_nfact_min3] = sort_values(nfact(:,:,gui.GB.GB_Number));
        
        % Sorting LRB factor values (max and min)
        [LRBfact_max1, x_LRBfact_max1, y_LRBfact_max1, LRBfact_max2, x_LRBfact_max2, y_LRBfact_max2, LRBfact_max3, x_LRBfact_max3, y_LRBfact_max3, ...
            LRBfact_min1, x_LRBfact_min1, y_LRBfact_min1, LRBfact_min2, x_LRBfact_min2, y_LRBfact_min2, LRBfact_min3, x_LRBfact_min3, y_LRBfact_min3] = sort_values(LRBfact(:,:,gui.GB.GB_Number));
        
        %% Storing of m'/RBV/N_factor with slips with highest Generalized Schmid Factors
        SFmax_x = sortbvB(1,9,gui.GB.GrainB); % Column 9 --> Indice of slip (Row 1 = max)
        SFmax_y = sortbvA(1,9,gui.GB.GrainA); % Column 9 --> Indice of slip (Row 1 = max)
        mp_SFmax    = mpr(SFmax_x, SFmax_y, gui.GB.GB_Number);
        rbv_SFmax   = rbv(SFmax_x, SFmax_y, gui.GB.GB_Number);
        nfact_SFmax = nfact(SFmax_x, SFmax_y, gui.GB.GB_Number);
        LRBfact_SFmax = LRBfact(SFmax_x, SFmax_y, gui.GB.GB_Number);
        
        %% All results are stored...
        gui.GB.results = struct(...
            'mprime_valmax1',            mp_max1,...                       % m' results
            'slipA_mp_max1',             y_mp_max1,...
            'slipB_mp_max1',             x_mp_max1,...
            'mprime_valmax2',            mp_max2,...
            'slipA_mp_max2',             y_mp_max2,...
            'slipB_mp_max2',             x_mp_max2,...
            'mprime_valmax3',            mp_max3,...
            'slipA_mp_max3',             y_mp_max3,...
            'slipB_mp_max3',             x_mp_max3,...
            'mprime_valmin1',            mp_min1,...
            'slipA_mp_min1',             y_mp_min1,...
            'slipB_mp_min1',             x_mp_min1,...
            'mprime_valmin2',            mp_min2,...
            'slipA_mp_min2',             y_mp_min2,...
            'slipB_mp_min2',             x_mp_min2,...
            'mprime_valmin3',            mp_min3,...
            'slipA_mp_min3',             y_mp_min3,...
            'slipB_mp_min3',             x_mp_min3,...
            'mprime_SFmax',              mp_SFmax,...
            'slipASFmax',                SFmax_y,...
            'slipBSFmax',                SFmax_x,...
            ...
            'rbv_valmax1',               rbv_max1,...                      % Residual Burgers Vector results
            'slipA_rbv_max1',            y_rbv_max1,...
            'slipB_rbv_max1',            x_rbv_max1,...
            'rbv_valmax2',               rbv_max2,...
            'slipA_rbv_max2',            y_rbv_max2,...
            'slipB_rbv_max2',            x_rbv_max2,...
            'rbv_valmax3',               rbv_max3,...
            'slipA_rbv_max3',            y_rbv_max3,...
            'slipB_rbv_max3',            x_rbv_max3,...
            'rbv_valmin1',               rbv_min1,...
            'slipA_rbv_min1',            y_rbv_min1,...
            'slipB_rbv_min1',            x_rbv_min1,...
            'rbv_valmin2',               rbv_min2,...
            'slipA_rbv_min2',            y_rbv_min2,...
            'slipB_rbv_min2',            x_rbv_min2,...
            'rbv_valmin3',               rbv_min3,...
            'slipA_rbv_min3',            y_rbv_min3,...
            'slipB_rbv_min3',            x_rbv_min3,...
            'rbv_SFmax',                 rbv_SFmax,...
            ...
            'nfact_valmax1',             nfact_max1,...                    % N factor results
            'slipA_nfact_max1',          y_nfact_max1,...
            'slipB_nfact_max1',          x_nfact_max1,...
            'nfact_valmax2',             nfact_max2,...
            'slipA_nfact_max2',          y_nfact_max2,...
            'slipB_nfact_max2',          x_nfact_max2,...
            'nfact_valmax3',             nfact_max3,...
            'slipA_nfact_max3',          y_nfact_max3,...
            'slipB_nfact_max3',          x_nfact_max3,...
            'nfact_valmin1',             nfact_min1,...
            'slipA_nfact_min1',          y_nfact_min1,...
            'slipB_nfact_min1',          x_nfact_min1,...
            'nfact_valmin2',             nfact_min2,...
            'slipA_nfact_min2',          y_nfact_min2,...
            'slipB_nfact_min2',          x_nfact_min2,...
            'nfact_valmin3',             nfact_min3,...
            'slipA_nfact_min3',          y_nfact_min3,...
            'slipB_nfact_min3',          x_nfact_min3,...
            'nfact_SFmax',               nfact_SFmax,...
            ...
            'LRBfact_valmax1',           LRBfact_max1,...                  % LRB parameter results
            'slipA_LRBfact_max1',        y_LRBfact_max1,...
            'slipB_LRBfact_max1',        x_LRBfact_max1,...
            'LRBfact_valmax2',           LRBfact_max2,...
            'slipA_LRBfact_max2',        y_LRBfact_max2,...
            'slipB_LRBfact_max2',        x_LRBfact_max2,...
            'LRBfact_valmax3',           LRBfact_max3,...
            'slipA_LRBfact_max3',        y_LRBfact_max3,...
            'slipB_LRBfact_max3',        x_LRBfact_max3,...
            'LRBfact_valmin1',           LRBfact_min1,...
            'slipA_LRBfact_min1',        y_LRBfact_min1,...
            'slipB_LRBfact_min1',        x_LRBfact_min1,...
            'LRBfact_valmin2',           LRBfact_min2,...
            'slipA_LRBfact_min2',        y_LRBfact_min2,...
            'slipB_LRBfact_min2',        x_LRBfact_min2,...
            'LRBfact_valmin3',           LRBfact_min3,...
            'slipA_LRBfact_min3',        y_LRBfact_min3,...
            'slipB_LRBfact_min3',        x_LRBfact_min3,...
            'LRBfact_SFmax',             LRBfact_SFmax,...
            ...
            'GB_Schmid_Factor_max',      gui.calculations.GB_Schmid_Factor_max);
        
    end
    
    gui.flag.error = 0;
else
    
    gui.flag.error = 1;
end
guidata(gcf, gui);
end
