% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_gb_distance
%% Function to measure the distance between the same grain boundaries
% before and after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if gui.flag.overlay == 0
    warning_commwin('Please, overlay images before !', 1);
end

zoom out;

gui.config_map.h_dist = imdistline_set([450 500],[300 300], 'blue');

guidata(gcf, gui);

end