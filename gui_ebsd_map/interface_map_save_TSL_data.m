% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_save_TSL_data
%% Function used to save TSL dataset
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

FolderName_GF2_file = char(strcat(timestamp_make, '_GF2_file_smoothed', '.txt'));
FolderName_RB_file = char(strcat(timestamp_make, '_RB_file_smoothed', '.txt'));

% Set negative values for y coordinates in RB file (to respect EBSD setting)
gui.RB_smoothed_struct.GBvy = -gui.RB_smoothed_struct.GBvy;

% Write GF2 with smoothed data
write_oim_grain_file_type2(gui.GF2_smoothed_struct, gui.config_map.pathname_grain_file_type2, FolderName_GF2_file);

% Write RB file with smoothed data
write_oim_reconstructed_boundaries_file(gui.RB_smoothed_struct, gui.config_map.pathname_reconstructed_boundaries_file, FolderName_RB_file);

helpdlg('Smoothed GBs saved in GF type2 and RB file!');

guidata(gcf, gui);

end