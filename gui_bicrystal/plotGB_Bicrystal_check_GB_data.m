% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function GB = plotGB_Bicrystal_check_GB_data(GB)
%% Function to check validity of GB dataset

% author: d.mercier@mpie.de

%% Id grain
if isempty(GB.GrainA)
    GB.GrainA = GB.GrainB - 1;
    disp('Missing grain number for grain A !');
end
if isempty(GB.GrainB)
    GB.GrainB = GB.GrainA + 1;
    disp('Missing grain number for grain B !');
end

%% Grain orientation
if isempty(GB.eulerA)
    GB.eulerA = GB.eulerB;
    disp('Missing Euler angles for grain A !');
end
if isempty(GB.eulerB)
    GB.eulerB = GB.eulerA;
    disp('Missing Euler angles for grain B !');
end

%% Grain orientation (original)
if isempty(GB.eulerA_ori)
    GB.eulerA_ori = GB.eulerB_ori;
    disp('Missing original Euler angles for grain A !');
end
if isempty(GB.eulerB_ori)
    GB.eulerB_ori = GB.eulerA_ori;
    disp('Missing original Euler angles for grain B !');
end

%% Grain phase
if isempty(GB.Phase_A)
    GB.Phase_A = GB.Phase_B;
    disp('Missing phase for grain A !');
end
if isempty(GB.Phase_B)
    GB.Phase_B = GB.Phase_A;
    disp('Missing phase for grain B !');
end

%% GB inclination
if isempty(GB.GB_Inclination)
    GB.GB_Inclination = 90;
    disp('Missing grain boundary inclination !');
end

%% GB trace angle
if isempty(GB.GB_Trace_Angle)
    GB.GB_Trace_Angle = 0;
    disp('Missing grain boundary trace angle !');
end

%% GB number
if isempty(GB.GB_Number)
    GB.GB_Number = 1;
    disp('Missing grain boundary number !');
end

%% Active GB
if isempty(GB.active_GB)
    GB.GB_Number = GB.GB_Number;
    disp('Missing active grain boundary number !');
end

%% Materials
if isempty(GB.Material_A)
    GB.Material_A = GB.Material_B;
    disp('Missing material for grain A !');
end
if isempty(GB.Material_B)
    GB.Material_B = GB.Material_A;
    disp('Missing material for grain B !');
end

% c/a ratio
if isempty(GB.ca_ratio_A)
    GB.ca_ratio_A = GB.ca_ratio_B;
    disp('Missing c_a ratio for grain A !');
end
if isempty(GB.ca_ratio_B)
    GB.ca_ratio_B = GB.ca_ratio_A;
    disp('Missing c_a ratio for grain B !');
end

end