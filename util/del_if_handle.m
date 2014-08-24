% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: del_if_handle.m 978 2014-05-26 14:57:32Z d.mercier $
function err = del_if_handle(h)
% h: string of the handle variable name

try
    if eval('ishandle(h)')
        eval('delete(h)');
    end
catch err
    
end
