% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_setmap_TSL_data
%% Function used to set the map interface
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

% Get data from encapsulation
gui = guidata(gcf);

GF2  = gui.GF2_struct.data;
sGF2 = size(GF2);
GF2_phase = 2;

% Loop to set number of phases based on grain file type 2
for ng = 1:sGF2(1)
    % If only 1 phase, index = 0.
    % If 2 phases, indexes are 1 and 2.
    % So, this line of code is to have always for phase 1, index=1 !
    if GF2(ng, 10) == 0
        GF2(ng, 10) = 1;
        GF2_phase = 1;
    end
end

if GF2_phase == 1
    set(gui.handles.NumPh, 'String', 1);
elseif GF2_phase == 2
    set(gui.handles.NumPh, 'String', 2);
end

guidata(gcf, gui);
interface_map_material_definition;
gui = guidata(gcf);

guidata(gcf, gui);

end