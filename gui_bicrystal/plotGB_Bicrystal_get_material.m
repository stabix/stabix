% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_get_material
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

listmater_str = {'Al';'Au';'Be';'Cd';'Co';'Cu';'Fe';'Mg';'Mo';'Nb';'Ni';'Ta';'Ti';'Sn';'Zn';'Zr'};
MaterialA_num = get(gui.handles.pmMatA, 'Value');
MaterialB_num = get(gui.handles.pmMatB, 'Value');
gui.GB.Material_A = char(listmater_str(MaterialA_num));
gui.GB.Material_B = char(listmater_str(MaterialB_num));

guidata(gcf, gui);

end
