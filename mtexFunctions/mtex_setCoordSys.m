% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function CoordSysVal = mtex_setCoordSys(xAxisDirection, zAxisDirection)
%% Import data with MTEX toolbox
% See in http://mtex-toolbox.github.io/

% authors d.mercier@mpie.de

if strcmp(xAxisDirection, 'east') && strcmp(zAxisDirection, 'outOfPlane')
    CoordSysVal = 1;
elseif strcmp(xAxisDirection, 'north') && strcmp(zAxisDirection, 'outOfPlane')
    CoordSysVal = 2;
elseif strcmp(xAxisDirection, 'west') && strcmp(zAxisDirection, 'outOfPlane')
    CoordSysVal = 3;
elseif strcmp(xAxisDirection, 'south') && strcmp(zAxisDirection, 'outOfPlane')
    CoordSysVal = 4;
elseif strcmp(xAxisDirection, 'east') && strcmp(zAxisDirection, 'intoPlane')
    CoordSysVal = 5;
elseif strcmp(xAxisDirection, 'north') && strcmp(zAxisDirection, 'intoPlane')
    CoordSysVal = 6;
elseif strcmp(xAxisDirection, 'west') && strcmp(zAxisDirection, 'intoPlane')
    CoordSysVal = 7;
elseif strcmp(xAxisDirection, 'south') && strcmp(zAxisDirection, 'intoPlane')
    CoordSysVal = 8;
end

end