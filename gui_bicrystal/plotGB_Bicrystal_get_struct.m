% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Phase_A, Phase_B] = plotGB_Bicrystal_get_struct
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

Phase_A = get_value_popupmenu(gui.handles.pmStructA, listPhase);
Phase_B = get_value_popupmenu(gui.handles.pmStructB, listPhase);

end