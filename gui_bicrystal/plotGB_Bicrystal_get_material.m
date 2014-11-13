% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Material_A, Material_B] = plotGB_Bicrystal_get_material
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

listmater_str = listMaterial;
MaterialA_num = get(gui.handles.pmMatA, 'Value');
MaterialB_num = get(gui.handles.pmMatB, 'Value');
Material_A = char(listmater_str(MaterialA_num));
Material_B = char(listmater_str(MaterialB_num));

end