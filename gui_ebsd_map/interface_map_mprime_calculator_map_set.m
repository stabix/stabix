% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_mprime_calculator_map_set
%% Function used to set the calculation of m' parameter values for all GBs
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
gui = guidata(gcf);

%% Setting of Phases
gui.config_data.phase_number = ...
    interface_map_set_phase_number(gui.GF2_struct);
Phases(1:gui.config_data.phase_number) = struct(); % based on grain file type 2 phase value
pmslips = [gui.handles.pmlistslips1; gui.handles.pmlistslips2];
gui.config_data.Phases = struct();

for iph = 1:gui.config_data.phase_number
    Phases(iph).slip_strs = get(pmslips(iph), 'String');
    Phases(iph).slip_vals = get(pmslips(iph), 'Value');
    for ii = 1:1:size(Phases(iph).slip_vals,2)
        gui.config_data.Phases(iph).slips(ii) = slip_systems_plot(...
            Phases(iph).slip_strs(Phases(iph).slip_vals(ii)));
    end
    if iph == 1
        gui.config_data.slips_1 = gui.config_data.Phases(iph).slips;
    elseif iph == 2
        gui.config_data.slips_2 = gui.config_data.Phases(iph).slips;
    end
end
if gui.config_data.phase_number == 1
    gui.config_data.slips_2 = 1;
end

%% Materials and Structures
list_material = listMaterial;
list_struct = listPhase;

gui.config_data.num_material1 = get(gui.handles.pmMat1, 'Value');
material1 = list_material(gui.config_data.num_material1, :);
gui.config_data.material1 = material1{:};

gui.config_data.num_struct1 = get(gui.handles.pmStruct1, 'Value');
struct1 = list_struct(gui.config_data.num_struct1, :);
gui.config_data.struct1 = struct1{:};

gui.config_data.num_material2 = get(gui.handles.pmMat2, 'Value');
material2 = list_material(gui.config_data.num_material2, :);
gui.config_data.material2 = material2{:};

gui.config_data.num_struct2  = get(gui.handles.pmStruct2, 'Value');
struct2 = list_struct(gui.config_data.num_struct2, :);
gui.config_data.struct2 = struct2{:};

guidata(gcf, gui);

end