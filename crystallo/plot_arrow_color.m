% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: plot_arrow_color.m 1231 2014-08-14 11:37:54Z d.mercier $
function arrowcolor = plot_arrow_color(structure, slip, varargin)
%% Function to define the color of the arrow (slip direction) in bicrystal plot
% structure : structure of the given material (hcp, bcc, fcc, dia, tet or bct)
% slip: index of the slip obtained from the function "slip_systems"

if nargin == 0
    structure = 'hcp';
    slip = 1;
end

if nargin < 2
    slip = 1;
end

if strcmp(structure, 'hcp') == 1
    if (slip >= 1 && slip <= 3)                     % Basal <a>
        arrowcolor = 'b';
    elseif (slip >= 4 && slip <= 6)                 % Prismatic <a> 1st order
        arrowcolor = 'r';
    elseif (slip >= 7 && slip <= 9)                 % Prismatic <a> 2nd order
        arrowcolor = [1,0.412,0.706];               % [0.137,0.545,0.137] = Hot Pink
    elseif (slip >= 10 && slip <= 15)               % Pyramidal 1st order <a>
        arrowcolor = [1,0.647,0];                   % [1,0.647,0] = orange
    elseif (slip >= 16 && slip <= 27)               % Pyramidal 1st order <c+a>
        arrowcolor = 'y';
    elseif (slip >= 28 && slip <= 33)               % Pyramidal 2nd order <c+a>
        arrowcolor = [0.678,1,0.184];               % [1,0.647,0] = yellow-green
    elseif (slip >= 34 && slip <= 57)               % Twins
        arrowcolor = [0.137,0.545,0.137];           % [0.137,0.545,0.137] = Green forest
    end
    
elseif strcmp(structure, 'bcc') == 1
    if (slip >= 1 && slip <= 12)                    % Slips {110}
        arrowcolor = 'b';
    elseif (slip >= 13 && slip <= 24)               % Slips {211}
        arrowcolor = 'r';
    elseif (slip >= 25 && slip <= 48)               % Slips {321}
        arrowcolor = [1,0.647,0];                   %[1,0.647,0] = orange
    elseif (slip >= 49 && slip <= 60)               % Twins
        arrowcolor = [0.137,0.545,0.137];           % [0.137,0.545,0.137]=Green forest
    end
    
elseif strcmp(structure, 'fcc') == 1
    if (slip >= 1 && slip <= 12)                    % Slips
        arrowcolor = 'b';
    elseif (slip >= 13 && slip <= 24)               % Twins
        arrowcolor = [0.137,0.545,0.137];
    end
    
end
