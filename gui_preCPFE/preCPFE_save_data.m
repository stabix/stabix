% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_save_data
%% Function used to save active data for the generation of procedure file for Marc Mentat or Abaqus

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if strcmp(gui.config.CPFEM.simulation_code, 'GENMAT') == 1
    config_all_data = catstruct(...
        gui.GB, ...
        gui.config.CPFEM, ...
        gui.variables);
    config_all_data.orientation_grA = config_all_data.eulerA;
    config_all_data.orientation_grB = config_all_data.eulerB;
    
elseif strcmp(gui.config.CPFEM.simulation_code, 'DAMASK') == 1
    
    preCPFE_load_YAML_material_file;
    gui = guidata(gcf); guidata(gcf, gui);
    
    if gui.GB.number_phase == 1
        config_all_data = catstruct(...
            gui.GB, ...
            gui.config.CPFEM, ...
            gui.variables, ...
            gui.config_material);
    else
        config_all_data = catstruct(gui.GB, ...
            gui.config.CPFEM, ...
            gui.variables, ...
            gui.config_materialA, ...
            gui.config_materialB);
    end
    
    config_all_data.orientation_grA = config_all_data.eulerA;
    if strcmp(gui.GB.active_data, 'BX') == 1
        config_all_data.orientation_grB = config_all_data.eulerB;
    end
    
else
    disp('No CPFEM code given in YAML CPFEM config. file !');
    
end

% Save SX or BX data into a .mat format
save(gui.GB.Titlegbdatacompl, '-struct', 'config_all_data');

guidata(gcf, gui);

end