% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h_trace = plot_slip_traces(slip, euler, phase, ca_ratio, ...
    shiftXYZ, length_trace, trace_frac, varargin)
%% Function to plot the slip traces
% slip : slip number for the plot of the slip traces at the surface of the sample
% (e.g. from 1 to 57 for hcp - see in slip_systems.m)
% euler : Euler angles in degree of the grain
% phase : Phase of the grain
% ca_ratio : c/a ratio of the material if hcp phase
% shiftXYZ : coordinates of the point where to plot the slip trace (-->
% corresponding to the middle of the segment plotted for the slip traces).
% length_trace : Length of the trace (factor)
% trace_frac : Fraction of the length trace

% author: c.zambaldi@mpie.de

if nargin == 0
    slip = randi(57);
    euler = randBunges;
    phase = 'hcp';
    lpTi = listLattParam('Ti', phase);
    ca_ratio = lpTi(3);
    shiftXYZ = [0;0;1];
    length_trace = 1;
    trace_frac = 0;
end

%% Set the encapsulation of data
rotmat = eulers2g(euler);

all_slips_grain = slip_systems(phase, 9);

slip_norm = all_slips_grain(1,:,slip);

if strcmp(phase, 'hcp') == 1
    slip_norm_cart = millerbravaisplane2cart(slip_norm, ca_ratio)';
else
    slip_norm_cart = slip_norm;
end

slip_norm_cart_rot = rotmat.'*slip_norm_cart';

h_trace = plot_slip_trace(slip_norm_cart_rot, [0;0;1], ...
    shiftXYZ, length_trace, trace_frac);

% Setting of the color of the slip trace
slip_color = get_slip_color(phase, slip);
set(h_trace, 'Color', slip_color);
set(h_trace, 'Linewidth', 3);
set(h_trace, 'Clipping', 'on');

end
