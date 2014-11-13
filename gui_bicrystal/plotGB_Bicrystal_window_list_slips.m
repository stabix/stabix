% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_window_list_slips
%% Code to define the list of slip and twin systems used for mprime calculation
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

list_struct = listPhase;

num_struct1  = get(gui.handles.pmStructA, 'Value');
struct1      = list_struct(num_struct1,:);
struct1      = struct1{:};

num_struct2  = get(gui.handles.pmStructB, 'Value');
struct2      = list_struct(num_struct2,:);
struct2      = struct2{:};

set(gui.handles.pmlistslipsA, ...
    'String', listSlipSystems(struct1), ...
    'Value', 1);
set(gui.handles.pmlistslipsB, ...
    'String', listSlipSystems(struct2), ...
    'Value', 1);

gui.GB.Phase_A = struct1;
gui.GB.Phase_B = struct2;

guidata(gcf, gui);

plotGB_Bicrystal;

end