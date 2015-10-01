% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_min_max_param_map_plot(param2plot, min_max)
%% Function to plot a map with maximum/minimum m' values from a slip-slip matrix
% param2plot: Slip transmission parameter to plot as a matrix in the Bicrystal GUI (minimum values)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% FIXME: Plot of all min/max values for transmission slip function
% not displayed for a 2 phases material

%% Set the encapsulation of data
gui = guidata(gcf);

% Get min or max values
if min_max == 1
    param_bc = plotGB_Bicrystal_max_min_values_from_matrix(param2plot, ...
        gui.GB.Phase_A, gui.GB.Phase_B, 'min');
elseif min_max == 2
    param_bc = plotGB_Bicrystal_max_min_values_from_matrix(param2plot, ...
        gui.GB.Phase_A, gui.GB.Phase_B, 'max');
end

imagesc(param_bc);
colormap(winter);

textstrings = num2str(param_bc(:), '%0.2f');
textstrings = strtrim(cellstr(textstrings));
[x,y] = meshgrid(1:size(param_bc));
gui.handles.hstrings = text(x(:), y(:), textstrings(:),...
    'horizontalalignment', 'center');
midvalue = mean(get(gca, 'clim'));
textcolors = repmat(param_bc(:) < midvalue,1,3);

set(gui.handles.hstrings,{'color'}, num2cell(textcolors, 2));

if strcmp(gui.GB.Phase_A, 'hcp') == 1
    if gui.flag.LaTeX_flag
        gui.handles.legend_x = ...
            {'bas','pri1$<a>$','pri2$<a>$','pyr1$<a>$','pyr1$<a+c>$','pyr2$<a+c>$'};
    else
        gui.handles.legend_x = ...
            {'bas','pri1<a>','pri2<a>','pyr1<a>','pyr1<a+c>','pyr2<a+c>'};
    end
    tick_x = 1:6;
end
if strcmp(gui.GB.Phase_B, 'hcp') == 1
    if gui.flag.LaTeX_flag
        gui.handles.legend_y = ...
            {'bas','pri1$<a>$','pri2$<a>$','pyr1$<a>$','pyr1$<a+c>$','pyr2$<a+c>$'};
    else
        gui.handles.legend_y = ...
            {'bas','pri1<a>','pri2<a>','pyr1<a>','pyr1<a+c>','pyr2<a+c>'};
    end
    tick_y = 1:6;
end
if strcmp(gui.GB.Phase_A, 'bcc') == 1
    if gui.flag.LaTeX_flag
        gui.handles.legend_x = {'$\{110\}<111>$','$\{112\}<111>$','$\{123\}<111>$'};
    else
        gui.handles.legend_x = {'{110}<111>','{112}<111>','{123}<111>'};
    end
    tick_x = 1:3;
end
if  strcmp(gui.GB.Phase_B, 'bcc') == 1
    if gui.flag.LaTeX_flag
        gui.handles.legend_y = {'$\{110\}<111>$','$\{112\}<111>$','$\{123\}<111>$'};
    else
        gui.handles.legend_y = {'{110}<111>','{112}<111>','{123}<111>'};
    end
    tick_y = 1:3;
end
if strcmp(gui.GB.Phase_A, 'fcc') == 1
    if gui.flag.LaTeX_flag
        gui.handles.legend_x = {'$\{111\}<110>$'};
    else
        gui.handles.legend_x = {'{111}<110>'};
    end
    tick_x = 1:1;
end
if strcmp(gui.GB.Phase_B, 'fcc') == 1
    if gui.flag.LaTeX_flag
        gui.handles.legend_y = {'$\{111\}<110>$'};
    else
        gui.handles.legend_y = {'{111}<110>'};
    end
    tick_y = 1:1;
end

% change the axes tick marks and tick labels
set(gca,...
    'xtick',         tick_x,...
    'xticklabel',    gui.handles.legend_x,...
    'XAxisLocation', 'top',...
    'ytick',         tick_y,...
    'yticklabel',    gui.handles.legend_y,...
    'ticklength',    [0 0],...
    'FontSize',      10);

%rotateticklabel(gca,45);

if gui.flag.LaTeX_flag
    str_Ylabel = ['Grain A - \#', num2str(gui.GB.GrainA)];
    str_Xlabel = ['Grain B - \#', num2str(gui.GB.GrainB)];
else
    str_Ylabel = ['Grain A - #', num2str(gui.GB.GrainA)];
    str_Xlabel = ['Grain B - #', num2str(gui.GB.GrainB)];
end

Y_Label = ylabel(str_Ylabel);
X_Label = xlabel(str_Xlabel);
colorbar ('Location', 'SouthOutside');

if gui.flag.LaTeX_flag
    set([X_Label Y_Label], 'interpreter', 'latex');
    set(gca, 'TickLabelInterpreter', 'latex');
else
    set([X_Label Y_Label], 'interpreter', 'none');
    set(gca, 'TickLabelInterpreter', 'none');
end

guidata(gcf, gui);

end