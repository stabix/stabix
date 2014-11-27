% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Material_A, Material_B] = plotGB_Bicrystal_get_material
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

Material_A = get_value_popupmenu(gui.handles.pmMatA, listMaterial);
Material_B = get_value_popupmenu(gui.handles.pmMatB, listMaterial);

end