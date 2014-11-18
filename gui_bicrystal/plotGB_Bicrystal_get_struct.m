% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Phase_A, Phase_B] = plotGB_Bicrystal_get_struct
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

liststruct_str = listPhase;
phA_num = get(gui.handles.pmStructA, 'Value');
phB_num = get(gui.handles.pmStructB, 'Value');
Phase_A = liststruct_str(phA_num);
Phase_B = liststruct_str(phB_num);

end