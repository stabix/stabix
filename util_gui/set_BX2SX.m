% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function GB = set_BX2SX(gdata, activeGrain)
%% Function used to convert BX data to SX data (for scratch test)
% gdata: data encapsulated into the GUI
% activeGrain: grain where to do/to start indentation/scratch test

% author: d.mercier@mpie.de

GB = gdata.GB;

if gdata.GB.GrainA == activeGrain
    GB.GrainB = gdata.GB.GrainA;
    GB.Material_B = gdata.GB.Material_A;
    GB.Phase_B = gdata.GB.Phase_A;
    GB.eulerB = gdata.GB.eulerA;
else
    GB.GrainA = gdata.GB.GrainB;
    GB.Material_A = gdata.GB.Material_B;
    GB.Phase_A = gdata.GB.Phase_B;
    GB.eulerA = gdata.GB.eulerB;
end

gdata.GB.number_phase = 1;

end