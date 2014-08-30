% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [shiftXYZA, shiftXYZB, ucgrA, ucgrB, arrow_grA, arrow_grB] = plotGB_Bicrystal_plot_lattices(slipA, slipB, no_slip)
%% Function to plot the lattice cells for both grains
% slipA: indice of slip to plot in unit cell for grainA
% slipB: indice of slip to plot in unit cell for grainA
% no_slip: 1 if no slip to plot and 0 if slipA or slipB defined after calculations

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

valplot = get(gui.handles.pmchoiceplot, 'Value');
%% Color of arrow
arrowcolora = plot_arrow_color(gui.GB.Phase_A, slipA);
arrowcolorb = plot_arrow_color(gui.GB.Phase_B, slipB);

%% Parameters for Unit Cell Plot
shiftXYZ  = 1.5 * gui.GB_geometry.perp_gb;
shiftXYZA = shiftXYZ+[0;0;-1];
shiftXYZB = -(shiftXYZ+[0;0;+1]);

%% Setting of legend
legend_slipA         = get_slip_legend(gui.GB.Phase_A, slipA);
legend_slipB         = get_slip_legend(gui.GB.Phase_B, slipB);
list_legend_location = get(gui.handles.pmlegend_location, 'String');
legend_location_num  = get(gui.handles.pmlegend_location, 'Value');
legend_location_str  = list_legend_location(legend_location_num, :);
legend_location_str(ismember(legend_location_str,' ')) = [];

%% Setting of slip direction and slip normal
slipnormalA    = gui.calculations.vectA(slipA, 1:3, gui.GB.GrainA);
slipnormalB    = gui.calculations.vectB(slipB, 1:3, gui.GB.GrainB);

if gui.flag.flag_dir_vectA(slipB, slipA) == 0
    slipdirectionA = gui.calculations.vectA(slipA, 4:6, gui.GB.GrainA);
elseif gui.flag.flag_dir_vectA(slipB, slipA) == 1
    slipdirectionA = -gui.calculations.vectA(slipA, 4:6, gui.GB.GrainA);
end
if gui.flag.flag_dir_vectB(slipB, slipA) == 0
    slipdirectionB = gui.calculations.vectB(slipB, 4:6, gui.GB.GrainB);
elseif gui.flag.flag_dir_vectB(slipB, slipA) == 1
    slipdirectionB = -gui.calculations.vectB(slipB, 4:6, gui.GB.GrainB);
end

%% Plot of slip plane (unit cell) for Grain A and B
if no_slip
    ucgrA  =  vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, 0,  shiftXYZA, 0.5);
    ucgrB  =  vis_lattice(gui.GB.Phase_B, gui.GB.eulerB, 0,  shiftXYZB, 0.5);
    
elseif  valplot == 1
    ucgrA  =  vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, slipA,  shiftXYZA, 0.5);
    % ipfA = plotIPF(GB2plot,grnum,RB,struct);
    ucgrB  =  vis_lattice(gui.GB.Phase_B, gui.GB.eulerB, slipB,  shiftXYZB, 0.5);
    % ipfB = plotIPF(GB2plot,grnum,RB,struct);
    if get(gui.handles.cblegend,'Value') == 1
        legend([ucgrA(3) ucgrB(3)], legend_slipA, legend_slipB, 'Location', legend_location_str);
    end
    if valplot > 1
        warning('No slip systems defined !')
    end
    
elseif valplot == 2  %% Plot of slip plane (circle) for Grain A and B
    radius = 1;
    slipplaneA     = plot_slip_plane(slipnormalA, slipdirectionA, +shiftXYZA, radius, arrowcolora);
    slipplaneB     = plot_slip_plane(slipnormalB, slipdirectionB,  shiftXYZB, radius, arrowcolorb);
    
    if get(gui.handles.cblegend, 'Value') == 1
        legend([slipplaneA.arrow slipplaneB.arrow], legend_slipA, legend_slipB, 'Location', legend_location_str);
    end
    
elseif valplot  ==  3  %% Plot of slip plane (unit cell + circle) for Grain A and B
    radius         = 1;
    ucgrA          = vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, slipA, shiftXYZA, .4);
    slipplaneA     = plot_slip_plane(slipnormalA, slipdirectionA, +shiftXYZA, radius, arrowcolora);
    
    ucgrB          = vis_lattice(gui.GB.Phase_B, gui.GB. eulerB, slipB,  shiftXYZB, .4);
    slipplaneB     = plot_slip_plane(slipnormalB, slipdirectionB,  shiftXYZB, radius, arrowcolorb);
    
    if get(gui.handles.cblegend, 'Value') == 1
        legend([ucgrA(3) ucgrB(3)], legend_slipA, legend_slipB, 'Location', legend_location_str);
    end
    
elseif valplot  ==  4  %% Plot of Burgers vectors
    radius = 1.5;
    ucgrA  =  vis_lattice(gui.GB.Phase_A, gui.GB.eulerA, slipA,  shiftXYZA, 0.5);
    ucgrB  =  vis_lattice(gui.GB.Phase_B, gui.GB.eulerB, slipB,  shiftXYZB, 0.5);
    shiftXYZ_A = [shiftXYZA(1), shiftXYZA(2), shiftXYZA(3)];
    shiftXYZ_B = [shiftXYZB(1), shiftXYZB(2), shiftXYZB(3)];
    arrow_grA  =  arrow(shiftXYZ_A, shiftXYZ_A+slipdirectionA*radius, 'FaceColor', arrowcolora, 'Length', 5, 'TipAngle', 15);
    arrow_grB  =  arrow(shiftXYZ_B, shiftXYZ_B+slipdirectionB*radius, 'FaceColor', arrowcolorb, 'Length', 5, 'TipAngle', 15);
end

triad_lines;
axis off;
axis tight;
view([0,0,1]);
rotate3d on;

guidata(gcf, gui);

end
