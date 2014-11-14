% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_plotmap_check_calc(check_calculation, varargin)
%% Function to plot the map with all GBs and all grains
% with a variable plotted along each GBs
% check_calculations : flag (0 if no check = no change into the GUI from
% user, 1 if user changed settings into the GUI and 2 if calculations
% without checking)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

% If no check required
if check_calculation == 0
    guidata(gcf, gui);
    interface_map_mprime_calculator_map;
    gui = guidata(gcf); guidata(gcf, gui);
else
    
    % If GBs smoothed and user has selected a GB parameter to plot, calculation are performed...
    if gui.flag.GB_smoothing == 1 && gui.flag.pmparam2plot_value4GB ~= 1
        guidata(gcf, gui);
        interface_map_mprime_calculator_map;
        gui = guidata(gcf); guidata(gcf, gui);
    end
    
    % If new slip families and user has selected a GB parameter to plot, calculation are performed...
    if gui.flag.new_slip_families == 1 ...
            && gui.flag.pmparam2plot_value4GB ~= 1
        guidata(gcf, gui);
        interface_map_mprime_calculator_map;
        gui = guidata(gcf); guidata(gcf, gui);
    end
    
    % If user has changed the GB parameter top plot
    if gui.flag.pmparam2plot_value4GB_functype_old ...
            ~= gui.flag.pmparam2plot_value4GB_functype
        if gui.flag.pmparam2plot_value4GB ~= 1
            guidata(gcf, gui);
            interface_map_mprime_calculator_map;
            gui = guidata(gcf); guidata(gcf, gui);
        end
    end
    
    % If user has changed the Grain parameter top plot
    if gui.flag.pmparam2plot_value4Grains_functype_old ...
            ~= gui.flag.pmparam2plot_value4Grains_functype
        if gui.flag.pmparam2plot_value4Grains ~= 1
            guidata(gcf, gui);
            interface_map_mprime_calculator_map;
            gui = guidata(gcf); guidata(gcf, gui);
        end
    end
end

guidata(gcf, gui);

end