% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_mprime_calculator_map
%% Function used to calculate m' parameter values for all GBs
% Grain File Type 2
% # Column 1: Integer identifying grain
% # Column 2-4: Average orientation (phi1, PHI, phi2) in degrees
% # Column 5-6: Average Position (x, y) in microns
% # Column 7: Average Image Quality (IQ)
% # Column 8: Average Confidence Index (CI)
% # Column 9: Average Fit (degrees)
% # Column 10: An integer identifying the phase ==> 0 -  Titanium (Alpha)
% # Column 11: Edge grain (1) or interior grain (0)
% # Column 12: Diameter of grain in microns

% Reconstructed Boundary file                                                                 x axis or TD Direction (Transverse)
% # Column 1-3:    right hand average orientation (Bunge = phi1, PHI, phi2 in radians)       ---->
% # Column 4-6:    left hand average orientation (Bunge = phi1, PHI, phi2 in radians)      y |
% # Column 7:      length (in microns)                                                 or RD |
% # Column 8:      trace angle (in degrees)                                        Reference v
% In column 8, e.g. 0° = GB horizontal(// to x-axis) & 90° = GB vertical (// to y-axis)
% # Column 9-12:   x,y coordinates of endpoints (in microns)
% # Column 13-14:  IDs of right hand and left hand grains (!!! No always true !!!!)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de / bieler@egr.msu.edu

%% Get data from the GUI
gui = guidata(gcf);

grains  = gui.grains;
flag    = gui.flag;
grcen   = gui.grcen;
GBs     = gui.GBs;
GF2     = gui.GF2_struct.data_smoothed;
RB      = gui.RB_struct.data_smoothed;
Results = struct();

%% Initialization
numphase = str2double(get(gui.handles.NumPh,'String'));
guidata(gcf, gui);

%% Settings of Phase Number, Materials, Structures, Slip and Twin Systems to consider for calculations
% Preallocation
lattice_parameters = zeros(max(GF2(:,1)), 3, 1);

%% Waitbar
h_waitbar = waitbar(0, 'Calculating GB properties ...');                   % changing the waitbar color is not trivial, http://stackoverflow.com/questions/5368861/how-to-add-progress-bar-control-to-matlab-gui

if gui.config_data.slips_1 == 0 | gui.config_data.slips_2 == 0
    helpdlg(['Please, select at least 1 (or 2 for a two phases '...
        'material) slip systems family for calculations...']);
    delete(h_waitbar);
    
else
    %% Set slip systems
    if numphase == 1
        [slip_syst_1, slip_check_1] = ...
            slip_systems(gui.config_data.struct1, ...
            gui.config_data.slips_1);
        slip_check_2 = 1;
        slip_syst_2 = slip_syst_1;
    elseif numphase == 2
        [slip_syst_1, slip_check_1] = ...
            slip_systems(gui.config_data.struct1, ...
            gui.config_data.slips_1);
        [slip_syst_2, slip_check_2] = ...
            slip_systems(gui.config_data.struct2, ...
            gui.config_data.slips_2);
    end
    
    [size_max_slip_sys, slip_syst_1, slip_syst_2] = ...
        check_size_slipsystem(slip_syst_1, slip_syst_2);
    
    if isempty(find(slip_check_1==0)) && isempty(find(slip_check_2==0)) % Check orthogonality
        %% Start calculations...
        if flag.pmparam2plot_value4GB ~= 7 ...
                || flag.pmparam2plot_value4GB ~= 8
            % Loop to set grains properties (identity, Euler angles, position)
            vect = zeros(size_max_slip_sys,21,max(GF2(:,1)));
            
            for ig = 1:max(GF2(:,1))
                if size(grains(ig).ID) > 0
                    % basic operations (not involving slip) are now
                    % in interface_map_init_microstructure
                    
                    % Calculation of the lattice parameters and c/a ratio for each grain
                    lattice_parameters(ig,:) = latt_param(...
                        grains(ig).material, ...
                        grains(ig).structure);
                    
                    % Variable 'grcen' defined in "interface_map_init_microstructure.m"
                    euler = grcen(ig, 4:6);
                    g                = eulers2g(euler);
                    grcen(ig, 7:9)   = g.'*[0 0 1].';                          % C-axis direction
                    grcen(ig, 10:18) = [g(1,:) g(2,:) g(3,:)];                 % Orientation matrix is stored
                    
                    if numphase == 1
                        slip_syst = slip_syst_1;
                    elseif numphase == 2
                        if strcmp(grains(ig).structure, ...
                                gui.config_data.struct1)
                            slip_syst = slip_syst_1;
                        elseif strcmp(grains(ig).structure, ...
                                gui.config_data.struct2)
                            slip_syst = slip_syst_2;
                        end
                    end
                    
                    [slip_vec, flag_error] = ...
                        vector_calculations(ig, grains(ig).material, ...
                        grains(ig).structure, euler, ...
                        slip_syst, gui.stressTensor, 0);
                    
                    if flag_error
                        flag.flag_lattice = 0;
                    end
                    
                    sortbv_SF(:,:) = sortrows(slip_vec,-14);                     % Sort slip systems by highest Schmid factor
                    sortbv_RSS(:,:) = sortrows(slip_vec,-16);                    % Sort slip systems by highest resolved shear stress
                    
                    vect(:,1:17,ig) = slip_vec;                                  % n & b vectors for each slip system and each grain
                    vect(:,18,ig)   = size(slip_syst,3);
                    vect(:,19,ig)   = sortbv_SF(:,17);                     % Index of slip with highest Schmid factor
                    vect(:,20,ig)   = sortbv_RSS(:,17);                    % Index of slip with highest resolved shear stress
                    vect(:,21,ig)   = sortbv_SF(:,14);                     % Highest Schmid factor
                end
            end
        end
    else
        flag.flag_lattice = 0;
        delete(h_waitbar);
        errordlg(['Slip direction and slip normal', ...
            'vectors are not orthogonals !!!']);
    end
    
    if flag.flag_lattice
        %%  Now start processing by grain boundary...
        mprime_val = zeros(size(slip_systems,3), ...
            size(slip_systems,3));
        res_Burgers_vector_val = zeros(size(slip_systems,3), ...
            size(slip_systems,3));
        n_factor_val = zeros(size(slip_systems,3), ...
            size(slip_systems,3));
        lambda_val = zeros(size(slip_systems,3), ...
            size(slip_systems,3)); 
        
        for gbnum = 1:size(RB,1)
            clearvars mprime_val rbv_bc_val res_Burgers_vector_val;
            waitbar(gbnum/size(RB,1), h_waitbar);
            
            GBs(gbnum).phgrA = grains(GBs(gbnum).grainA).phase;
            GBs(gbnum).phgrB = grains(GBs(gbnum).grainB).phase;
            grA   = GBs(gbnum).grainA;
            grB   = GBs(gbnum).grainB;
            phgrA = grains(GBs(gbnum).grainA).phase;
            phgrB = grains(GBs(gbnum).grainB).phase;
            
            %% Calculation of functions ==> Build table of functions values for each grain pair
            % Matrix ==> columns = GrA / row = GrB
            
            if gui.config_data.slips_1(1) >= 1 ...
                    && gui.config_data.slips_2(1) >= 1
                
                %% Slip transmission functions for a 1 phase material
                if numphase == 1 || numphase == 2
                    % mprime
                    if flag.pmparam2plot_value4GB ~= 1 ...
                            && flag.pmparam2plot_value4GB < 8
                        % Vectorized form
                        mprime_val = mprime_opt_vectorized(...
                            vect(:,1:3,grA), vect(:,4:6,grA),...
                            vect(:,1:3,grB), vect(:,4:6,grB));
                        
                        flag.CalculationFlag = 1;
                        
                        % Residual Burgers vector
                    elseif flag.pmparam2plot_value4GB == 10 ...
                            || flag.pmparam2plot_value4GB == 11
                        for jj = 1:1:vect(1,18,grB)
                            for kk = 1:1:vect(1,18,grA)
                                if ~isnan(vect(kk,7:9,grA))
                                    rbv_bc_val(1) = residual_Burgers_vector(...
                                        vect(kk,7:9,grA), vect(jj,7:9,grB));
                                    rbv_bc_val(2) = residual_Burgers_vector(...
                                        vect(kk,10:12,grA), vect(jj,7:9,grB));
                                    
                                    res_Burgers_vector_val(kk, jj) = ...
                                        min(rbv_bc_val);
                                else
                                    res_Burgers_vector_val(kk, jj) = NaN;
                                end
                            end
                        end
                        
                        flag.CalculationFlag = 2;
                        
                        % N-factor
                    elseif flag.pmparam2plot_value4GB == 12 ...
                            || flag.pmparam2plot_value4GB == 13
                        % Vectorized form
                        n_factor_val = N_factor_opt_vectorized(...
                            vect(:,1:3,grA), vect(:,4:6,grA),...
                            vect(:,1:3,grB), vect(:,4:6,grB));
                        
                        flag.CalculationFlag = 3;
                        
                    elseif flag.pmparam2plot_value4GB == 14 ...
                            || flag.pmparam2plot_value4GB == 15
                        for jj = 1:1:vect(1,18,grB)
                            for kk = 1:1:vect(1,18,grA)
                                lambda_val(kk, jj) = lambda(...
                                    vect(kk,1:3,grA), vect(kk,4:6,grA),...
                                    vect(jj,1:3,grB), vect(jj,4:6,grB));
                            end
                        end
                        flag.CalculationFlag = 4;
                        
                        % GB Schmid factor
                    elseif flag.pmparam2plot_value4GB == 16
                        Results(gbnum).gb_schmid_factor = ...
                            vect(:,21,grA) + vect(:,21,grB);
                        flag.CalculationFlag = 5;
                        
                    end
                    
                    %% Slip transmission functions for a 2 phases material
                else
                    warning_commwin(['Could not calculate slip ', ...
                        'transmission parameter ' ...
                        'for GB n° %i !'], gbnum);
                end
                
                %% Calculation of the misorientation
                if flag.pmparam2plot_value4GB == 8
                    if grains(grA).structure == grains(grB).structure
                        if flag.installation_mtex == 1
                            origrA = ...
                                mtex_setOrientation(...
                                grains(grA).structure, ...
                                lattice_parameters(grA,1), ...
                                grcen(grA,4:6));
                            origrB = ...
                                mtex_setOrientation(...
                                grains(grB).structure, ...
                                lattice_parameters(grB,1), ...
                                grcen(grB,4:6));
                            Results(gbnum).misor = ...
                                mtex_getBX_misorientation(...
                                origrA,origrB);
                            
                        elseif flag.installation_mtex == 0
                            Results(gbnum).misor  = ...
                                misorientation(...
                                grcen(grA,4:6), grcen(grB,4:6), ...
                                grains(grA).structure, ...
                                grains(grB).structure) ;
                        end
                    else
                        Results(gbnum).misor = NaN ;
                    end
                    flag.CalculationFlag = 6;
                end
                
                %% Calculation of the c-axis misorientation
                if flag.pmparam2plot_value4GB == 9
                    if strcmp(grains(grA).structure, 'hcp') == 1 ...
                            && strcmp(grains(grB).structure, 'hcp') == 1
                        Results(gbnum).caxis_misor = eul2Caxismisor(...
                            grcen(grA,4:6), grcen(grB,4:6)) ;
                    else
                        Results(gbnum).caxis_misor = NaN ;
                    end
                    flag.CalculationFlag = 6;
                end
                
                %% Calculation of new function's values
                if flag.pmparam2plot_value4GB == 17
                    Results(gbnum).oth_func_val = ...
                        Other_Function(vect(:,:,grA), vect(:,:,grB), ...
                        grcen(grA,10:18),grcen(grB,10:18), ...
                        grA, grB, phgrA, phgrB, RB(8));
                    flag.CalculationFlag = 7;
                end
                
                %% Get max/min values and slip indices of mprime or RBV
                % Matrix ==> columns = GrA / row = GrB
                
                if flag.CalculationFlag == 1 % mprime
                    % Sort mprime
                    Results(gbnum).mp_min = min(min(abs(mprime_val)));
                    [Results(gbnum).mp_min_slipA, ...
                        Results(gbnum).mp_min_slipB] ...
                        = find(abs(mprime_val) <= Results(gbnum).mp_min);
                    
                    Results(gbnum).mp_max = max(max(abs(mprime_val)));
                    [Results(gbnum).mp_max_slipA, ...
                        Results(gbnum).mp_max_slipB] ...
                        = find(abs(mprime_val) >= Results(gbnum).mp_max);
                    
                    % Storing of m' value calulated with slips with highest Generalized Schmid factor
                    Results(gbnum).mp_SFmax_slipA = vect(1,19,grA);                               % index of slip with highest Schmid factor
                    Results(gbnum).mp_SFmax_slipB = vect(1,19,grB);                               % index of slip with highest Schmid factor
                    Results(gbnum).mp_SFmax = abs(mprime_val(...
                        Results(gbnum).mp_SFmax_slipA, ...
                        Results(gbnum).mp_SFmax_slipB));
                    
                    % Storing of m' value calulated with slips with highest resolved shear stress
                    Results(gbnum).mp_RSSmax_slipA = vect(1,20,grA);                               % index of slip with highest resolved shear stress
                    Results(gbnum).mp_RSSmax_slipB = vect(1,20,grB);                               % index of slip with highest resolved shear stress
                    Results(gbnum).mp_RSSmax = abs(mprime_val(...
                        Results(gbnum).mp_RSSmax_slipA, ...
                        Results(gbnum).mp_RSSmax_slipB));
                    
                elseif flag.CalculationFlag == 2 % Residual Burgers vector
                    % Sort Residual Burgers Vector
                    Results(gbnum).rbv_min = ...
                        min(min(abs(res_Burgers_vector_val)));
                    
                    [Results(gbnum).rbv_min_slipA, ...
                        Results(gbnum).rbv_min_slipB] = ...
                        find(abs(res_Burgers_vector_val) ...
                        <= Results(gbnum).rbv_min);
                    
                    Results(gbnum).rbv_max = ...
                        max(max(abs(res_Burgers_vector_val)));
                    
                    [Results(gbnum).rbv_max_slipA, ...
                        Results(gbnum).rbv_max_slipB] = ...
                        find(abs(res_Burgers_vector_val) ...
                        >= Results(gbnum).rbv_max);
                    
                elseif flag.CalculationFlag == 3 % N-factor
                    % Sort N-factor
                    Results(gbnum).n_factor_min ...
                        = min(min(abs(n_factor_val)));
                    
                    [Results(gbnum).n_factor_min_slipA, ...
                        Results(gbnum).n_factor_min_slipB] = ...
                        find(abs(n_factor_val) ...
                        <= Results(gbnum).n_factor_min);
                    
                    Results(gbnum).n_factor_max ...
                        = max(max(abs(n_factor_val)));
                    
                    [Results(gbnum).n_factor_max_slipA, ...
                        Results(gbnum).n_factor_max_slipB] = ...
                        find(abs(n_factor_val) ...
                        >= Results(gbnum).n_factor_max);
                    
                elseif flag.CalculationFlag == 4 % lambda
                    % Sort lambda
                    Results(gbnum).lambda_min ...
                        = min(min(abs(lambda_val)));
                    
                    [Results(gbnum).lambda_min_slipA, ...
                        Results(gbnum).lambda_min_slipB] = ...
                        find(abs(lambda_val) ...
                        <= Results(gbnum).lambda_min);
                    
                    Results(gbnum).lambda_max ...
                        = max(max(abs(lambda_val)));
                    
                    [Results(gbnum).lambda_max_slipA, ...
                        Results(gbnum).lambda_max_slipB] = ...
                        find(abs(lambda_val) ...
                        >= Results(gbnum).lambda_max);
                    
                end
            end
        end
        delete(h_waitbar);
    end
end

if flag.flag_lattice
    gui.grains    = grains;
    gui.flag      = flag;
    gui.grcen     = grcen;
    gui.results   = Results;
    gui.calculations.vect  = vect;
end
guidata(gcf, gui);

end