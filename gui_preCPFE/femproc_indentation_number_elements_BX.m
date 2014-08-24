% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: femproc_indentation_number_elements_BX.m 1202 2014-08-05 12:58:13Z d.mercier $
function femproc_indentation_number_elements_BX
%% Calculation of the number of elements in the modelling of bicrystal indentation
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_BX = guidata(gcf);

if gui_BX.variables.ind_dist ~= 0
    gui_BX.variables.BX_num_elements = 2*gui_BX.variables.box_elm_nx * gui_BX.variables.box_elm_nz *...
        (gui_BX.variables.box_elm_ny1 + gui_BX.variables.box_elm_ny2 + gui_BX.variables.box_elm_ny3);
else
    gui_BX.variables.BX_num_elements = 2*gui_BX.variables.box_elm_nx * gui_BX.variables.box_elm_nz *...
        (gui_BX.variables.box_elm_ny1 + gui_BX.variables.box_elm_ny3);
end


set(gui_BX.handles.num_elem ,'String',strcat(num2str(gui_BX.variables.BX_num_elements),' elements'));

guidata(gcf, gui_BX);

end
