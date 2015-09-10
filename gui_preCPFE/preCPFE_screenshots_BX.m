% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_screenshots_BX
%% Function used to generate sequential screenshots of the GUI running with given files.
% author: d.mercier@mpie.de

% Initialization of parameters
SCREENSHOT = strcat(timestamp_make, 'screenshots');
SCREENSHOT_DIR = get_stabix_root;
SCRSHOT_NUM = 1;

% Run the GUI
A_preCPFE_windows_indentation_setting_BX;
gui = guidata(gcf);

% Optimized geometry and visualization
gui.GB.GB_Trace_Angle = 0;
guidata(gcf, gui);
set(gui.handles.mesh.w_sample_val, 'String', '6');
set(gui.handles.mesh.len_sample_val, 'String', '8');
set(gui.handles.mesh.inclination_val, 'String', '70');
preCPFE_indentation_setting_BX;
view([-48 14]);
SCRSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCRSHOT_NUM);

% % Load and rotate Berkovich indenter
set(gui.handles.indenter.pm_indenter, 'Value', 2);
preCPFE_set_indenter;
for angle = 0:18:360 % 20 screenshots
    set(gui.handles.indenter.rotate_loaded_indenter, 'Value', angle);
    preCPFE_indentation_setting_BX;
    SCRSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCRSHOT_NUM);
end

% Increase of mesh level with spherical indenter
set(gui.handles.indenter.pm_indenter, 'Value', 1);
for ii = 1:1:6
    preCPFE_mesh_level(0.1);
    preCPFE_indentation_setting_BX;
    SCRSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCRSHOT_NUM);
end

% Decrease of mesh level
for ii = 1:1:6
    preCPFE_mesh_level(-0.1);
    preCPFE_indentation_setting_BX;
    SCRSHOT_NUM = screenshot_function(SCREENSHOT, SCREENSHOT_DIR, SCRSHOT_NUM);
end

end