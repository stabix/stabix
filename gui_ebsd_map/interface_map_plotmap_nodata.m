% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function szFac = interface_map_plotmap_nodata
%% Function to plot lattice cells, grains numbers, GBs number, phase...etc.on the map
% for all GBs and all grains

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
gui = guidata(gcf);
GF2             = gui.GF2_struct.data_smoothed;
RB              = gui.RB_struct.data_smoothed;
GBs             = gui.GBs;
grcen           = gui.grcen;
COORDSYS_eulers = gui.COORDSYS_eulers;

%% Setting of axis
% Axis limits
maxx = max(GF2(:,5));
maxy = max(GF2(:,6));

% Number of phase
numphase = str2double(get(gui.handles.NumPh,'String'));

%% Size of unit cell
scale_unitcell_val = get(gui.handles.scale_unitcell_bar, 'Value'); % value from the scale bar
if (((maxy*maxx)/size(GF2,1))/(maxy*maxx)) < 0.025
    szFac = ((maxy*maxx)/size(GF2,1))/((maxy+maxx)/2)*5 * scale_unitcell_val;
else
    szFac = ((maxy*maxx)/size(GF2,1))/((maxy+maxx)/2)*0.5 * scale_unitcell_val;
end

%% Plot Grain numbers
if get(gui.handles.cbgrnum, 'Value') == 1
    for ng = 1:1:max(GF2(:,1))
        gui.handles.h_grain_txt = text(grcen(ng,2), grcen(ng,3), 3 * szFac, int2str(ng));
        set(gui.handles.h_grain_txt, 'Color', [0,0,0], 'FontWeight', 'bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Clipping', 'on', 'BackgroundColor', 'none');
    end
end

%% Plot Phase
if get(gui.handles.cbphase, 'Value') == 1 && get(gui.handles.cbunitcell, 'Value') ~= 1
    for ng = 1:1:max(GF2(:,1))
        if grcen(ng,1) == 0
        else
            if grcen(ng,1) == 1
                gui.handles.h_phase_txt(ng) = text(grcen(ng,2)-0.025*maxx, grcen(ng,3)-0.025*maxx, int2str(grcen(ng,1)),'Color','g', 'BackgroundColor', 'none'); %Green
            elseif grcen(ng,1) == 2
                gui.handles.h_phase_txt(ng) = text(grcen(ng,2)-0.025*maxy, grcen(ng,3)-0.025*maxy, int2str(grcen(ng,1)),'Color','r', 'BackgroundColor', 'none'); %Red
            end
        end
    end
    set(gui.handles.h_phase_txt, 'FontWeight', 'bold');
end

%% Legend of phases
% Legend for phases (Alternative solution)
% try
%     delete(gui.handles.LegendPhaseAxis);
% catch
% end
% gui.handles.LegendPhaseAxis = axes('Position', [0.18 0.385 0.1 0.08]);
% view([0,0,1]);
% 
% if numphase == 1
%     gui.handles.h_phase_line = plot(0,0, '-g');
%     set(gui.handles.h_phase_line, 'Linewidth', 5);
%     legend(gui.handles.h_phase_line, ['Phase=', gui.config_data.material1, '/', gui.config_data.struct1]);
% elseif numphase == 2
%     gui.handles.h_phase_line = plot(0,0, '-g', 0,0,'-r');
%     set(gui.handles.h_phase_line, 'Linewidth', 5);
%     legend(gui.handles.h_phase_line, ['Phase1=', gui.config_data.material1, '/', gui.config_data.struct1], ['Phase2=', gui.config_data.material2, '/', gui.config_data.struct2]);
% end
% axis off;
% 
% if get(gui.handles.cbphase, 'Value') ~= 1
%     delete(gui.handles.LegendPhaseAxis);
% end
% set(gcf, 'CurrentAxes', gui.handles.AxisGBmap);

if get(gui.handles.cbphase, 'Value') == 1
    set(gui.handles.Mat1, 'BackgroundColor', 'g');
    set(gui.handles.Struct1, 'BackgroundColor', 'g');
    set(gui.handles.Mat2, 'BackgroundColor', 'r');
    set(gui.handles.Struct2, 'BackgroundColor', 'r');
else
    set(gui.handles.Mat1, 'BackgroundColor', [0.9,0.9,0.9]);
    set(gui.handles.Struct1, 'BackgroundColor', [0.9,0.9,0.9]);
    set(gui.handles.Mat2, 'BackgroundColor', [0.9,0.9,0.9]);
    set(gui.handles.Struct2, 'BackgroundColor', [0.9,0.9,0.9]);
end
guidata(gcf, gui);

%% Plot GB numbers
if get(gui.handles.cbgbnum, 'Value') == 1
    gui.handles.h_gbnum = zeros(size(RB,1), 'double'); % Preallocation
    for gbnum = 1:1:size(RB,1)
        x_mp           = mean([GBs(gbnum).pos_x1; GBs(gbnum).pos_x2]);
        y_mp           = mean([GBs(gbnum).pos_y1; GBs(gbnum).pos_y2]);
        gui.handles.h_gbnum(gbnum) = text(x_mp, y_mp, 3 * szFac, sprintf('%i',gbnum), 'Color', [.5 0 0], 'FontWeight', 'bold');
        set(gui.handles.h_gbnum(gbnum), 'HorizontalAlignment', 'Right', 'VerticalAlignment', 'bottom', 'Clipping', 'on', 'BackgroundColor', 'none');
    end
end

%% Plot lattice unit cells
for ng = 1:1:max(GF2(:,1))
    if grcen(ng,1) == 0
    else
        if grcen(ng,1) == 1
            structure_A = gui.config_data.struct1;
        elseif grcen(ng,1) == 2
            structure_A = gui.config_data.struct2;
        end
        eulers_A     = [grcen(ng,4) grcen(ng,5) grcen(ng,6)];
        eulers_vis_A = coordinate_system_apply(eulers_A, gui.COORDSYS_eulers);
        if ~isempty(gui.grains(ng).material) && ~isempty(gui.grains(ng).structure)
            ca_ratio_A   = latt_param(gui.grains(ng).material, gui.grains(ng).structure);
        else
            ca_ratio_A = [];
        end
        
        % Definition of slip to plot
        if gui.flag.pmparam2plot_value4Grains == 2 || gui.flag.pmparam2plot_value4Grains == 4 % Slip with highest Schmid factor
            if numphase == 1
                slip = gui.calculations.vect(1,19,ng);
            elseif numphase == 2 && grcen(ng,1) == 1
                slip = gui.calculations.vect1(1,19,ng);
            elseif numphase == 2 && grcen(ng,1) == 2
                slip = gui.calculations.vect2(1,19,ng);
            end
        elseif gui.flag.pmparam2plot_value4Grains == 3 % Slip with highest resolved shear stress
            if numphase == 1
                slip = gui.calculations.vect(1,20,ng);
            elseif numphase == 2 && grcen(ng,1) == 1
                slip = gui.calculations.vect1(1,20,ng);
            elseif numphase == 2 && grcen(ng,1) == 2
                slip = gui.calculations.vect2(1,20,ng);
            end
        else
            slip = 0;
        end
        
        if isnan(slip) == 1
            slip = 0;
        end
        
        if get(gui.handles.cbsliptraces, 'Value') == 1 || gui.flag.pmparam2plot_value4Grains == 4
            shiftxyz = [grcen(ng,2) grcen(ng,3) -1*szFac]; % Set the z position of unit cells below the surface when slip traces are plotted
            shiftxyz_slip_trace = [grcen(ng,2) grcen(ng,3) 0];
        else
            shiftxyz = [grcen(ng,2) grcen(ng,3) szFac];
            shiftxyz_slip_trace = [grcen(ng,2) grcen(ng,3) 0];
        end
        
        if gui.flag.pmparam2plot_value4Grains == 1 && get(gui.handles.cbunitcell, 'Value') == 1
            if get(gui.handles.cbphase, 'Value') == 1
                vis_lattice(structure_A, eulers_vis_A, slip, shiftxyz, szFac, 0,1, grcen(ng,1));
            else
                vis_lattice(structure_A, eulers_vis_A, slip, shiftxyz, szFac, 0,1);
            end
        elseif gui.flag.pmparam2plot_value4Grains == 2 || gui.flag.pmparam2plot_value4Grains == 3
            set(gui.handles.cbunitcell, 'Value', 1);
            if get(gui.handles.cbphase, 'Value') == 1
                vis_lattice(structure_A, eulers_vis_A, slip, shiftxyz, szFac, 0,1, grcen(ng,1));
            else
                vis_lattice(structure_A, eulers_vis_A, slip, shiftxyz, szFac, 0,1);
            end
        end
    end
    
    %% Plot slip traces on grain center
    if gui.flag.pmparam2plot_value4Grains == 4
        if get(gui.handles.cbunitcell, 'Value') == 1
            vis_lattice(structure_A, eulers_vis_A, 0, shiftxyz, szFac, 0,1);
        end
        plot_slip_traces(slip, eulers_vis_A, structure_A, ca_ratio_A(1), shiftxyz_slip_trace', szFac*2, 0.5);
    end
end

%% Plot slip traces on GB
if gui.flag.pmparam2plot_value4GB ~= 1
    if get(gui.handles.cbsliptraces, 'Value') == 1
        for gbnum = 1:1:size(RB,1)
            x_mp = mean([GBs(gbnum).pos_x1; GBs(gbnum).pos_x2]);
            y_mp = mean([GBs(gbnum).pos_y1; GBs(gbnum).pos_y2]);
            x_mp_delta = max(gui.GF2_struct.data_smoothed(:,5));
            y_mp_delta = max(gui.GF2_struct.data_smoothed(:,6));
            if gui.grains(gui.GBs(gbnum).grainA).pos_x < gui.grains(gui.GBs(gbnum).grainB).pos_x
                shiftxyz_gb_grA = [x_mp + 2*x_mp_delta/size(RB,1); y_mp - 2*y_mp_delta/size(RB,1); 0];
                shiftxyz_gb_grB = [x_mp - 2*x_mp_delta/size(RB,1); y_mp + 2*y_mp_delta/size(RB,1); 0];
            elseif gui.grains(gui.GBs(gbnum).grainA).pos_x > gui.grains(gui.GBs(gbnum).grainB).pos_x
                shiftxyz_gb_grA = [x_mp + 2*x_mp_delta/size(RB,1); y_mp + 2*y_mp_delta/size(RB,1); 0];
                shiftxyz_gb_grB = [x_mp - 2*x_mp_delta/size(RB,1); y_mp - 2*y_mp_delta/size(RB,1); 0];
            end
            
            % On grain A
            if grcen(gui.GBs(gbnum).grainA,1) == 1
                structure_A = gui.config_data.struct1;
            elseif grcen(gui.GBs(gbnum).grainA,1) == 2
                structure_A = gui.config_data.struct2;
            end
            ca_ratio_A   = latt_param(gui.grains(gui.GBs(gbnum).grainA).material, gui.grains(gui.GBs(gbnum).grainA).structure);
            eulers_A     = [grcen(gui.GBs(gbnum).grainA,4) grcen(gui.GBs(gbnum).grainA,5) grcen(gui.GBs(gbnum).grainA,6)];
            eulers_vis_A = coordinate_system_apply(eulers_A, gui.COORDSYS_eulers);
            % Definition of slip to plot
            if gui.flag.pmparam2plot_value4GB == 2 || gui.flag.pmparam2plot_value4GB == 6
                slipA = gui.results(gbnum).mp_max_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 3 || gui.flag.pmparam2plot_value4GB == 7
                slipA = gui.results(gbnum).mp_min_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 4
                slipA = gui.results(gbnum).mp_SFmax_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 5
                slipA = gui.results(gbnum).mp_RSSmax_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 10
                slipA = gui.results(gbnum).rbv_max_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 11
                slipA = gui.results(gbnum).rbv_min_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 12
                slipA = gui.results(gbnum).n_factor_max_slipA(1);
            elseif gui.flag.pmparam2plot_value4GB == 13
                slipA = gui.results(gbnum).n_factor_min_slipA(1);
            end
            plot_slip_traces(slipA, eulers_vis_A, structure_A, ca_ratio_A(1), shiftxyz_gb_grA, szFac, 0);
            
            % On grain B
            if grcen(gui.GBs(gbnum).grainB,1) == 1
                structure_B = gui.config_data.struct1;
            elseif grcen(gui.GBs(gbnum).grainB,1) == 2
                structure_B = gui.config_data.struct2;
            end
            % Definition of slip to plot
            if gui.flag.pmparam2plot_value4GB == 2 || gui.flag.pmparam2plot_value4GB == 6
                slipB = gui.results(gbnum).mp_max_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 3 || gui.flag.pmparam2plot_value4GB == 7
                slipB = gui.results(gbnum).mp_min_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 4
                slipB = gui.results(gbnum).mp_SFmax_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 5
                slipB = gui.results(gbnum).mp_RSSmax_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 10
                slipB = gui.results(gbnum).rbv_max_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 11
                slipB = gui.results(gbnum).rbv_min_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 12
                slipB = gui.results(gbnum).n_factor_max_slipB(1);
            elseif gui.flag.pmparam2plot_value4GB == 13
                slipB = gui.results(gbnum).n_factor_min_slipB(1);
            end
            ca_ratio_B   = latt_param(gui.grains(gui.GBs(gbnum).grainB).material, gui.grains(gui.GBs(gbnum).grainB).structure);
            eulers_B     = [grcen(gui.GBs(gbnum).grainB,4) grcen(gui.GBs(gbnum).grainB,5) grcen(gui.GBs(gbnum).grainB,6)];
            eulers_vis_B = coordinate_system_apply(eulers_B, gui.COORDSYS_eulers);
            plot_slip_traces(slipB, eulers_vis_B, structure_B, ca_ratio_B(1), shiftxyz_gb_grB, szFac, 0);
        end
    end
end

gui.GBs             = GBs;
gui.grcen           = grcen;
gui.COORDSYS_eulers = COORDSYS_eulers;

guidata(gcf, gui);

end

