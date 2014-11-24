% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_import_image(image_type)
%% Function to import an image
% image_type: 1 for before polishing and 2 after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

cd(gui.config.gbinc_root);

filterindex = '*.jpg;*.tif;*.png;*.gif';
picture = 1;

[filename, pathname] = uigetfile({filterindex, 'All Image Files'},...
    'File Selector');

if isequal(filename, 0)
    disp('User selected Cancel');
    warning_commwin('Please, select a picture...', 1);
    picture = 0;
else
    disp(['User selected :', fullfile(pathname, filename)])
end

if picture
    if image_type == 1
        set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.2 0.8 0]);
        set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.9 0.9 0.9]);
        txtbox = gui.handles.image_before_polishing.edit_ImpImageFile;
        gui.config_map.pathname_image_before_polishing = pathname;
        gui.config_map.filename_image_before_polishing = filename;
        gui.config_map.fullpath_image_before_polishing = fullfile(...
            pathname, filename);
        try
            if isequal(gui.config_map.filename_image_after_polishing, ...
                    filename)
                warning_commwin('Please, load a different image !', 1);
            else
                gui.flag.image1 = 1;
            end
        catch
        end
        if isequal(filename, 0)
            warning_commwin('Please, load an image !', 1);
        else
            gui.flag.image1 = 1;
        end
    elseif image_type == 2
        set(gui.handles.switch_plot.pb1, 'BackgroundColor', [0.9 0.9 0.9]);
        set(gui.handles.switch_plot.pb2, 'BackgroundColor', [0.2 0.8 0]);
        txtbox = gui.handles.image_after_polishing.edit_ImpImageFile;
        gui.config_map.pathname_image_after_polishing = pathname;
        gui.config_map.filename_image_after_polishing = filename;
        gui.config_map.fullpath_image_after_polishing = fullfile(...
            pathname, filename);
        try
            if isequal(gui.config_map.filename_image_before_polishing, ...
                    filename)
                warning_commwin('Please, load a different image !', 1);
            else
                gui.flag.image2 = 1;
            end
        catch
        end
        if isequal(filename, 0)
            warning_commwin('Please, load an image !', 1);
        else
            gui.flag.image2 = 1;
        end
    else
        gui.flag.image1 = 0;
        gui.flag.image2 = 0;
    end
    guidata(gcf, gui);
    gui_gbinc_load_image(fullfile(pathname, filename));
    set(txtbox, 'String', filename);
end

guidata(gcf, gui);

end