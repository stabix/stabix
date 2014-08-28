% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_MTEX_getEBSD
%% Import data with MTEX toolbox
% See in http://code.google.com/p/mtex/
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if gui.flag.installation_mtex == 1
    import_wizard('PoleFigure');
    set(gui.handles.pbPlotEBSDMap, 'Visible', 'on');
    set(gui.handles.pbPlotStatGrain, 'Visible', 'on');
    
else      
    warndlg('MTEX is not installed !', '!! Warning !!');
    
end

guidata(gcf, gui);

end