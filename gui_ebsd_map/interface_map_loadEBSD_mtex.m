% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_loadEBSD_mtex
%% Function used to load EBSD data using MTEX toolbox
% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

gui = guidata(gcf);

if gui.flag.installation_mtex == 1
    
    mtex_getEBSDdata;
    
    gui.ebsdMTEX = evalin('base','ebsd'); % To import 'ebsd' variable from the workspace
    guidata(gcf, gui);
    
    try
        mtex_setEBSDdata;
    catch
        warning_commwin('Please reload your data and save it as a variable named ebsd !');
    end
else
    warning_commwin('MTEX not installed!');
end;

end