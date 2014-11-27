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

imagesc(param_bc);                                                     % create a colored plot of the mp_max_bcrix values
colormap(winter);                                                          % change the colormap to gray (so higher values are black and lower values are white)

textstrings = num2str(param_bc(:), '%0.2f');                           % create strings from the mp_max_bcrix values
textstrings = strtrim(cellstr(textstrings));                               % remove any space padding
[x,y] = meshgrid(1:size(param_bc));                                    % create x and y coordinates for the strings
gui.handles.hstrings = text(x(:), y(:), textstrings(:),...                             % plot the strings
    'horizontalalignment', 'center');
midvalue = mean(get(gca, 'clim'));                                         % get the middle value of the color range
textcolors = repmat(param_bc(:) < midvalue,1,3);                       % choose white or black for the text color of the strings
% so they can be easily seen over the background color
set(gui.handles.hstrings,{'color'}, num2cell(textcolors, 2));                          % change the text colors

if strcmp(gui.GB.Phase_A, 'hcp') == 1
    gui.handles.legend_x = ...
        {'bas','pri1<a>','pri2<a>','pyr1<a>','pyr1<a+c>','pyr2<a+c>'};
    tick_x   = 1:6;
end
if strcmp(gui.GB.Phase_B, 'hcp') == 1
    gui.handles.legend_y = ...
        {'bas','pri1<a>','pri2<a>','pyr1<a>','pyr1<a+c>','pyr2<a+c>'};
    tick_y   = 1:6;
end
if strcmp(gui.GB.Phase_A, 'bcc') == 1
    gui.handles.legend_x = {'{110}<111>','{112}<111>','{123}<111>'};
    tick_x   = 1:3;
end
if  strcmp(gui.GB.Phase_B, 'bcc') == 1
    gui.handles.legend_y = {'{110}<111>','{112}<111>','{123}<111>'};
    tick_y   = 1:3;
end
if strcmp(gui.GB.Phase_A, 'fcc') == 1
    gui.handles.legend_x = {'{111}<110>'};
    tick_x   = 1:1;
end
if strcmp(gui.GB.Phase_B, 'fcc') == 1
    gui.handles.legend_y = {'{111}<110>'};
    tick_y   = 1:1;
end

set(gca,...
    'xtick',         tick_x,...                                            % change the axes tick marks
    'xticklabel',    gui.handles.legend_x,...                                          % and tick labels
    'XAxisLocation', 'top',...
    'ytick',         tick_y,...
    'yticklabel',    gui.handles.legend_y,...
    'ticklength',    [0 0],...
    'FontSize',      10);

%rotateticklabel(gca,45);

ylabel(['Grain A - #', num2str(gui.GB.GrainA)]);
xlabel(['Grain B - #', num2str(gui.GB.GrainA)]);
colorbar ('Location', 'SouthOutside');

guidata(gcf, gui);

end
