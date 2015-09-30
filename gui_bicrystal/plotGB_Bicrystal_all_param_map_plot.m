% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_all_param_map_plot(param2plot, title)
%% Function to plot a map with all maximum m' values from a slip_family-slip_family matrix
% param2plot: Slip transmission parameter to plot
% title : Title of the new window

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

%% Window Coordinates Configuration
scrsize = screenSize;   % Get screen size
WX = 0.65 * scrsize(3); % X Position
WY = 0.10 * scrsize(4); % Y Position
WW = 0.30 * scrsize(3); % Width
WH = 0.30 * scrsize(4); % Height

%% Window & Plot Configuration
gui.handles.figure_handle_all_values_map = figure(...
    'Name', title,...
    'NumberTitle', 'off',...
    'Color', [0.9 0.9 0.9],...
    'Position', [WX WY WW WH]);

imagesc(param2plot);                                                       % create a colored plot of the mp_all_bcrix values
colormap(winter);                                                          % change the colormap to gray (so higher values are black and lower values are white)

meshgrid(1:size(param2plot));                                              % create x and y coordinates for the strings
mean(get(gca, 'clim'));                                                    % get the middle value of the color range
%textcolors = repmat(mp_all_bc(:) < midvalue,1,3);                         % choose white or black for the text color of the strings
% so they can be easily seen over the background color
%set(hstrings, {'color'}, num2cell(textcolors,2));                         % change the text colors

if strcmp(gui.GB.Phase_A, 'hcp') == 1
    tick_x = 1:66;
end
if strcmp(gui.GB.Phase_B, 'hcp') == 1
    tick_y = 1:66;
end
if strcmp(gui.GB.Phase_A, 'bcc') == 1
    tick_x = 1:60;
end
if  strcmp(gui.GB.Phase_B, 'bcc') == 1
    tick_y = 1:60;
end
if strcmp(gui.GB.Phase_A, 'fcc') == 1
    tick_x = 1:24;
end
if strcmp(gui.GB.Phase_B, 'fcc') == 1
    tick_y = 1:24;
end

set(gca,...
    'xtick',         tick_x,...                                            % change the axes tick marks
    'XAxisLocation', 'top',...
    'ytick',         tick_y,...
    'ticklength',    [0 0]);

if gui.flag.LaTeX_flag
    str_Ylabel = ['Grain A - \#', num2str(gui.GB.GrainA)];
    str_Xlabel = ['Grain B - \#', num2str(gui.GB.GrainB)];
else
    str_Ylabel = ['Grain A - #', num2str(gui.GB.GrainA)];
    str_Xlabel = ['Grain B - #', num2str(gui.GB.GrainB)];
end

Y_Label = ylabel(str_Ylabel);
X_Label = xlabel(str_Xlabel);
colorbar;

if gui.flag.LaTeX_flag
    set([X_Label Y_Label], 'interpreter', 'latex');
else
    set([X_Label Y_Label], 'interpreter', 'none');
end

guidata(gcf, gui);

%% Set logo of the GUI
java_icon_gui;

end
