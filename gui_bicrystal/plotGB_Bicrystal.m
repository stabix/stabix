% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal
%% Function used to generate bicrystal interface
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

%% Initalization
if get(gui.handles.cblegend,'Value') == 1
    set(gui.handles.pmlegend_location, 'Visible', 'on');
else
    set(gui.handles.pmlegend_location, 'Visible', 'off');
end

%% Set of plot type
% Get value of popupmenu to plot m' value (max, min...?)
valcase = get(gui.handles.pmchoicecase, 'Value');

%% Setting of popupmenu
[gui.GB.Phase_A, gui.GB.Phase_B] = plotGB_Bicrystal_get_struct;
[gui.GB.Material_A, gui.GB.Material_B] = plotGB_Bicrystal_get_material;

listSlipsA = listSlipSystems(gui.GB.Phase_A);
listSlipsB = listSlipSystems(gui.GB.Phase_B);
set(gui.handles.pmlistslipsA, 'String', listSlipsA, ...
    'max', size(listSlipsA,1));
set(gui.handles.pmlistslipsB, 'String', listSlipsB, ...
    'max', size(listSlipsB,1));
guidata(gcf, gui);

%% Setting of slip/twin systems for m' calculation
[listslipA, listslipB, no_slip] = plotGB_Bicrystal_listslips;

%% Update of Euler angles
gui.GB.eulerA = plotGB_Bicrystal_update_euler(gui.GB.eulerA_ori, ...
    gui.handles.getEulangGrA);
gui.GB.eulerB = plotGB_Bicrystal_update_euler(gui.GB.eulerB_ori, ...
    gui.handles.getEulangGrB);

%% Get stress tensor from map interface
gui.stress_tensor = get_stress_tensor(gui.handles.stress_tensor);

%% Store old view settings
if isfield(gui.handles, 'h_gbax')
    set(gcf, 'CurrentAxes', subplot(4,2,[3 6]));
    [old_az, old_el] = view;
else
    old_az = 45; % old azimuth value
    old_el = 45; % old elevation value
end

%% Initialization of bicrystal plot
gui.handles.h_gbax = subplot(4,2,[3 6], 'replace');
axis off;

%% GB Trace calculation / plot
set_default_values_txtbox (gui.handles.getGBtrace, gui.GB.GB_Trace_Angle);
gui.GB.GB_Trace_Angle = ...
    mod(str2double(get(gui.handles.getGBtrace, 'string')), 360);

% GB trace
set(gui.handles.getGBtrace, 'String', ...
    sprintf('%.1f', gui.GB.GB_Trace_Angle)); guidata(gcf, gui);
[gui.GB_geometry.gb_vec_norm, gui.GB_geometry.gb_vec, ...
    gui.GB_geometry.GB_arrow] = ...
    plotGB_Bicrystal_GB_trace(gui.GB.GB_Trace_Angle);
gui.handles.h_gbax = subplot(4,2,[3 6], 'replace');

try
    arrow(gui.GB_geometry.GB_arrow(:,1), gui.GB_geometry.GB_arrow(:,2), ...
        0, 'Length', 100, 'FaceColor', 'k', 'TipAngle', 15);
catch err
    warning_commwin(err.message);
end

% Surface plane
gui.GB_geometry.perp_gb = cross([0;0;1], gui.GB_geometry.gb_vec_norm);
gui.GB_geometry.surf_plane(:,1) = ...
    -gui.GB_geometry.gb_vec_norm - 3*gui.GB_geometry.perp_gb;
gui.GB_geometry.surf_plane(:,2) = ...
    -gui.GB_geometry.gb_vec_norm + 3*gui.GB_geometry.perp_gb;
gui.GB_geometry.surf_plane(:,3) = ...
    gui.GB_geometry.gb_vec_norm - 3*gui.GB_geometry.perp_gb;
gui.GB_geometry.surf_plane(:,4) = ...
    gui.GB_geometry.gb_vec_norm + 3*gui.GB_geometry.perp_gb;
gui.handles.h_GBsurf = patch('Vertices', gui.GB_geometry.surf_plane', ...
    'Faces', [1 3 4 2], 'FaceColor', 'b', 'FaceAlpha', 0.02);

%% GB Inclination calculation / plot GB inclined plane
set_default_values_txtbox(gui.handles.getGBinclination, ...
    gui.GB.GB_Inclination);
gui.GB.GB_Inclination = mod(str2double(get(gui.handles.getGBinclination, ...
    'String')), 180);
set(gui.handles.getGBinclination, ...
    'String', sprintf('%.1f', gui.GB.GB_Inclination));
gui.GB_geometry.GB_inclined = ...
    plot_inclined_GB_plane([0;0;0], [0;0;0], ...
    gui.GB.GB_Trace_Angle, gui.GB.GB_Inclination);
% Get the direction of the GB (for LRB paramter)
gui.GB_geometry.d_gb = gui.GB_geometry.GB_inclined(:,3) ...
    - gui.GB_geometry.GB_inclined(:,1);
patch('Vertices', gui.GB_geometry.GB_inclined', ...
    'Faces', [1 3 4 2], 'FaceColor', 'k', 'FaceAlpha', 0.4);

%% Encapsulation of data
guidata(gcf, gui);

%% m' and RBV calculations
if ~no_slip
    plotGB_Bicrystal_mprime_calculator_all(listslipA, listslipB);
    gui = guidata(gcf); guidata(gcf, gui);
end

if ~gui.flag.error
    %% Misorientation calculation
    if strcmp(gui.GB.Phase_A, gui.GB.Phase_B) == 1
        if gui.flag.installation_mtex == 1
            gui.GB.orientation_grA = ...
                MTEX_setOrientation(gui.GB.Phase_A, ...
                gui.GB.ca_ratio_A(1), gui.GB.eulerA); guidata(gcf, gui);
            
            gui.GB.orientation_grB = ...
                MTEX_setOrientation(gui.GB.Phase_B, ...
                gui.GB.ca_ratio_B(1), gui.GB.eulerB); guidata(gcf, gui);
            
            gui.GB.misorientation  = ...
                MTEX_getBX_misorientation(gui.GB.orientation_grB, ...
                gui.GB.orientation_grA); guidata(gcf, gui);
            
        elseif gui.flag.installation_mtex == 0
            gui.GB.misorientation  = ...
                misorientation(gui.GB.eulerA, gui.GB.eulerB, ...
                gui.GB.Phase_A, gui.GB.Phase_B); guidata(gcf, gui);
        end
    else
        gui.GB.misorientation = NaN;
    end
    
    %% Misorientation calculation
    if strcmp(gui.GB.Phase_A, 'hcp') == 1 ...
            && strcmp(gui.GB.Phase_B, 'hcp') == 1
        gui.GB.caxis_misor = eul2Caxismisor(gui.GB.eulerA, gui.GB.eulerB);
    else
        gui.GB.caxis_misor = NaN;
    end
    guidata(gcf, gui);
    
    %% Update slips from popupmenu and definition of slips A and B
    [slipA, slipB] = plotGB_Bicrystal_update_slip(no_slip);
    gui.GB.slipA = slipA;
    gui.GB.slipB = slipB;
    
    %% m' and RBV calculations for specific slips given by user for grains A and B
    if valcase == size(get(gui.handles.pmchoicecase, 'String'), 1)
        gui.GB.mprime_specific = ...
            gui.calculations.mprime_val_bc(slipA, slipB);
        
        gui.GB.rbv_specific = ...
            gui.calculations.residual_Burgers_vector_val_bc(slipA, slipB);
        
        gui.GB.nfact_specific = ...
            gui.calculations.n_fact_val_bc(slipA, slipB);
        
        gui.GB.LRBfact_specific = ...
            gui.calculations.LRB_val_bc(slipA, slipB);
    end
    guidata(gcf, gui);
    
    %% Plot unit cells and circles
    [shiftXYZA, shiftXYZB] = ...
        plotGB_Bicrystal_plot_lattices(slipA, slipB, no_slip);
    
    %% Plot slip traces
    if get(gui.handles.cbsliptraces, 'Value') == 1
        shiftXYZ_A = (1.5 * gui.GB_geometry.perp_gb) + [0;0;0];
        shiftXYZ_B = -((1.5 * gui.GB_geometry.perp_gb) + [0;0;0]);
        plot_slip_traces(slipA, gui.GB.eulerA, gui.GB.Phase_A, ...
            gui.GB.ca_ratio_A(1), shiftXYZ_A, 2, 0.5);
        plot_slip_traces(slipB, gui.GB.eulerB, gui.GB.Phase_B, ...
            gui.GB.ca_ratio_B(1), shiftXYZ_B, 2, 0.5);
    end
    
    %% Plot options
    plotGB_Bicrystal_gbax_title_and_text(no_slip, shiftXYZA, shiftXYZB);
    triad_lines;
    axis off;
    axis tight;
    view(old_az, old_el);
    
    %% Plotting of slip transmission parameter map
    if ~no_slip
        subplot(4, 2, [7 8], 'Position', [0.25, 0, 0.65, 0.2]);
        axis fill;
        
        switch(valcase)
            case {1, 2, 3, 7, 30}
                param2plot =  gui.calculations.mprime_val_bc_all;
                param2plot_title = 'm_prime';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,2);
                handle_title = title('Maximum m'' values');
            case {4, 5, 6}
                param2plot =  gui.calculations.mprime_val_bc_all;
                param2plot_title = 'm_prime';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,1);
                handle_title = title('Minimum m'' values');
            case {8, 9, 10, 14}
                param2plot = ...
                    gui.calculations.residual_Burgers_vector_val_bc_all;
                param2plot_title = 'Residual Burgers Vector';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,2);
                handle_title = ...
                    title('Maximum residual Burgers vector values');
            case {11, 12, 13}
                param2plot = ...
                    gui.calculations.residual_Burgers_vector_val_bc_all;
                param2plot_title = 'Residual Burgers Vector';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,1);
                handle_title = ...
                    title('Minimum residual Burgers vector values');
            case {15, 16, 17, 21}
                param2plot = gui.calculations.n_fact_val_bc_all;
                param2plot_title = 'N_factor';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,2);
                handle_title = title('Maximum N-factor values');
            case {18, 19, 20}
                param2plot = gui.calculations.n_fact_val_bc_all;
                param2plot_title = 'N_factor';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,1);
                handle_title = title('Minimum N-factor values');
            case {22, 23, 24, 28}
                param2plot = gui.calculations.LRB_val_bc_all;
                param2plot_title = 'LRB_parameter';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,2);
                handle_title = title('Maximum LRB paramter values');
            case {25, 26, 27}
                param2plot = gui.calculations.LRB_val_bc_all;
                param2plot_title = 'LRB_parameter';
                plotGB_Bicrystal_min_max_param_map_plot(param2plot,1);
                handle_title = title('Minimum LRB paramter values');
            case {29}
                param2plot = gui.calculations.GB_Schmid_Factor_max;
                param2plot_title = 'GB Schmid factor';
                subplot(4,2,7, 'replace');
                axis off;
                handle_title = title('No parameter to plot');
                subplot(4,2,8, 'replace');
                axis off;
        end
        set(handle_title, 'color', [0 0 0],'BackgroundColor', [1 1 1]);
    else
        subplot(4,2,7, 'replace');
        axis off;
        subplot(4,2,8, 'replace');
        axis off;
    end
    gui.GB.param2plot = param2plot;
    gui.GB.param2plot_title = param2plot_title;
    guidata(gcf, gui);
    
end

end