% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function GB = plotGB_Bicrystal_check_GB_data(GB)
%% Function to check validity of GB dataset

% author: d.mercier@mpie.de

%% Id grain
if isempty(GB.GrainA)
    GB.GrainA = GB.GrainB - 1;
    display('Missing grain number for grain A !');
end
if isempty(GB.GrainB)
    GB.GrainB = GB.GrainA + 1;
    display('Missing grain number for grain B !');
end

%% Grain orientation
if isempty(GB.eulerA)
    GB.eulerA = GB.eulerB;
    display('Missing Euler angles for grain A !');
end
if isempty(GB.eulerB)
    GB.eulerB = GB.eulerA;
    display('Missing Euler angles for grain B !');
end

%% Grain orientation (original)
if isempty(GB.eulerA_ori)
    GB.eulerA_ori = GB.eulerB_ori;
    display('Missing original Euler angles for grain A !');
end
if isempty(GB.eulerB_ori)
    GB.eulerB_ori = GB.eulerA_ori;
    display('Missing original Euler angles for grain B !');
end

%% Grain phase
if isempty(GB.Phase_A)
    GB.Phase_A = GB.Phase_B;
    display('Missing phase for grain A !');
end
if isempty(GB.Phase_B)
    GB.Phase_B = GB.Phase_A;
    display('Missing phase for grain B !');
end

%% GB inclination
if isempty(GB.GB_Inclination)
    GB.GB_Inclination = 90;
    display('Missing grain boundary inclination !');
end

%% GB trace angle
if isempty(GB.GB_Trace_Angle)
    GB.GB_Trace_Angle = 0;
    display('Missing grain boundary trace angle !');
end

%% GB number
if isempty(GB.GB_Number)
    GB.GB_Number = 1;
    display('Missing grain boundary number !');
end

%% Active GB
if isempty(GB.active_GB)
    GB.GB_Number = GB.GB_Number;
    display('Missing active grain boundary number !');
end

%% Materials
if isempty(GB.Material_A)
    GB.Material_A = GB.Material_B;
    display('Missing material for grain A !');
end
if isempty(GB.Material_B)
    GB.Material_B = GB.Material_A;
    display('Missing material for grain B !');
end

% c/a ratio
if isempty(GB.ca_ratio_A)
    GB.ca_ratio_A = GB.ca_ratio_B;
    display('Missing c_a ratio for grain A !');
end
if isempty(GB.ca_ratio_B)
    GB.ca_ratio_B = GB.ca_ratio_A;
    display('Missing c_a ratio for grain B !');
end

end