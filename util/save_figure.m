% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function save_figure(pathname_sav_fig, current_figure, varargin)
%% Function to save figure from the GUI
% path : path used to save the figure
% current_figure : figure to save
% varargin : additional export_fig options, e.g. '-transparent'

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
transparent = any(strcmp(varargin, '-transparent'));
if transparent
    file_filter = {'*.png', 'PNG image (*.png)'};
    default_filename = fullfile(pathname_sav_fig, 'export_fig_out.png');
else
    file_filter = {'*bmp;*.jpg;*.png;*.tif'};
    default_filename = pathname_sav_fig;
end
[filename_sav_fig, pathname_sav_fig] = uiputfile(file_filter, ...
    'Save Figure As', default_filename);

if isequal(filename_sav_fig, 0)
    disp('User selected Cancel');
else
    if transparent
        [~, ~, extension] = fileparts(filename_sav_fig);
        if isempty(extension)
            filename_sav_fig = [filename_sav_fig, '.png'];
        elseif ~strcmpi(extension, '.png')
            error('STABiX:TransparentExportFormat', ...
                'Choose a .png filename for transparent export.');
        end
    end

    %% Isolation of the figure from the GUI
    if transparent && strcmp(get(current_figure, 'Type'), 'figure')
        plot_axes = findall(current_figure, 'Type', 'axes');
        if isempty(plot_axes)
            error('STABiX:NoPlotsToExport', ...
                'The selected figure has no plot axes to export.');
        end
        isolated_figure = isolate_axes(plot_axes);
        figure_cleanup = onCleanup(@() close(isolated_figure));
    elseif ~strcmp(get(current_figure, 'Type'), 'figure')
        isolated_figure = isolate_axes(current_figure);
        figure_cleanup = onCleanup(@() close(isolated_figure));
    else
        isolated_figure = current_figure;
        original_color = get(isolated_figure, 'Color');
        color_cleanup = onCleanup(@() set(isolated_figure, 'Color', original_color));
    end

    if ~transparent
        set(isolated_figure, 'Color', 'w');
    end
    
    %% Defintion of the title of the figure
    %date_str = strcat(datestr(now,'yyyy-mmm-dd_HH'),'H',datestr(now,'MM'),'min',datestr(now,'ss'),'s');
    isolated_figure_title = fullfile(pathname_sav_fig, filename_sav_fig);
    
    %% Exportation of the figure in a .png format
    export_fig(isolated_figure_title, isolated_figure, varargin{:});
    clear color_cleanup figure_cleanup;
    disp(strcat('Figure saved as: ', filename_sav_fig));
    
end

end