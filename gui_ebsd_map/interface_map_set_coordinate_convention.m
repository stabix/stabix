% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_set_coordinate_convention
%% Setting of the coordinates system (--> update of Euler angles)
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

set(gui.handles.pmparam2plot4GB,     'Value', 1);
set(gui.handles.pmparam2plot4Grains, 'Value', 1);
set(gui.handles.cbgrnum,             'Value', 0);
set(gui.handles.cbgbnum,             'Value', 0);
set(gui.handles.cbphase,             'Value', 0);
set(gui.handles.cbunitcell,          'Value', 1);
set(gui.handles.cbdatavalues,        'Value', 0);
set(gui.handles.scale_unitcell_bar,  'Value', 1);
 
set(gcf, 'CurrentAxes', gui.handles.AxisGBmap);
legend('off');

coord_idx = get(gui.handles.pmcoordsyst, 'Value');
coord_angles = listCoordAngles;
gui.COORDSYS_eulers = coordinate_convention(coord_angles(coord_idx));

%% Replot COORDSYS
del_if_handle(gui.handles.PlotMapAxis);
gui.handles.PlotMapAxis = axes('Position', [0.9 0.9 0.04 0.04]);
gui.handles.PlotCoordSys = ...
    interface_map_plot_coordsys(gui.COORDSYS_eulers);
axis off;
view([0,0,1]);
gui.flag.initialization = 1;
guidata(gcf, gui);

interface_map_init_microstructure;
gui = guidata(gcf); guidata(gcf, gui);

number_phase = str2double(get(gui.handles.NumPh,'String'));
interface_map_list_slips(...
    gui.handles.pmStruct1, ...
    gui.handles.pmStruct2, ...
    gui.handles.pmlistslips1, ...
    gui.handles.pmlistslips2, ...
    number_phase, 1, 1);

set(gui.handles.scale_gb_segments_bar, 'value', 0);
gui.flag.newAxisLim = 0;

guidata(gcf, gui);
interface_map_plotmap(0);
gui = guidata(gcf);

gui.flag.CalculationFlag = 0;
gui.flag.pmparam2plot_value4GB_functype_old = 0;
gui.flag.pmparam2plot_value4GB_old = 0;
gui.flag.initialization_axis = 0;
guidata(gcf, gui);

end