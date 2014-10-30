% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [h_reg, h_base] = gui_gbinc_plot_overlay(regd, fig_base)
%% Function to plot overlay of pictures

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

h_reg = imshow(regd); hold on;
h_base = imshow(ind2rgb(gray2ind(fig_base,3),[1,0,0;1,0,0;1,1,1]));
set(h_base, 'AlphaData', 0.5);

end