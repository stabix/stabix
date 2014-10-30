% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_gb_distance
%% Function to measure the distance between the same grain boundaries
% before and after polishing

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if gui.flag.overlay == 0
    warning('Please, overlay images before !'); beep; commandwindow;
end

zoom out;

gui.config_map.h_dist = imdistline(gca, [450 500], [300 300]);
api = iptgetapi(gui.config_map.h_dist);
fcn = makeConstrainToRectFcn('imline', ...
    get(gca, 'XLim'),...
    get(gca, 'YLim'));

setLabelVisible(gui.config_map.h_dist, false);
api.setDragConstraintFcn(fcn);

guidata(gcf, gui);

end