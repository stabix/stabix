%% Copyright 2014 MERCIER David
function list_Location = listLocationLegend

list_Location = {...
    'North'; ... % Inside top of axes
    'South'; ... % Inside bottom of axes
    'East'; ... % Inside right of axes
    'West'; ... % Inside left of axes
    'Northeast'; ... % Inside top-right of axes (default for 2-D axes)
    'Northwest'; ... % Inside top-left of axes
    'Southeast'; ... % Inside bottom-right of axes
    'Southwest'; ... % Inside bottom-left of axes
    'Northoutside'; ... % Above the axes
    'Southoutside'; ... % Below the axes
    'Eastoutside'; ... % To the right of the axes
    'Westoutside'; ... % To the left of the axes
    'Northeastoutside'; ... % Outside top-right corner of the axes (default for 3-D axes)
    'Northwestoutside'; ... % Outside top-left corner of the axes
    'Southeastoutside'; ... % Outside bottom-right corner of the axes
    'Southwestoutside'; ... % Outside bottom-left corner of the axes
    'Best'; ... % Inside axes where least conflict with data in plot
    'Bestoutside'; ... % To the right of the axes
    };

end