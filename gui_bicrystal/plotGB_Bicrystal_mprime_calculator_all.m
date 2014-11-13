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

[gui.calculations.vectA, gui.GB.eulerA, gui.GB.sortbvA, gui.flag.error] = ...
    plotGB_Bicrystal_vector_calculations(9, ...
    gui.GB.GrainA, gui.GB.Material_A,...
    gui.GB.Phase_A, gui.GB.eulerA_ori, gui.handles.getEulangGrA,...
    gui.stress_tensor.sigma, gui.flag.error);

[gui.calculations.vectB, gui.GB.eulerB, gui.GB.sortbvB, gui.flag.error] = ...
    plotGB_Bicrystal_vector_calculations(9, ...
    gui.GB.GrainB, gui.GB.Material_B,...
    gui.GB.Phase_B, gui.GB.eulerB_ori, gui.handles.getEulangGrB,...
    gui.stress_tensor.sigma, gui.flag.error);

guidata(gcf, gui);

if gui.flag.error == 0
    %% m', residual Burgers vector, N-factor and SF(GB) calculations
    gui = guidata(gcf);
    
    sizeA = gui.calculations.vectA(1,9,gui.GB.GrainA);
    sizeB = gui.calculations.vectB(1,9,gui.GB.GrainB);
    valcase = get(gui.handles.pmchoicecase, 'Value');
    
    switch(valcase)
        case {1, 2, 3, 4, 5, 6, 7, 30} % m prime (Luster and Morris)
            gui.calculations.mprime_val_bc_all = zeros(sizeA, sizeB);
            for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
                for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
                    gui.calculations.mprime_val_bc_all(jj,kk) = ...
                        mprime(...
                        gui.calculations.vectA(kk,1:3,gui.GB.GrainA), ...
                        gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                        gui.calculations.vectB(jj,1:3,gui.GB.GrainB), ...
                        gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
                end
            end
        case {8, 9, 10, 11, 12, 13, 14} % residual Burgers vector
            gui.calculations.residual_Burgers_vector_val_bc_all = ...
                zeros(sizeA, sizeB);
            for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
                for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
                    % residual Burgers vector
                    rbv_bc_val(1) = residual_Burgers_vector(...
                        gui.calculations.vectA(kk,10:12,gui.GB.GrainA), ...
                        gui.calculations.vectB(jj,10:12,gui.GB.GrainB), ...
                        gui.GB.eulerA, gui.GB.eulerB);
                    rbv_bc_val(2) = residual_Burgers_vector(...
                        gui.calculations.vectA(kk,13:15,gui.GB.GrainA), ...
                        gui.calculations.vectB(jj,10:12,gui.GB.GrainB), ...
                        gui.GB.eulerA, gui.GB.eulerB);
                    %rbv_bc_val(3) = residual_Burgers_vector(gui.calculations.vectA(kk,10:12,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
                    %rbv_bc_val(4) = residual_Burgers_vector(gui.calculations.vectA(kk,13:15,GB.GrainA), gui.calculations.vectB(jj,13:15,GB.GrainB), GB.eulerA, GB.eulerB);
                    gui.calculations.residual_Burgers_vector_val_bc_all(jj,kk) = ...
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
            for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
                for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
                    gui.calculations.n_fact_val_bc_all(jj,kk) = N_factor(...
                        gui.calculations.vectA(kk,1:3,gui.GB.GrainA), ...
                        gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                        gui.calculations.vectB(jj,1:3,gui.GB.GrainB), ...
                        gui.calculations.vectB(jj,4:6,gui.GB.GrainB));
                end
            end
        case {22, 23, 24, 25, 26, 27, 28} % LRB paramter (Shen)
            gui.calculations.LRB_val_bc_all = zeros(sizeA, sizeB);
            for jj = 1:1:gui.calculations.vectB(1,16,gui.GB.GrainB)
                for kk = 1:1:gui.calculations.vectA(1,16,gui.GB.GrainA)
                    gui.calculations.LRB_val_bc_all(jj,kk) = ...
                        LRB_parameter(...
                        cross(gui.GB_geometry.d_gb, ...
                        gui.calculations.vectA(kk,4:6,gui.GB.GrainA)), ...
                        gui.calculations.vectA(kk,4:6,gui.GB.GrainA), ...
                        cross(gui.GB_geometry.d_gb, ...
                        gui.calculations.vectB(jj,4:6,gui.GB.GrainB)), ...
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
end
guidata(gcf, gui);
end
