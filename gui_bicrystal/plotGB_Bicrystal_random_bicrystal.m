% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_random_bicrystal
%% Function to set a new random bicrystal;
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

%% Script to set a bicrystal plot without TSL data
gui.config_map.Sample_IDs   = [];
gui.config_map.Sample_ID    = [];
gui.config_map.Material_IDs = [];
gui.config_map.Material_ID  = [];

gui.GB.YAMLfilename    = 0;
gui.GB.filenameGF2_BC  = 'random_inputs';
gui.GB.filenameRB_BC   = 'random_inputs';
gui.GB.pathnameGF2_BC  = pwd;
gui.GB.pathnameRB_BC   = pwd;
gui.GB.GrainA          = randi(100);
gui.GB.GrainB          = randi(100);
gui.GB.eulerA          = randBunges(1);
gui.GB.eulerB          = randBunges(1);
gui.GB.eulerA_ori      = gui.GB.eulerA;
gui.GB.eulerB_ori      = gui.GB.eulerB;
gui.GB.Phase_A         = 'hcp';
gui.GB.Phase_B         = 'hcp';
if strcmp(gui.GB.Phase_A, gui.GB.Phase_B) == 1
    gui.GB.number_phase    = 1;
else
    gui.GB.number_phase    = 2;
end
gui.GB.GB_Inclination  = randi(40,1) + 70; % 70-110° or round(rand(1)*100)+1 between 0 and 100°
gui.GB.GB_Trace_Angle  = randi(180);
gui.GB.GB_Number       = randi(100);
gui.GB.Material_A      = 'Ti';
gui.GB.ca_ratio_A      = latt_param(gui.GB.Material_A, gui.GB.Phase_A);
gui.GB.Material_B      = 'Ti';
gui.GB.ca_ratio_B      = latt_param(gui.GB.Material_B, gui.GB.Phase_B);
gui.GB.activeGrain     = gui.GB.GrainA;
gui.GB.misorientation  = misorientation(gui.GB.eulerA, gui.GB.eulerB, gui.GB.Phase_A, gui.GB.Phase_B);
gui.GB.slipA           = 1;
gui.GB.slipB           = 1;
gui.GB.slipA_user_spec = 1;
gui.GB.slipB_user_spec = 1;

set(gui.handles.pmMatA, 'Value', 13);
set(gui.handles.pmMatB, 'Value', 13);
set(gui.handles.pmStructA, 'Value', 1);
set(gui.handles.pmStructB, 'Value', 1);
set(gui.handles.getEulangGrA, 'String', num2str(gui.GB.eulerA));
set(gui.handles.getEulangGrB, 'String', num2str(gui.GB.eulerB));
set(gui.handles.getGBtrace, 'String', num2str(gui.GB.GB_Trace_Angle));
set(gui.handles.getGBinclination, 'String', num2str(gui.GB.GB_Inclination));
guidata(gcf, gui);

plotGB_Bicrystal_setpopupmenu;
gui = guidata(gcf); guidata(gcf, gui);

plotGB_Bicrystal;
gui = guidata(gcf); guidata(gcf, gui);

end