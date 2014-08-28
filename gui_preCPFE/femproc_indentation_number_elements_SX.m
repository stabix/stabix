% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_indentation_number_elements_SX
%% Calculation of the number of elements in the modelling of single crystal indentation
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_SX = guidata(gcf);

gui_SX.variables.K_elem_factor = gui_SX.variables.sample_rep/8;

gui_SX.variables.column_elements = 3 * (gui_SX.variables.K_elem_factor^2) * (gui_SX.variables.radial_divi + gui_SX.variables.box_elm_nz);

gui_SX.variables.quarter_elements = (2 * gui_SX.variables.box_elm_nx * gui_SX.variables.K_elem_factor) * (gui_SX.variables.radial_divi + gui_SX.variables.box_elm_nz)...
    + (gui_SX.variables.K_elem_factor*2*gui_SX.variables.radial_divi*gui_SX.variables.box_elm_nz);

if gui_SX.variables.r_center_frac ~= 0
    gui_SX.variables.quarter_elements = gui_SX.variables.quarter_elements + gui_SX.variables.column_elements;
end

gui_SX.variables.SX_num_elements = gui_SX.variables.quarter_elements * 4;

set(gui_SX.handles.num_elem ,'String',strcat(num2str(gui_SX.variables.SX_num_elements),' elements'));

guidata(gcf, gui_SX);

end