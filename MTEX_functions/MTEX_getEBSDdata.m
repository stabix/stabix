% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function MTEX_getEBSDdata
%% Import data with MTEX toolbox
% See in http://mtex-toolbox.github.io/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

try
    import_wizard('EBSD');
    
    MTEX_env = getMTEXpref;
    
    if exist('ebsd', 'var')
        MTEX_convert2TSLdata(ebsd);
        
        CoordSysVal = MTEX_setCoordSys(MTEX_env.xAxisDirection, ...
            MTEX_env.zAxisDirection);
        set(gui.handles.pmcoordsyst, 'Value', CoordSysVal);
    else
        commandwindow;
        display(['Reload your EBSD data and save it as a variable ', ...
            'named ''ebsd'' in the Matlab workspace']);
    end
    
catch err
    commandwindow;
    display(err.message);
    
end

end