% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_save_data(interface)
%% Function used to save active data for the generation of procedure file for Marc Mentat
% interface: type of interface (1 for SX or 2 for BX meshing interface)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if strcmp(gui.config.CPFEM.simulation_code, 'GENMAT') == 1
    config_all_data                 = catstruct(gui.GB, gui.config_CPFEM, gui.variables);
    config_all_data.orientation_grA = config_all_data.eulerA;
    config_all_data.orientation_grB = config_all_data.eulerB;
    
elseif strcmp(gui.config.CPFEM.simulation_code, 'DAMASK') == 1
    
    femproc_load_YAML_material_file(interface);
    gui = guidata(gcf); guidata(gcf, gui);
    
    if gui.GB.number_phase == 1
        config_all_data                 = catstruct(gui.GB, gui.config_CPFEM, gui.variables, gui.config_material);
        config_all_data.orientation_grA = config_all_data.eulerA;
        config_all_data.orientation_grB = config_all_data.eulerB;
    else
        config_all_data                 = catstruct(gui.GB, gui.config_CPFEM, gui.variables, gui.config_materialA, gui.config_materialB);
        config_all_data.orientation_grA = config_all_data.eulerA;
        config_all_data.orientation_grB = config_all_data.eulerB;
    end
    
else
    display('No CPFEM code given in YAML CPFEM config. file !');
    
end

% Save SX or BX data into a .mat format
save(gui.GB.Titlegbdatacompl, '-struct', 'config_all_data');

guidata(gcf, gui);

% Also writing the bicrystal data into a YAML file which can be read in any editor
%Titlegbdatacompl_YAML=strcat(config_all_data.titlegbdatacompl, '.yaml');
%WriteYaml(Titlegbdatacompl_YAML, config_all_data);

end
