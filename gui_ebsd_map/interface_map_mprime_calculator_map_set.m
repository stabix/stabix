% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_mprime_calculator_map_set
%% Function used to set the calculation of m' parameter values for all GBs
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
gui = guidata(gcf);

%% Setting of Phases
numphase = str2num(get(gui.handles.NumPh,'String'));
Phases(1:numphase) = struct(); % based on grain file type 2 phase value
pmslips = [gui.handles.pmlistslips1; gui.handles.pmlistslips2];
gui.config_data.Phases = struct();

for iph = 1:numphase
    Phases(iph).slip_strs = get(pmslips(iph), 'String');
    Phases(iph).slip_vals = get(pmslips(iph), 'Value');
    for ii = 1:1:size(Phases(iph).slip_vals,2)
        gui.config_data.Phases(iph).slips(ii) = slip_systems_plot(Phases(iph).slip_strs(Phases(iph).slip_vals(ii)));
    end
    if iph == 1
        gui.config_data.slips_1 = gui.config_data.Phases(iph).slips;
    elseif iph == 2
        gui.config_data.slips_2 = gui.config_data.Phases(iph).slips;
    end
end
if numphase == 1
    gui.config_data.slips_2 = 1;
end

%% Materials and Structures
list_material1 = get(gui.handles.pmMat1, 'String');
gui.config_data.num_material1  = get(gui.handles.pmMat1, 'Value');
material1      = list_material1(gui.config_data.num_material1, :);
gui.config_data.material1      = num2str(material1);

list_struct1 = get(gui.handles.pmStruct1, 'String');
gui.config_data.num_struct1  = get(gui.handles.pmStruct1, 'Value');
struct1      = list_struct1(gui.config_data.num_struct1, :);
gui.config_data.struct1      = num2str(struct1);

list_material2 = get(gui.handles.pmMat2, 'String');
gui.config_data.num_material2  = get(gui.handles.pmMat2, 'Value');
material2      = list_material2(gui.config_data.num_material2, :);
gui.config_data.material2      = num2str(material2);

list_struct2 = get(gui.handles.pmStruct2, 'String');
gui.config_data.num_struct2  = get(gui.handles.pmStruct2, 'Value');
struct2      = list_struct2(gui.config_data.num_struct2, :);
gui.config_data.struct2      = num2str(struct2);

guidata(gcf, gui);

end
