% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function MTEX_getEBSD
%% Import data with MTEX toolbox
% See in http://code.google.com/p/mtex/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

try
    import_wizard('PoleFigure');
    
catch err 
    commandwindow;
    display(err);
    
end

end