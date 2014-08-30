% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_window_list_slips
%% Code to define the list of slip and twin systems used for mprime calculation
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

list_struct1 = get(gui.handles.pmStructA,'string');
num_struct1  = get(gui.handles.pmStructA,'value');
struct1      = list_struct1(num_struct1,:);
struct1      = num2str(struct1);

list_struct2 = get(gui.handles.pmStructB,'string');
num_struct2  = get(gui.handles.pmStructB,'value');
struct2      = list_struct2(num_struct2,:);
struct2      = num2str(struct2);

set(gui.handles.pmlistslipsA,'String', slip_systems_names(struct1), 'Value', 1);
set(gui.handles.pmlistslipsB,'String', slip_systems_names(struct2), 'Value', 1);

gui.GB.Phase_A = struct1;
gui.GB.Phase_B = struct2;

gui = guidata(gcf);
plotGB_Bicrystal;
guidata(gcf, gui);

end