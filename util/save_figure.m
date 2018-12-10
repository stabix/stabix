% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function save_figure(pathname_sav_fig, current_figure, varargin)
%% Function to save figure from the GUI
% path : path used to save the figure
% current_figure : figure to save

% Set in white the background of the GUI
set(gcf,'Color', 'w');

if nargin < 2
    current_figure = gcf;
end

if nargin < 1
    pathname_sav_fig = pwd;
end

%% Modification of the path if needed (manual or random inputs)
if strcmp(pathname_sav_fig,'random_inputs') == 1 || strcmp(pathname_sav_fig,'manual_inputs') == 1
    pathname_sav_fig = pwd;
end

%% Select directory to save the figure
%folder_name_sav_fig = uigetdir(path_sav_fig,'Select directory to save the figure (map)');
[filename_sav_fig, pathname_sav_fig] = uiputfile({'*bmp;*.jpg;*.png;*.tif'}, 'Save Figure As');

if isequal(filename_sav_fig, 0)
    disp('User selected Cancel');
else
    %% Isolation of the figure from the GUI
    if current_figure ~= gcf
        isolated_figure = isolate_axes(current_figure);
    else
        isolated_figure = current_figure;
    end
    
    %% Defintion of the title of the figure
    %date_str = strcat(datestr(now,'yyyy-mmm-dd_HH'),'H',datestr(now,'MM'),'min',datestr(now,'ss'),'s');
    isolated_figure_title = fullfile(pathname_sav_fig, filename_sav_fig);
    
    %% Exportation of the figure in a .png format
    export_fig(isolated_figure_title, isolated_figure);
    disp(strcat('Figure saved as: ', filename_sav_fig));
    
end

end