% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: get_slip_color.m 1231 2014-08-14 11:37:54Z d.mercier $
function slip_color = get_slip_color(structure, slip, varargin)
%% Function to define the color of the slip (MPIE convention)
% struct : Phase of material (bcc, fcc or hcp)
% slip : Index of the slip (1 to 57 for hcp - see in slip_systems.m)
% author: d.mercier@mpie.de

if nargin == 0
    structure = 'hcp';
    slip = 1;
end

if nargin < 2
    slip = 1;
end

if strcmp(structure, 'hcp') == 1
    if slip == 0
        slip_color = 'NaN';
    elseif (slip >= 1 && slip <= 3)                 % Basal <a>
        slip_color = [0,0,1];                       % Blue
    elseif (slip >= 4 && slip <= 6)                 % Prismatic <a> 1st order
        slip_color = [1,0,0];                       % Red
    elseif (slip >= 7 && slip <= 9)                 % Prismatic <a> 2nd order
        slip_color = [1,0.412,0.706];               % [0.137,0.545,0.137] = Hot Pink
    elseif (slip >= 10 && slip <= 15)               % Pyramidal 1st order <a>
        slip_color = [1,0.647,0];                   % [1,0.647,0] = orange
    elseif (slip >= 16 && slip <= 27)               % Pyramidal 1st order <c+a>
        slip_color = [1,1,0];                       % Yellow
    elseif (slip >= 28 && slip <= 33)               % Pyramidal 2nd order <c+a>
        slip_color = [0.678,1,0.184];               % [1,0.647,0] = yellow-green
    elseif slip >= 34 && slip <= 39                   %Twins
        slip_color = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    elseif slip >= 40 && slip <= 45                   %Twins
        slip_color = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    elseif slip >= 46 && slip <= 51                   %Twins
        slip_color = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    elseif slip >= 52 && slip <= 57                   %Twins
        slip_color = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    elseif slip == 100
        slip_color = {[0,0,1]; [1,0,0]; [1,0.412,0.706];...
            [1,0.647,0]; [1,1,0]; [0.678,1,0.184];...
            [0.137,0.545,0.137]};
    end
    
elseif strcmp(structure, 'bcc') == 1
    if slip == 0
        slip_color = 'NaN';
    elseif (slip >= 1 && slip <= 12)                % Slips {110}
        slip_color = [0,0,1];                       % Blue
    elseif (slip >= 13 && slip <= 24)               % Slips {211}
        slip_color = [1,0,0];                       % Red
    elseif (slip >= 25 && slip <= 48)               % Slips {321}
        slip_color = [1,0.647,0];                   %[1,0.647,0] = orange
    elseif (slip >= 49 && slip <= 60)               % Twins
        slip_color = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    elseif slip == 100
        slip_color = {[0,0,1]; [1,0,0]; [1,0.647,0];
            [0.137,0.545,0.137]};
    end
    
elseif strcmp(structure, 'fcc') == 1
    if slip == 0
        slip_color = 'NaN';
    elseif (slip >= 1 && slip <= 12)                % Slips
        slip_color = [0,0,1];                       % Blue
    elseif (slip >= 13 && slip <= 24)               % Twins
        slip_color = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    elseif slip == 100
        slip_color = {[0,0,1]; [0.137,0.545,0.137]};
    end
end

end