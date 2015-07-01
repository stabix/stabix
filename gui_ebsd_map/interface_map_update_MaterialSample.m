% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_update_MaterialSample
%% Update popup-menus for Material and Sample definitions

% author: d.mercier@mpie.de

gui = guidata(gcf);

gui.config_map = interface_map_load_YAML_config_file;

set(gui.handles.Choice_material_pm, 'String', gui.config_map.Material_IDs);

set(gui.handles.Choice_sample_pm, 'String', gui.config_map.Sample_IDs);

set(gui.handles.Choice_material_pm, 'Value', ...
    find(cell2mat(strfind(gui.config_map.Material_IDs, ...
    gui.config_map.Material_ID))));

set(gui.handles.Choice_sample_pm, 'Value', ...
    find(cell2mat(strfind(gui.config_map.Sample_IDs, ...
    gui.config_map.Sample_ID))));

guidata(gcf, gui);

end