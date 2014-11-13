% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_material_definition
%% Setting of Material and Structure lists based on the number of phases
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if str2double(get(gui.handles.NumPh, 'String')) == 1
    set([gui.handles.Mat1, gui.handles.pmMat1, gui.handles.Struct1,...
        gui.handles.pmStruct1, gui.handles.listslips1,...
        gui.handles.pmlistslips1], 'Visible', 'on');
    set([gui.handles.Mat2, gui.handles.pmMat2, gui.handles.Struct2,...
        gui.handles.pmStruct2, gui.handles.listslips2,...
        gui.handles.pmlistslips2], 'Visible', 'off');
end

if str2double(get(gui.handles.NumPh, 'String')) > 1
    set([gui.handles.Mat2, gui.handles.pmMat2, gui.handles.Struct2,...
        gui.handles.pmStruct2, gui.handles.listslips2,...
        gui.handles.pmlistslips2], 'Visible', 'on');
end

end
