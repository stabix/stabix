% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_gbinc_save_overlay
%% Function to save overlay of picture

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

im = screencapture(gcf);
imwrite(im, [timestamp_make, gui.config_map.cpfilename, '.png'], 'png');

guidata(gcf, gui);

end