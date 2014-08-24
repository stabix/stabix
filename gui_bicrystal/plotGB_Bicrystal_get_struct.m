% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: plotGB_Bicrystal_get_struct.m 1201 2014-08-05 12:39:38Z d.mercier $
function plotGB_Bicrystal_get_struct
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

liststruct_str = {'hcp'; 'bcc'; 'fcc'};
phA_num = get(gui.handles.pmStructA, 'Value');
phB_num = get(gui.handles.pmStructB, 'Value');
gui.GB.Phase_A = liststruct_str(phA_num);
gui.GB.Phase_B = liststruct_str(phB_num);
guidata(gcf, gui);

end
