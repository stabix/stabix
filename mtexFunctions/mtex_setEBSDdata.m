% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function mtex_setEBSDdata
%% Import data with MTEX toolbox
% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

gui = guidata(gcf);

mtex_env = getMTEXpref;

if max(gui.ebsdMTEX.phase) == 0 || max(gui.ebsdMTEX.phase) == 1
    [fpath, fname_GF2, fname_RB] = mtex_convert2TSLdata(gui.ebsdMTEX, 5, ...
        gui.COORDSYS_eulers);
    
    % Set paths in the GUI
    set(gui.handles.FileGF2, 'String', fullfile(fpath, fname_GF2));
    set(gui.handles.FileRB, 'String', fullfile(fpath, fname_RB));
    gui.config_map.filename_grain_file_type2 = fname_GF2;
    gui.config_map.filename_reconstructed_boundaries_file = fname_RB;
    gui.config_map.pathname_grain_file_type2 = fpath;
    gui.config_map.pathname_reconstructed_boundaries_file = fpath;
    gui.flag.newDataFlag = 1;
    
    % Set coordinate sytem
    CoordSysVal = mtex_setCoordSys(mtex_env.xAxisDirection, ...
        mtex_env.zAxisDirection);
    set(gui.handles.pmcoordsyst, 'Value', CoordSysVal);
    
    % Set scan unit
    if strcmp(gui.ebsdMTEX.scanUnit, 'nm')
        set(gui.handles.pm_unit, 'Value', 1);
    elseif strcmp(gui.ebsdMTEX.scanUnit, 'um')
        set(gui.handles.pm_unit, 'Value', 2);
    elseif strcmp(gui.ebsdMTEX.scanUnit, 'mm')
        set(gui.handles.pm_unit, 'Value', 3);
    else
        warning('Can''t set the scan unit from imported EBSD data...');
    end
    
    % Encapsulation of data in the GUI
    guidata(gcf, gui);
    
    % Run the plot of the loaded EBSD data
    interface_map_set_coordinate_convention;
else
    display('Only permitted for a single phase!');
end

end