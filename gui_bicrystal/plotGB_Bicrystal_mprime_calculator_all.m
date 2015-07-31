% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_mprime_calculator_all(listslipA, listslipB)
%% Script used to calculate m' parameter values for all a bicrystal
% listslipA: list of slip systems for grainA from popup menu
% listslipB: list of slip systems for grainB from popup menu
%
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

gui.calculations = struct();

gui.flag.error = 0;

%% Set slip systems
[slip_systA, slip_check_1] = slip_systems(gui.GB.Phase_A, 9);
[slip_systB, slip_check_2] = slip_systems(gui.GB.Phase_B, 9);

[size_max_slip_sys, slip_systA, slip_systB] = ...
    check_size_slipsystem(slip_systA, slip_systB);

if isempty(find(slip_check_1==0)) && isempty(find(slip_check_2==0)) % Check orthogonality
    gui.calculations.vectA = zeros(size_max_slip_sys,21,gui.GB.GrainA);
    gui.calculations.vectB = zeros(size_max_slip_sys,21,gui.GB.GrainB);
    
    % Grain A
    gui.GB.eulerA = ...
        plotGB_Bicrystal_update_euler(...
        gui.GB.eulerA_ori, gui.handles.getEulangGrA);
    
    [slip_vecA, gui.flag.error] = ...
        vector_calculations(...
        gui.GB.GrainA, gui.GB.Material_A,...
        gui.GB.Phase_A, gui.GB.eulerA,...
        slip_systA,...
        gui.stressTensor, gui.flag.error);
    
    if ~gui.flag.error
        ig = gui.GB.GrainA;
        sortbvA(:,:,ig) = sortrows(slip_vecA, -14);                         % Sort slip systems by Generalized Schimd factor
        gui.calculations.vectA(:,1:17,ig) = slip_vecA;                      % Matrix with slip systems, Burgers vectors, index of slips for GrainA...
        gui.calculations.vectA(:,18,ig)   = size(slip_systA, 3);
        gui.calculations.vectA(:,19,ig)   = sortbvA(:,14,ig);               % Highest Generalized Schmid Factor
    end
    
    if ~gui.flag.error
        % Grain B
        gui.GB.eulerB = ...
            plotGB_Bicrystal_update_euler(...
            gui.GB.eulerB_ori, gui.handles.getEulangGrB);
        
        [slip_vecB, gui.flag.error] = ...
            vector_calculations(...
            gui.GB.GrainB, gui.GB.Material_B,...
            gui.GB.Phase_B, gui.GB.eulerB,...
            slip_systB,...
            gui.stressTensor, gui.flag.error);
        
        if ~gui.flag.error
            ig = gui.GB.GrainB;
            sortbvB(:,:,ig) = sortrows(slip_vecB, -14);                         % Sort slip systems by Generalized Schimd factor
            gui.calculations.vectB(:,1:17,ig) = slip_vecB;                      % Matrix with slip systems, Burgers vectors, index of slips for GrainA...
            gui.calculations.vectB(:,18,ig)   = size(slip_systB, 3);
            gui.calculations.vectB(:,19,ig)   = sortbvB(:,14,ig);               % Highest Generalized Schmid Factor
        end
        
        guidata(gcf, gui);
    end
    
    if ~gui.flag.error
        %% m', residual Burgers vector, N-factor, lambda and SF(GB) calculations
        gui = guidata(gcf);
        
        sizeA = gui.calculations.vectA(1,18,gui.GB.GrainA);
        sizeB = gui.calculations.vectB(1,18,gui.GB.GrainB);
        valcase = get(gui.handles.pmchoicecase, 'Value');
        
        switch(valcase)
            case {1, 2, 3, 4, 5, 6, 7, 37} % m prime (Luster and Morris)
                gui.calculations.mprime_val_bc_all = zeros(sizeA, sizeB);
                gui.calculations.mprime_val_bc_all = ...
                    mprime_opt_vectorized(...
                    gui.calculations.vectA(:,1:3,gui.GB.GrainA), ...
                    gui.calculations.vectA(:,4:6,gui.GB.GrainA), ...
                    gui.calculations.vectB(:,1:3,gui.GB.GrainB), ...
                    gui.calculations.vectB(:,4:6,gui.GB.GrainB));
            case {8, 9, 10, 11, 12, 13, 14} % residual Burgers vector
                gui.calculations.residual_Burgers_vector_val_bc_all = ...
                    zeros(sizeA, sizeB);
                for jj = 1:1:gui.calculations.vectB(1,18,gui.GB.GrainB)
                    for kk = 1:1:gui.calculations.vectA(1,18,gui.GB.GrainA)
                        % residual Burgers vector
                        rbv_bc_val(1) = residual_Burgers_vector(...
                            gui.calculations.vectA(kk,7:9,gui.GB.GrainA), ...
                            gui.calculations.vectB(jj,7:9,gui.GB.GrainB));
                        rbv_bc_val(2) = residual_Burgers_vector(...
                            gui.calculations.vectA(kk,10:12,gui.GB.GrainA), ...
                            gui.calculations.vectB(jj,7:9,gui.GB.GrainB));
                        %rbv_bc_val(3) = residual_Burgers_vector(gui.calculations.vectA(kk,7:9,GB.GrainA), gui.calculations.vectB(jj,10:12,GB.GrainB));
                        %rbv_bc_val(4) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,GB.GrainA), gui.calculations.vectB(jj,10:12,GB.GrainB));
                        gui.calculations.residual_Burgers_vector_val_bc_all(kk,jj) = ...
                            min(rbv_bc_val);
                        ind = find(rbv_bc_val == min(min(rbv_bc_val)));
                        
                        % useful for plot of slip direction in the function
                        % 'plotGB_Bicrystal_plot_lattices'
                        gui.flag.flag_dir_vectA = zeros(sizeA, sizeB);
                        gui.flag.flag_dir_vectB = zeros(sizeA, sizeB);
                        if ind == 1
                            gui.flag.flag_dir_vectA(jj,kk) = 0;
                            gui.flag.flag_dir_vectB(jj,kk) = 0;
                        elseif ind == 2
                            gui.flag.flag_dir_vectA(jj,kk) = 1;
                            gui.flag.flag_dir_vectB(jj,kk) = 0;
                            %                     elseif ind == 3
                            %                         flag_dir_gui.calculations.vectA(jj,kk) = 0;
                            %                         flag_dir_gui.calculations.vectB(jj,kk) = 1;
                            %                     elseif ind == 4
                            %                         flag_dir_gui.calculations.vectA(jj,kk) = 1;
                            %                         flag_dir_gui.calculations.vectB(jj,kk) = 1;
                        end
                    end
                end
            case {15, 16, 17, 18, 19, 20, 21} % N factor (Livingston and Chamlers)
                gui.calculations.n_fact_val_bc_all = zeros(sizeA, sizeB);
                gui.calculations.n_fact_val_bc_all = ...
                    N_factor_opt_vectorized(...
                    gui.calculations.vectA(:,1:3,gui.GB.GrainA), ...
                    gui.calculations.vectA(:,4:6,gui.GB.GrainA), ...
                    gui.calculations.vectB(:,1:3,gui.GB.GrainB), ...
                    gui.calculations.vectB(:,4:6,gui.GB.GrainB));
            case {22, 23, 24, 25, 26, 27, 28} % LRB parameter (Shen)
                d_gb(:,1) = (ones(1,size(gui.calculations.vectA, 1)) ...
                    * gui.GB_geometry.d_gb(1))';
                d_gb(:,2) = (ones(1,size(gui.calculations.vectA, 1)) ...
                    * gui.GB_geometry.d_gb(2))';
                d_gb(:,3) = (ones(1,size(gui.calculations.vectA, 1)) ...
                    * gui.GB_geometry.d_gb(3))';
                gui.calculations.LRB_val_bc_all = zeros(sizeA, sizeB);
                gui.calculations.LRB_val_bc_all = ...
                    LRB_parameter_opt_vectorized(...
                    cross(d_gb, ...
                    gui.calculations.vectA(:,4:6,gui.GB.GrainA)), ...
                    gui.calculations.vectA(:,4:6,gui.GB.GrainA), ...
                    cross(d_gb, ...
                    gui.calculations.vectB(:,4:6,gui.GB.GrainB)), ...
                    gui.calculations.vectB(:,4:6,gui.GB.GrainB));
            case {29, 30, 31, 32, 33, 34, 35} % lambda parameter (Werner and Prantl)
                gui.calculations.lambda_val_bc_all = zeros(sizeA, sizeB);
                for jj = 1:1:gui.calculations.vectB(1,18,gui.GB.GrainB)
                    for kk = 1:1:gui.calculations.vectA(1,18,gui.GB.GrainA)
                        gui.calculations.lambda_val_bc_all(kk,jj) = ...
                            lambda(...
                            gui.calculations.vectA(kk,1:3,gui.GB.GrainA), ...
                            gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                            gui.calculations.vectB(jj,1:3,gui.GB.GrainB), ...
                            gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
                    end
                end
        end
        guidata(gcf, gui);
        
        if gui.flag.error == 0
            plotGB_Bicrystal_mprime_calculator_bc(listslipA, listslipB);
        end
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
        %     gui.GB.mprime_val_bc_all = gui.GB.mprime_val_bc_all(kk_B, kk_A);
        %     gui.GB.residual_Burgers_vector_val_bc_all = gui.GB.residual_Burgers_vector_val_bc_all(kk_B, kk_A);
        %     gui.GB.n_fact_val_bc_all = gui.GB.n_fact_val_bc_all(kk_B, kk_A);
        %     gui.GB.LRB_val_bc_all = gui.GB.LRB_val_bc_all(kk_B, kk_A);
        
        gui.flag.error = 0;
    else
        guidata(gcf, gui);
    end
end
guidata(gcf, gui);
end