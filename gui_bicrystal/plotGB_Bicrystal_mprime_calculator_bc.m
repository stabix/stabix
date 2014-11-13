% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_mprime_calculator_bc(listslipA, listslipB)
%% Script used to calculate m' parameter values for all a bicrystal
% listslipA: list of slip systems for grainA from popup menu
% listslipB: list of slip systems for grainB from popup menu
%
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

[gui.calculations.vectA, gui.GB.eulerA, sortbvA] = plotGB_Bicrystal_vector_calculations(listslipA, gui.GB.GrainA, gui.GB.Material_A,...
    gui.GB.Phase_A, gui.GB.eulerA_ori, gui.handles.getEulangGrA,...
    gui.stress_tensor.sigma, gui.flag.error);

[gui.calculations.vectB, gui.GB.eulerB, sortbvB] = plotGB_Bicrystal_vector_calculations(listslipB, gui.GB.GrainB, gui.GB.Material_B,...
    gui.GB.Phase_B, gui.GB.eulerB_ori, gui.handles.getEulangGrB,...
    gui.stress_tensor.sigma, gui.flag.error);

guidata(gcf, gui);

%% m', residual Burgers vector, N-factor and SF(GB) calculations
gui = guidata(gcf);

if get(gui.handles.pmchoicecase, 'Value') < 8
    gui.calculations.mprime_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            % m prime (Luster and Morris)
            gui.calculations.mprime_val_bc(jj,kk) = mprime(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
        end
    end
elseif get(gui.handles.pmchoicecase, 'Value') > 7 && get(gui.handles.pmchoicecase, 'Value') < 15
    gui.calculations.residual_Burgers_vector_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            % residual Burgers vector
            rbv_bc_val(1) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
            rbv_bc_val(2) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
            %rbv_bc_val(3) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
            %rbv_bc_val(4) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
            gui.calculations.residual_Burgers_vector_val_bc(jj,kk) = min(rbv_bc_val);
        end
    end
elseif get(gui.handles.pmchoicecase, 'Value') > 14 && get(gui.handles.pmchoicecase, 'Value') < 22
    gui.calculations.n_fact_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            % N factor (Livingston and Chamlers)
            gui.calculations.n_fact_val_bc(jj,kk) = N_factor(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
        end
    end
elseif get(gui.handles.pmchoicecase, 'Value') > 21 && get(gui.handles.pmchoicecase, 'Value') < 29
    gui.calculations.LRB_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            % LRB paramter (Shen)
            gui.calculations.LRB_val_bc(jj,kk) = LRB_parameter(cross(gui.GB_geometry.d_gb,gui.calculations.vectA(kk,4:6,gui.GB.GrainA)), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                cross(gui.GB_geometry.d_gb,gui.calculations.vectB(jj,4:6,gui.GB.GrainB)), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
        end
    end
elseif get(gui.handles.pmchoicecase, 'Value') == 29
    gui.calculations.GB_Schmid_Factor_max = 0;
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            % GB Schmid Factor (Abuzaid)
            gui.calculations.GB_Schmid_Factor_max = gui.calculations.vectA(1,17,gui.GB.GrainA) + gui.calculations.vectB(1,17,gui.GB.GrainB);
        end
    end
elseif get(gui.handles.pmchoicecase, 'Value') > 29
    gui.calculations.mprime_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    gui.calculations.residual_Burgers_vector_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    gui.calculations.n_fact_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    gui.calculations.LRB_val_bc = zeros(gui.calculations.vectB(1,9,gui.GB.GrainB), gui.calculations.vectA(1,9,gui.GB.GrainA));
    for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
        for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
            gui.calculations.mprime_val_bc(jj,kk) = mprime(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
            rbv_bc_val(1) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
            rbv_bc_val(2) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,gui.GB.GrainA), gui.calculations.vectB(jj,10:12,gui.GB.GrainB), gui.GB.eulerA, gui.GB.eulerB);
            gui.calculations.residual_Burgers_vector_val_bc(jj,kk) = min(rbv_bc_val);
            gui.calculations.n_fact_val_bc(jj,kk) = N_factor(gui.calculations.vectA(kk,1:3,gui.GB.GrainA), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                gui.calculations.vectB(jj,1:3,gui.GB.GrainB), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
            gui.calculations.LRB_val_bc(jj,kk) = LRB_parameter(cross(gui.GB_geometry.d_gb,gui.calculations.vectA(kk,4:6,gui.GB.GrainA)), gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                cross(gui.GB_geometry.d_gb,gui.calculations.vectB(jj,4:6,gui.GB.GrainB)), gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
        end
    end
end

res.SFmax_x = sortbvB(1,9,gui.GB.GrainB); % Column 9 --> Indice of slip (Row 1 = max)
res.SFmax_y = sortbvA(1,9,gui.GB.GrainA); % Column 9 --> Indice of slip (Row 1 = max)

if get(gui.handles.pmchoicecase, 'Value') < 8
    % A matrix with m' values is filled in for each grain
    mpr(:,:,gui.GB.GB_Number) = gui.calculations.mprime_val_bc;
    % Sorting m' values (max and min)
    [res.mp_max1, res.x_mp_max1, res.y_mp_max1, res.mp_max2, res.x_mp_max2, res.y_mp_max2, res.mp_max3, res.x_mp_max3, res.y_mp_max3, ...
        res.mp_min1, res.x_mp_min1, res.y_mp_min1, res.mp_min2, res.x_mp_min2, res.y_mp_min2, res.mp_min3, res.x_mp_min3, res.y_mp_min3] = sort_values(mpr(:,:,gui.GB.GB_Number));
    res.mp_SFmax = mpr(res.SFmax_x, res.SFmax_y, gui.GB.GB_Number);
    
elseif get(gui.handles.pmchoicecase, 'Value') > 7 && get(gui.handles.pmchoicecase, 'Value') < 15
    % A matrix with residual Burgers vector values is filled in for each grain
    rbv(:,:,gui.GB.GB_Number) = gui.calculations.residual_Burgers_vector_val_bc;
    % Residual Burgers Vectors (max and min)
    [res.rbv_max1, res.x_rbv_max1, res.y_rbv_max1, res.rbv_max2, res.x_rbv_max2, res.y_rbv_max2, res.rbv_max3, res.x_rbv_max3, res.y_rbv_max3, ...
        res.rbv_min1, res.x_rbv_min1, res.y_rbv_min1, res.rbv_min2, res.x_rbv_min2, res.y_rbv_min2, res.rbv_min3, res.x_rbv_min3, res.y_rbv_min3] = sort_values(rbv(:,:,gui.GB.GB_Number));
    res.rbv_SFmax = rbv(res.SFmax_x, res.SFmax_y, gui.GB.GB_Number);
    
elseif get(gui.handles.pmchoicecase, 'Value') > 14 && get(gui.handles.pmchoicecase, 'Value') < 22
    % A matrix with m' values is filled in for each grain
    nfact(:,:,gui.GB.GB_Number) = gui.calculations.n_fact_val_bc;
    % Sorting N-factor values (max and min)
    [res.nfact_max1, res.x_nfact_max1, res.y_nfact_max1, res.nfact_max2, res.x_nfact_max2, res.y_nfact_max2, res.nfact_max3, res.x_nfact_max3, res.y_nfact_max3, ...
        res.nfact_min1, res.x_nfact_min1, res.y_nfact_min1, res.nfact_min2, res.x_nfact_min2, res.y_nfact_min2, res.nfact_min3, res.x_nfact_min3, res.y_nfact_min3] = sort_values(nfact(:,:,gui.GB.GB_Number));
    res.nfact_SFmax = nfact(res.SFmax_x, res.SFmax_y, gui.GB.GB_Number);
    
elseif get(gui.handles.pmchoicecase, 'Value') > 21 && get(gui.handles.pmchoicecase, 'Value') < 29
    LRBfact(:,:,gui.GB.GB_Number) = gui.calculations.LRB_val_bc;
    % Sorting LRB factor values (max and min)
    [res.LRBfact_max1, res.x_LRBfact_max1, res.y_LRBfact_max1, res.LRBfact_max2, res.x_LRBfact_max2, res.y_LRBfact_max2, res.LRBfact_max3, res.x_LRBfact_max3, res.y_LRBfact_max3, ...
        res.LRBfact_min1, res.x_LRBfact_min1, res.y_LRBfact_min1, res.LRBfact_min2, res.x_LRBfact_min2, res.y_LRBfact_min2, res.LRBfact_min3, res.x_LRBfact_min3, res.y_LRBfact_min3] = sort_values(LRBfact(:,:,gui.GB.GB_Number));
    res.LRBfact_SFmax = LRBfact(res.SFmax_x, res.SFmax_y, gui.GB.GB_Number);
    
end

gui.GB.results = res;
gui.flag.error = 0;
guidata(gcf, gui);
end
