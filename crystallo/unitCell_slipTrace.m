% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [h_cell, h_trace] = unitCell_slipTrace(slip, euler, phase, ...
    ca_ratio, shiftXYZ, length_trace, trace_frac, varargin)
%% Function to plot the unit cell and the slip traces
% slip : slip number for the plot of the slip traces at the surface of the sample
% (e.g. from 1 to 57 for hcp - see in slip_systems.m)
% euler : Euler angles in degree of the grain
% phase : Phase of the grain
% ca_ratio : c/a ratio of the material if hcp phase
% shiftXYZ : coordinates of the point where to plot the slip trace (-->
% corresponding to the middle of the segment plotted for the slip traces).
% length_trace : Length of the trace (factor)
% trace_frac : Fraction of the length trace

% author: d.mercier@mpie.de

if nargin == 0
    slip = randi(57);
    euler = randBunges;
    phase = 'hcp';
    lpTi = latt_param('Ti', phase);
    ca_ratio = lpTi(3);
    shiftXYZ = [0;0;1];
    length_trace = 1;
    trace_frac = 0;
end

figure;

if strcmp(phase, 'fcc') == 1
    h_cell = vis_fcc(euler,slip);
elseif strcmp(phase, 'bcc') == 1
    h_cell = vis_bcc(euler,slip);
elseif strcmp(phase, 'hcp') == 1
    h_cell = vis_hex(euler,slip);
end

h_trace = plot_slip_traces(slip, euler, phase, ca_ratio, ...
    shiftXYZ, length_trace, trace_frac);

end