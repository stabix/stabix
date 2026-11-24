% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [shiftXYZA, shiftXYZB, ucgrA, ucgrB, arrow_grA, arrow_grB, ...
    arrow_residual] = ...
    plotGB_Bicrystal_plot_lattices(slipA, slipB, no_slip)
%% Function to plot the lattice cells for both grains
% slipA: indice of slip to plot in unit cell for grainA
% slipB: indice of slip to plot in unit cell for grainA
% no_slip: 1 if no slip to plot and 0 if slipA or slipB defined after calculations

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);
valplot = get(gui.handles.pmchoiceplot, 'Value');
arrow_residual = [];

%% Color of arrow
arrowcolora = plot_arrow_color(gui.GB.Phase_A, slipA);
arrowcolorb = plot_arrow_color(gui.GB.Phase_B, slipB);

%% Parameters for Unit Cell Plot
shiftXYZ  = 1.5 * gui.GB_geometry.perp_gb;
shiftXYZA = shiftXYZ+[0;0;-1];
shiftXYZB = -(shiftXYZ+[0;0;+1]);

%% Setting of legend
if gui.flag.LaTeX_flag
    legend_slipA = get_slip_legend_latex(gui.GB.Phase_A, slipA);
    legend_slipB = get_slip_legend_latex(gui.GB.Phase_B, slipB);
else
    legend_slipA = get_slip_legend(gui.GB.Phase_A, slipA);
    legend_slipB = get_slip_legend(gui.GB.Phase_B, slipB);
end
legend_location_str = ...
    get_value_popupmenu(gui.handles.pmlegend_location, listLocationLegend);
legend_location_str = char(legend_location_str);

%% Setting of slip direction and slip normal
slipnormalA = gui.calculations.vectA(slipA, 1:3, gui.GB.GrainA);
slipnormalB = gui.calculations.vectB(slipB, 1:3, gui.GB.GrainB);

slipdirectionA = gui.calculations.vectA(slipA, 4:6, gui.GB.GrainA);
slipdirectionB = gui.calculations.vectB(slipB, 4:6, gui.GB.GrainB);
if dot(slipdirectionA, slipdirectionB) < 0
    slipdirectionA = -slipdirectionA;
end

%% Plot of slip plane (unit cell) for Grain A and B
if no_slip
    ucgrA = vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, 0, shiftXYZA, 0.5);
    ucgrB = vis_lattice(gui.GB.Phase_B, gui.GB.eulerB, 0, shiftXYZB, 0.5);
    
elseif  valplot == 1
    ucgrA = vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, ...
        slipA, shiftXYZA, 0.5);
    % ipfA = plotIPF(GB2plot,grnum,RB,struct);
    ucgrB = vis_lattice(gui.GB.Phase_B, gui.GB.eulerB, ...
        slipB, shiftXYZB, 0.5);
    % ipfB = plotIPF(GB2plot,grnum,RB,struct);
    if get(gui.handles.cblegend,'Value') == 1
        hLeg = legend([ucgrA(3) ucgrB(3)], legend_slipA, legend_slipB);
    end
    if valplot > 1
        warning_commwin('No slip systems defined !');
    end
    
elseif valplot == 2  %% Plot of slip plane (circle) for Grains A and B
    radius = 1;
    slipplaneA = plot_slip_plane(slipnormalA, slipdirectionA, ...
        +shiftXYZA, radius, arrowcolora);
    slipplaneB = plot_slip_plane(slipnormalB, slipdirectionB,  ...
        shiftXYZB, radius, arrowcolorb);
    
    if get(gui.handles.cblegend, 'Value') == 1
        hLeg = legend([slipplaneA.arrow slipplaneB.arrow], ...
            legend_slipA, legend_slipB);
    end
    
elseif valplot == 3  %% Plot of slip plane (unit cell + circle) for Grains A and B
    radius = 1;
    ucgrA  = vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, ...
        slipA, shiftXYZA, .4);
    slipplaneA = plot_slip_plane(slipnormalA, slipdirectionA, ...
        +shiftXYZA, radius, arrowcolora);
    
    ucgrB = vis_lattice(gui.GB.Phase_B, gui.GB. eulerB, ...
        slipB,  shiftXYZB, .4);
    slipplaneB = plot_slip_plane(slipnormalB, slipdirectionB, ...
        shiftXYZB, radius, arrowcolorb);
    
    if get(gui.handles.cblegend, 'Value') == 1
        hLeg = legend([ucgrA(3) ucgrB(3)], legend_slipA, legend_slipB);
    end
    
elseif valplot == 4  %% Plot of Burgers vectors
    radius = 1.5;
    burgersA = gui.calculations.vectA(slipA, 7:9, gui.GB.GrainA);
    burgersB = gui.calculations.vectB(slipB, 7:9, gui.GB.GrainB);
    [~, residual_burgers_vector] = ...
        residual_Burgers_vector(burgersA, burgersB);
    if isempty(residual_burgers_vector) || ...
            any(isnan(residual_burgers_vector)) || ...
            any(isinf(residual_burgers_vector))
        error('plotGB_Bicrystal_plot_lattices:InvalidResidualBurgersVector', ...
            'Unable to calculate a finite residual Burgers vector.');
    end
    ucgrA = vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, slipA, ...
        shiftXYZA, 0.5);
    ucgrB = vis_lattice(gui.GB.Phase_B, gui.GB.eulerB, slipB, ...
        shiftXYZB, 0.5);
    shiftXYZ_A = [shiftXYZA(1), shiftXYZA(2), shiftXYZA(3)];
    shiftXYZ_B = [shiftXYZB(1), shiftXYZB(2), shiftXYZB(3)];
    try
        arrow_grA = arrow(shiftXYZ_A, shiftXYZ_A+slipdirectionA*radius, ...
            'FaceColor', arrowcolora, 'Length', 3*radius, 'TipAngle', 15);
        arrow_grB = arrow(shiftXYZ_B, shiftXYZ_B+slipdirectionB*radius, ...
            'FaceColor', arrowcolorb, 'Length', 3*radius, 'TipAngle', 15);
    catch err
        arrow_grA = ...
            plot3([shiftXYZA(1) shiftXYZA(1)+slipdirectionA(1)*radius], ...
            [shiftXYZA(2) shiftXYZA(2)+slipdirectionA(2)*radius], ...
            [shiftXYZA(3) shiftXYZA(3)+slipdirectionA(3)*radius], ...
            'Color', arrowcolora, 'LineWidth',4);
        arrow_grB = ...
            plot3([shiftXYZB(1) shiftXYZB(1)+slipdirectionB(1)*radius], ...
            [shiftXYZB(2) shiftXYZB(2)+slipdirectionB(2)*radius], ...
            [shiftXYZB(3) shiftXYZB(3)+slipdirectionB(3)*radius], ...
            'Color', arrowcolorb, 'LineWidth',4);
        warning_commwin(err.message);
    end
    if norm(residual_burgers_vector) > eps && ...
            get(gui.handles.cbresidualBurgersVector, 'Value') == 1
        arrow_residual = quiver3(0, 0, 0, ...
            residual_burgers_vector(1), ...
            residual_burgers_vector(2), ...
            residual_burgers_vector(3), 0, ...
            'Color', [0.25 0.25 0.25], 'LineWidth', 3, 'MaxHeadSize', 1);
    end
    if get(gui.handles.cblegend, 'Value') == 1
        if isempty(arrow_residual)
            hLeg = legend([ucgrA(3) ucgrB(3)], ...
                legend_slipA, legend_slipB);
        else
            hLeg = legend([ucgrA(3) ucgrB(3) arrow_residual], ...
                legend_slipA, legend_slipB, 'Residual Burgers vector');
        end
    end
end

if get(gui.handles.cblegend, 'Value') == 1 && ~no_slip
    if isprop(hLeg, 'AutoUpdate')
        set(hLeg, 'AutoUpdate', 'off');
    end
    set(hLeg, 'Location', legend_location_str);
    if gui.flag.LaTeX_flag
        set(hLeg, 'Interpreter', 'LaTeX');
    else
        set(hLeg, 'Interpreter', 'none');
    end
end

end
