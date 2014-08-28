% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function slip_plot  =  slip_systems_plot(slip2plot, varargin)
%% Function to select the slip or twin to plot
% slip2plot: slip to plot for hcp, fcc or bcc phase
% author: d.mercier@mpie.de

if nargin == 0
    slip2plot  =  1;
end

if strcmp(slip2plot, 'No slips & No Twins') == 1
    slip_plot = 0;
    
elseif strcmp(slip2plot, 'All Slips') == 1
    slip_plot = 1;
    
elseif strcmp(slip2plot, 'Basal') == 1 || strcmp(slip2plot, 'Slips {110}') == 1
    slip_plot = 2;
    
elseif strcmp(slip2plot, 'Prism1<a>') == 1 || strcmp(slip2plot, 'Slips {211}') == 1
    slip_plot = 3;
    
elseif strcmp(slip2plot, 'Prism2<a>') == 1 || strcmp(slip2plot, 'Slips {321}') == 1
    slip_plot = 4;
    
elseif strcmp(slip2plot, 'Pyram1<a>') == 1
    slip_plot = 5;
    
elseif strcmp(slip2plot, 'Pyram1<c+a>') == 1
    slip_plot = 6;
    
elseif strcmp(slip2plot, 'Pyram2<c+a>') == 1
    slip_plot = 7;
    
elseif strcmp(slip2plot, 'All Twins') == 1
    slip_plot = 8;
    
elseif strcmp(slip2plot, 'All Slips and Twins') == 1
    slip_plot = 9;
    
end