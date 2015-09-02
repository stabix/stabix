% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function mtex_getEBSDdata
%% Import data with MTEX toolbox
% See in http://mtex-toolbox.github.io/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

try
    import_wizard('EBSD');

catch err
    commandwindow;
    display(err.message);
    
end

uiwait(gcf);

end