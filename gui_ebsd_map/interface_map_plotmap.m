% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_plotmap(...
    run_calculation, check_calculation, varargin)
%% Function to plot the map with all GBs and all grains
% with a variable plotted along each GBs
% run_calculation : flag (0 if no calculation and 1 if calculations have to
% be performed)
% check_calculations : flag (0 if no check = no change into the GUI from
% user, 1 if user changed settings into the GUI and 2 if calculations
% without checking)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 2
    check_calculation = 0;
end

if nargin < 1
    run_calculation = 0;
end

%% Get data from encapsulation
gui = guidata(gcf);

gui.flag.flag_lattice = 1;

%% Set LaTeX interpreter
LaTeX_flag = get(gui.handles.latex, 'Value');

%% Refresh time/date
set(gui.handles.date_str_interface,'String', timestamp_make);

%% Refresh pop-up menus
guidata(gcf, gui);
if gui.config_data.num_struct1 ~= get(gui.handles.pmStruct1, 'Value') || ...
        gui.config_data.num_struct2 ~= get(gui.handles.pmStruct2, 'Value')
    interface_map_list_slips(...
        gui.handles.pmStruct1, ...
        gui.handles.pmStruct2, ...
        gui.handles.pmlistslips1, ...
        gui.handles.pmlistslips2, ...
        str2double(get(gui.handles.NumPh,'String')), 1, 1);
else
    interface_map_list_slips(...
        gui.handles.pmStruct1, ...
        gui.handles.pmStruct2, ...
        gui.handles.pmlistslips1, ...
        gui.handles.pmlistslips2, ...
        str2double(get(gui.handles.NumPh,'String')), ...
        get(gui.handles.pmlistslips1, 'value'), ...
        get(gui.handles.pmlistslips2, 'value'));
end

%% Refresh stress tensor
gui.stressTensor = get_stress_tensor(...
    gui.handles.stressTensor);

%% Plot microstructure
set(gcf, 'CurrentAxes', gui.handles.AxisGBmap);

% Get axis settings
if gui.flag.newAxisLim == 1
    gui.flag.xlim_old = get(gui.handles.AxisGBmap, 'xlim');
    gui.flag.ylim_old = get(gui.handles.AxisGBmap, 'ylim');
    guidata(gcf, gui);
end

cla;

%% Definition of colorbar
wid = 4;
fontsize_axis = 16;
clear bins vec Colorbar;

% Definiton of Colormap
color_def = get_value_popupmenu(gui.handles.pmcolorbar, listColormap);
% Definiton of Colorbar location
location_num = get(gui.handles.pmcolorbar_loc, 'Value');
location_str = ...
    get_value_popupmenu(gui.handles.pmcolorbar_loc, listLocationColorbar);
% Colormap properties
colormap(color_def{:});
cmap = colormap;

%% Set axis
gui.flag.pmparam2plot_value4GB = ...
    get(gui.handles.pmparam2plot4GB, 'Value');
gui.flag.pmparam2plot_value4Grains = ...
    get(gui.handles.pmparam2plot4Grains, 'Value');

gui.handles.gcf;
hold on;

guidata(gcf, gui);
interface_map_mprime_calculator_map_set;
gui = guidata(gcf); guidata(gcf, gui);

%% Set GBs
interface_map_init_microstructure;
gui = guidata(gcf); guidata(gcf, gui);
GF2 = gui.GF2_struct.data_smoothed;
RB  = gui.RB_struct.data_smoothed;

%% Calculations and plot of function results along GBs
if gui.flag.pmparam2plot_value4GB == 1
    gui.flag.pmparam2plot_value4GB_functype = 0;
elseif gui.flag.pmparam2plot_value4GB ~= 1 ...
        && gui.flag.pmparam2plot_value4GB < 8
    gui.flag.pmparam2plot_value4GB_functype = 1;
elseif gui.flag.pmparam2plot_value4GB == 8
    gui.flag.pmparam2plot_value4GB_functype = 2;
elseif gui.flag.pmparam2plot_value4GB == 9
    gui.flag.pmparam2plot_value4GB_functype = 3;
elseif gui.flag.pmparam2plot_value4GB == 10 ...
        || gui.flag.pmparam2plot_value4GB == 11
    gui.flag.pmparam2plot_value4GB_functype = 4;
elseif gui.flag.pmparam2plot_value4GB == 12 ...
        || gui.flag.pmparam2plot_value4GB == 13
    gui.flag.pmparam2plot_value4GB_functype = 5;
elseif gui.flag.pmparam2plot_value4GB == 14 ...
        || gui.flag.pmparam2plot_value4GB == 15
    gui.flag.pmparam2plot_value4GB_functype = 6;
elseif gui.flag.pmparam2plot_value4GB == 16
    gui.flag.pmparam2plot_value4GB_functype = 7;
elseif gui.flag.pmparam2plot_value4GB == 17
    gui.flag.pmparam2plot_value4GB_functype = 8;
    
end

if gui.flag.pmparam2plot_value4Grains == 1
    gui.flag.pmparam2plot_value4Grains_functype = 0;
elseif gui.flag.pmparam2plot_value4Grains == 2 ...
        || gui.flag.pmparam2plot_value4Grains == 4
    gui.flag.pmparam2plot_value4Grains_functype = 1;
elseif gui.flag.pmparam2plot_value4Grains == 3
    gui.flag.pmparam2plot_value4Grains_functype = 2;
end

guidata(gcf, gui);

%% Run calculations
if run_calculation
    interface_map_plotmap_check_calc(check_calculation);
end
gui = guidata(gcf); guidata(gcf, gui);

if gui.flag.flag_lattice == 1
    if gui.flag.pmparam2plot_value4GB_functype == 0 ...
            || gui.flag.pmparam2plot_value4GB_functype == 2 ...
            || gui.flag.pmparam2plot_value4GB_functype == 3
        set(gui.handles.cbsliptraces, 'Visible', 'off');
        set(gui.handles.cbsliptraces, 'Value', 0);
    else
        if gui.flag.CalculationFlag == 1 ...
                || gui.flag.CalculationFlag == 2 ...
                || gui.flag.CalculationFlag == 3
            set(gui.handles.cbsliptraces, 'Visible', 'on');
        end
    end
    
    %% Plot GB segments and inclined plane
    if gui.flag.pmparam2plot_value4GB == 1
        h_gbseg = zeros(size(RB,1), 1); % Preallocation
        for gbnum = 1:1:size(RB,1)
            h_gbseg(gbnum) = plot(...
                [gui.GBs(gbnum).pos_x1; gui.GBs(gbnum).pos_x2], ...
                [gui.GBs(gbnum).pos_y1; gui.GBs(gbnum).pos_y2], ...
                'LineWidth', wid, 'color', 'k');
            
            % The following lines should be uncommented if user wants arrows for GBs plot instead of pure segments...
            %             try
            %                 h_gbseg(gbnum) = arrow(...
            %                     [gui.GBs(gbnum).pos_x1; gui.GBs(gbnum).pos_y1; 0], ...
            %                     [gui.GBs(gbnum).pos_x2; gui.GBs(gbnum).pos_y2; 0], ...
            %                     'LineWidth', wid, 'color', 'k');
            %             catch err
            %                 warning_commwin(err.message);
            %             end
            
            % The following lines should be uncommented if user wants to plot GB inclined planes
            % h_inclined_planes = plot_inclined_GB_plane(...
            % [gui.GBs(gbnum).pos_x1; gui.GBs(gbnum).pos_y1; 0], ...
            % [gui.GBs(gbnum).pos_x2; gui.GBs(gbnum).pos_y2; 0], 0 ,90);
        end
    end
    
    %% Plot unit cell / phase / GB Number / Grains Number / Slip for the highest Schmid factor
    guidata(gcf, gui);
    szFac = interface_map_plotmap_nodata;
    gui = guidata(gcf); guidata(gcf, gui);
    
    %% Defintion of the parameter to plot
    if gui.flag.pmparam2plot_value4GB ~= 1
        
        if gui.flag.pmparam2plot_value4GB == 2  % m' max
            if LaTeX_flag
                Colorbar_title = 'Maximum $m''$ values';
            else
                Colorbar_title = 'Maximum m'' values';
            end
            gui.calculations.func2plot = [gui.results.mp_max];
            
        elseif gui.flag.pmparam2plot_value4GB == 3  % m' min
            if LaTeX_flag
                Colorbar_title = 'Minimum $m''$ values';
            else
                Colorbar_title = 'Minimum m'' values';
            end
            gui.calculations.func2plot = [gui.results.mp_min];
            
        elseif gui.flag.pmparam2plot_value4GB == 4 % m' with slips with highest Generalized Schmid Factor
            if LaTeX_flag
                Colorbar_title = '$m''$ with highest Generalized Schmid Factor';
            else
                Colorbar_title = 'm'' with highest Generalized Schmid Factor';
            end
            gui.calculations.func2plot = [gui.results.mp_SFmax];
            
        elseif gui.flag.pmparam2plot_value4GB == 5 % m' with slips with highest Resolved Shear Stress
            if LaTeX_flag
                Colorbar_title = '$m''$ with highest Resolved Shear Stress';
            else
                Colorbar_title = 'm'' with highest Resolved Shear Stress';
            end
            gui.calculations.func2plot = [gui.results.mp_RSSmax];
            
        elseif gui.flag.pmparam2plot_value4GB == 6  % only highest m' max
            if LaTeX_flag
                Colorbar_title = 'Maximum $m''$ values ($-10\%$)';
            else
                Colorbar_title = 'Maximum m'' values (-10%)';
            end
            gui.calculations.func2plot = [gui.results.mp_max];
            
        elseif gui.flag.pmparam2plot_value4GB == 7  % only lowest m' min
            if LaTeX_flag
                Colorbar_title = 'Minimum $m''$ values ($+10\%$)';
            else
                Colorbar_title = 'Minimum m'' values (+10%)';
            end
            gui.calculations.func2plot = [gui.results.mp_min];
            
        elseif gui.flag.pmparam2plot_value4GB == 8 % Misorientation
            if LaTeX_flag
                Colorbar_title = 'Misorientation ($^\circ$)';
            else
                Colorbar_title = 'Misorientation (°)';
            end
            gui.calculations.func2plot = [gui.results.misor];
            
        elseif gui.flag.pmparam2plot_value4GB == 9 % C-axis Misorientation
            if LaTeX_flag
                Colorbar_title = 'C-axis Misorientation ($^\circ$)';
            else
                Colorbar_title = 'C-axis Misorientation (°)';
            end
            gui.calculations.func2plot = [gui.results.caxis_misor];
            
        elseif gui.flag.pmparam2plot_value4GB == 10  % Maximum residual Burgers vector
            Colorbar_title = 'Maximum residual Burgers vector';
            gui.calculations.func2plot = [gui.results.rbv_max];
            
        elseif gui.flag.pmparam2plot_value4GB == 11  % Minimum residual Burgers vector
            Colorbar_title = 'Minimum residual Burgers vector';
            gui.calculations.func2plot = [gui.results.rbv_min];
            
        elseif gui.flag.pmparam2plot_value4GB == 12 % N-factor
            if LaTeX_flag
                Colorbar_title = 'Maximum $N$-factor';
            else
                Colorbar_title = 'Maximum N-factor';
            end
            gui.calculations.func2plot = [gui.results.n_factor_max];
            
        elseif gui.flag.pmparam2plot_value4GB == 13 % N-factor
            if LaTeX_flag
                Colorbar_title = 'Minimum $N$-factor';
            else
                Colorbar_title = 'Minimum N-factor';
            end
            gui.calculations.func2plot = [gui.results.n_factor_min];
            
        elseif gui.flag.pmparam2plot_value4GB == 14 % lambda
            if LaTeX_flag
                Colorbar_title = 'Maximum $\lambda$';
            else
                Colorbar_title = 'Maximum lambda';
            end
            gui.calculations.func2plot = [gui.results.lambda_max];
            
        elseif gui.flag.pmparam2plot_value4GB == 15 % lambda
            if LaTeX_flag
                Colorbar_title = 'Minimum $\lambda$';
            else
                Colorbar_title = 'Minimum lambda';
            end
            gui.calculations.func2plot = [gui.results.lambda_min];
            
        elseif gui.flag.pmparam2plot_value4GB == 16 % GB Schmid factor
            Colorbar_title = 'GB Schmid factor';
            gui.calculations.func2plot = [gui.results.gb_schmid_factor];
            
        elseif gui.flag.pmparam2plot_value4GB == 17 % Other function
            Colorbar_title = 'Other function';
            gui.calculations.func2plot = [gui.results.oth_func_val];
            
        end
        
        %% Plot function results along GBs
        if gui.flag.CalculationFlag ~= 0 ...
                && gui.flag.pmparam2plot_value4GB ~= 1
            
            %% Plot parameter values ==> txt on GB
            mprime_format = '%0.2f'; % float with 2 digits
            if get(gui.handles.cbgbnum, 'Value') == 1
                txt_dx = 0.05*max(GF2(:,5)); % delta x for text labels
                txt_dy = 0.05*max(GF2(:,6)); % delta y for text labels
            else
                txt_dx = 0; % delta x for text labels
                txt_dy = 0; % delta y for text labels
            end
            h_val  = zeros(size(RB,1),1); % Preallocation
            
            if get(gui.handles.cbdatavalues, 'Value') == 1
                for gbnum = 1:1:size(RB,1)
                    x_mp = ((gui.GBs(gbnum).pos_x1 ...
                        + gui.GBs(gbnum).pos_x2)/2) + txt_dx;
                    y_mp = ((gui.GBs(gbnum).pos_y1 ...
                        + gui.GBs(gbnum).pos_y2)/2) - txt_dy;
                    h_val(gbnum) = text(x_mp, y_mp, sprintf(...
                        mprime_format, gui.calculations.func2plot(gbnum)), ...
                        'Color', [.5 0 0]);
                    set(h_val(gbnum), 'HorizontalAlignment', 'Right', ...
                        'VerticalAlignment', 'bottom', 'Clipping', 'on');
                end
            end
            
            %% GB Colored according to the scaled parameter
            minval = min(gui.calculations.func2plot(:));
            maxval = max(gui.calculations.func2plot(:));
            if (maxval - minval) > 0.3 && maxval > 0.5
                minval = round(minval);
                maxval = round(maxval);
            end
            if (max(gui.calculations.func2plot(:)) ...
                    - min(gui.calculations.func2plot(:))) > 0.3 ...
                    && min(gui.calculations.func2plot(:)) > 0.5 ...
                    && max(gui.calculations.func2plot(:)) < 1
                minval = round(10*min(gui.calculations.func2plot(:)))/10;
                maxval = round(10*max(gui.calculations.func2plot(:)))/10;
            end
            step_tot = max(gui.calculations.func2plot(:)) - ...
                min(gui.calculations.func2plot(:));
            step_elem = step_tot/10;
            
            if gui.flag.pmparam2plot_value4GB == 6  % only highest m' max
                minval   = minval + (9*step_elem);
                step_tot = maxval - minval;
            elseif gui.flag.pmparam2plot_value4GB == 7  % only lowest m' max
                maxval   = minval + (step_elem);
                step_tot = maxval - minval;
            end
            
            if  gui.flag.pmparam2plot_value4GB == 14  % only highest lambda
                if sum(gui.calculations.func2plot(:)) == 1
                    minval   = 0;
                    step_tot = 0.2;
                end
            elseif gui.flag.pmparam2plot_value4GB == 15  % only lowest lambda
                if sum(gui.calculations.func2plot(:)) == 0
                    maxval   = 1;
                    step_tot = 0.2;
                end
            end
            
            step_Colorbar = step_tot/size(cmap(:,:),1);
            
            bins = round(100*linspace(minval, maxval, 5))/100;
            if maxval < 0.1 || (maxval - minval) < 0.1
                bins = round(10000*linspace(minval, maxval, 5))/10000;
            end
            if minval == maxval
                bins = round(10000*linspace(0.9*minval, 1.1*maxval, 5))/10000;
            end
            
            Colorgb = zeros(size(RB,1), 1);
            for gbnum = 1:1:size(RB,1)
                if gui.calculations.func2plot(gbnum) >= minval ...
                        && gui.calculations.func2plot(gbnum) <= maxval
                    step_vec = ...
                        (gui.calculations.func2plot(gbnum) - minval);
                    Colorgb(gbnum) = round(step_vec/step_Colorbar);
                    if Colorgb(gbnum) > length(cmap)
                        Colorgb(gbnum) = length(cmap);
                    end
                end
            end
            
            for gbnum = 1:1:size(RB,1)
                if gui.calculations.func2plot(gbnum) < minval
                    Colorgb(gbnum) = min(Colorgb(:));
                elseif gui.calculations.func2plot(gbnum) > maxval
                    Colorgb(gbnum) = max(Colorgb(:));
                end
            end
            
            for gbnum = 1:1:size(RB,1)
                if Colorgb(gbnum) == 0 | isnan(Colorgb(gbnum))
                    Colorgb(gbnum) = 1;
                end
                plot([gui.GBs(gbnum).pos_x1; gui.GBs(gbnum).pos_x2], ...
                    [gui.GBs(gbnum).pos_y1; gui.GBs(gbnum).pos_y2], ...
                    'Linewidth', wid, 'Color', cmap(Colorgb(gbnum),:));
            end
        end
        
        %% Plot of the Colorbar
        colorbar('delete');
        
        try
            Colorbargb = colorbar;
            if minval == maxval
                caxis([0.9*minval 1.1*maxval]);
            else
                caxis([minval maxval]);
            end
            if location_num == 1 || location_num == 2 || ...
                    location_num == 5 || location_num == 6
                set(Colorbargb, 'XTick', bins);
                set(get(Colorbargb, 'xlabel'), ...
                    'String', Colorbar_title, ...
                    'Fontsize', fontsize_axis);
                if LaTeX_flag
                    set(get(Colorbargb, 'xlabel'), 'Interpreter', 'latex');
                else
                    set(get(Colorbargb, 'xlabel'), 'Interpreter', 'none');
                end
            elseif location_num == 3 || location_num == 4 || ...
                    location_num == 7 || location_num == 8
                set(Colorbargb, 'YTick', bins);
                set(get(Colorbargb, 'ylabel'), ...
                    'String', Colorbar_title, ...
                    'Fontsize', fontsize_axis);
                if LaTeX_flag
                    set(get(Colorbargb, 'ylabel'), 'Interpreter', 'latex');
                else
                    set(get(Colorbargb, 'ylabel'), 'Interpreter', 'none');
                end
            end
            set(Colorbargb, 'Location', location_str{:});
            
        catch err
            commandwindow;
            display(err.message);
            colorbar('delete');
            set(gui.handles.cbdatavalues, 'Value', 1);
        end
        
        
    elseif gui.flag.pmparam2plot_value4GB == 1
        colorbar('off');
    else
        warning_commwin('Please, run calculations before...');
        %colorbar('off');
    end
    
    %% Set legends of slips
    if gui.flag.pmparam2plot_value4Grains == 4
        set(gui.handles.cbsliptraces, 'Value', 1)
    end
    if get(gui.handles.cbsliptraces, 'Value') == 1
        set(gui.handles.pmlegend, 'Visible', 'on');
        if get(gui.handles.pmlegend, 'Value') ~= 1
            if str2double(get(gui.handles.NumPh, 'String')) == 1
                structure_legend = gui.config_data.struct1;
            elseif str2double(get(gui.handles.NumPh, 'String')) == 2
                if get(gui.handles.pmlegend, 'Value') == 2 % Phase 1
                    structure_legend = gui.config_data.struct1;
                elseif get(gui.handles.pmlegend, 'Value') == 3 % Phase 2
                    structure_legend = gui.config_data.struct2;
                end
            end
            slip_color = cell2mat(get_slip_color(structure_legend, 100));
            if LaTeX_flag
                slip_legend = get_slip_legend_latex(structure_legend, 100);
            else
                slip_legend = get_slip_legend(structure_legend, 100);
            end
            h_slip = zeros(1,length(slip_color));
            for ii = 1:length(slip_color)
                h_slip(ii) = plot(0,0, 'Color', ...
                    slip_color(ii,:), 'Linewidth', 5);
            end
            h_slip_legend = legend(h_slip, slip_legend);
            set(h_slip_legend, 'Visible', 'on', 'Location', 'SouthWest');
            set(h_slip, 'Visible', 'off');
            if LaTeX_flag
                set(h_slip_legend, 'Interpreter', 'latex');
            else
                set(h_slip_legend, 'Interpreter', 'none');
            end
        else
            legend('off'); legend('hide');
        end
    else
        legend('off'); legend('hide');
        set(gui.handles.pmlegend, 'Visible', 'off');
        set(gui.handles.pmlegend, 'Value', 2);
    end
    
    %% Set axis
    % Axis limits based on GBs coordinates
    %max_x = [max(RB(:,9)) , (max(RB(:,11)))]; maxx = max(max_x);
    %max_y = [max(RB(:,10)), (max(RB(:,12)))]; maxy = max(max_y);
    % Axis limits based on Grains coordinates
    maxx = max(GF2(:,5));
    maxy = max(GF2(:,6));
    
    if gui.flag.newDataFlag == 2 % Because of Voronoi tessalation...
        axis([(0-0.05*maxx) 1.05*maxx -1.05*maxy (0+0.05*maxy)]);
    elseif gui.flag.initialization_axis == 1 || gui.flag.newDataFlag == 0
        axis([-1.5 1.5 -1.5 1.5]);
    elseif gui.flag.newAxisLim == 0
        axis equal;
        axis auto;
        axis tight;
    else
        set(gui.handles.AxisGBmap, 'xlim', gui.flag.xlim_old);
        set(gui.handles.AxisGBmap, 'ylim', gui.flag.ylim_old);
    end
    
    if szFac > 0
        zlim([-szFac*10 szFac*10]);
    end
    box on;
    daspect([1 1 1]);
    view([0 0 1])
    
    %% Get unit of EBSD map
    gui.config_map.unit_string = ...
        get_value_popupmenu(gui.handles.pm_unit, listLengthUnit);
    h_Label_unit = gui.config_map.unit_string{:};
    
    if LaTeX_flag && strcmp(gui.config_map.unit_string, 'nm')
        h_Label_unit = '$nm$';
    elseif LaTeX_flag && strcmp(gui.config_map.unit_string, 'micron')
        h_Label_unit = '$\mu m$';
    elseif LaTeX_flag && strcmp(gui.config_map.unit_string, 'mm')
        h_Label_unit = '$mm$';
    end
    
    h_xLabel = xlabel(strcat('x axis (', h_Label_unit, ')'));
    h_yLabel = ylabel(strcat('y axis (', h_Label_unit, ')'));
    
    set([h_xLabel, h_yLabel], 'fontsize', fontsize_axis);
    set(gca, 'fontsize', fontsize_axis, 'color', 'w');
    
    if LaTeX_flag
        set([h_xLabel, h_yLabel], 'Interpreter', 'latex');
    else
        set([h_xLabel, h_yLabel], 'Interpreter', 'none');
    end
    
    %% Set flags
    pmslips = [gui.handles.pmlistslips1; gui.handles.pmlistslips2];
    gui.flag.pmparam2plot_value4GB_old              = ...
        gui.flag.pmparam2plot_value4GB;
    gui.flag.pmparam2plot_value4GB_functype_old     = ...
        gui.flag.pmparam2plot_value4GB_functype;
    gui.flag.pmparam2plot_value4Grains_functype_old = ...
        gui.flag.pmparam2plot_value4Grains_functype;
    gui.flag.pm_NumPh_old = str2double(get(gui.handles.NumPh,'String'));
    gui.flag.pmlistsslips_ph1_old  = get(pmslips(1), 'Value');
    gui.flag.pmlistsslips_ph2_old  = get(pmslips(2), 'Value');
    gui.flag.pm_ph1_old            = get(gui.handles.pmStruct1, 'Value');
    gui.flag.pm_ph2_old            = get(gui.handles.pmStruct2, 'Value');
    gui.flag.pm_mat1_old           = get(gui.handles.pmMat1, 'Value');
    gui.flag.pm_mat2_old           = get(gui.handles.pmMat2, 'Value');
    gui.flag.initialization        = 0;
    gui.flag.initialization_axis   = 0;
    gui.flag.new_slip_families     = 0;
    gui.flag.newAxisLim            = 1;
    
end
guidata(gcf, gui);

end