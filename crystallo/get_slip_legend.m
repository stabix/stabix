% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function legend_slip = get_slip_legend(structure, slip, varargin)
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
        legend_slip = 'No Slip !';
    elseif (slip >= 1 && slip <= 3)                 % Basal <a>
        legend_slip = 'Basal - <a>';
    elseif (slip >= 4 && slip <= 6)                 % Prismatic <a> 1st order
        legend_slip = 'Prism1 - <a>';
    elseif (slip >= 7 && slip <= 9)                 % Prismatic <a> 2nd order
        legend_slip = 'Prism2 - <a>';
    elseif (slip >= 10 && slip <= 15)               % Pyramidal 1st order <a>
        legend_slip = 'Pyr - <a>';
    elseif (slip >= 16 && slip <= 27)               % Pyramidal 1st order <c+a>
        legend_slip = 'Pyr1 - <c+a>';
    elseif (slip >= 28 && slip <= 33)               % Pyramidal 2nd order <c+a>
        legend_slip = 'Pyr2 - <c+a>';
    elseif slip >= 34 && slip <= 39                 %Twins T1
        legend_slip = 'Twin{10-12}<10-1-1>';
    elseif slip >= 40 && slip <= 45                 %Twins T2
        legend_slip = 'Twin{11-21}<-1-126>';
    elseif slip >= 46 && slip <= 51                 %Twins C1
        legend_slip = 'Twin{10-11}<10-1-2>';
    elseif slip >= 52 && slip <= 57                 %Twins C2
        legend_slip = 'Twin{11-22}<11-2-3>';
    elseif slip == 100
        legend_slip = {'Basal - <a>';...
            'Prism1 - <a>';'Prism2 - <a>';...
            'Pyr - <a>';'Pyr1 - <c+a>';...
            'Pyr2 - <c+a>';'Twins'};
    end
    
elseif strcmp(structure, 'bcc') == 1
    if slip == 0
        legend_slip = 'No Slip !';
    elseif (slip >= 1 && slip <= 12)                % Slips {110}
        legend_slip = 'Slip <111>{110}';
    elseif (slip >= 13 && slip <= 24)               % Slips {211}
        legend_slip = 'Slip <111>{112}';
    elseif (slip >= 25 && slip <= 48)               % Slips {321}
        legend_slip = 'Slip <111>{123}';
    elseif (slip >= 49 && slip <= 60)               % Twins
        legend_slip = 'Twin <111>{112}';
    elseif slip == 100
        legend_slip = {'Slip <111>{110}';...
            'Slip <111>{112}';'Slip <111>{123}';...
            'Twin <111>{112}'};
    end
    
elseif strcmp(structure, 'fcc') == 1
    if slip == 0
        legend_slip = 'No Slip !';
    elseif (slip >= 1 && slip <= 12)                % Slips
        legend_slip = 'Slip <110>{111}';
    elseif (slip >= 13 && slip <= 24)               % Twins
        legend_slip = 'Twin <112>{111}';
    elseif slip == 100
        legend_slip = {'Slip <110>{111}';...
            'Twin <112>{111}'};
    end
end

end