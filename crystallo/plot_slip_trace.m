% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h = plot_slip_trace(slip_plane_normal, plot_plane_normal, ...
    shiftXYZ, length_trace, trace_frac, varargin)
%% Function to plot the slip trace
% slip_plane_normal : Normal of the slip
% plot_plane_normal : Normal of the plane whre to plot the trace (surface of the sample --> [0;0;1])
% shiftXYZ : coordinates of the point where to plot the slip trace (-->
% correspond to the middle of the segment plotted for the slip traces).
% length_trace : Length of the trace (factor)
% trace_frac : Factor to plot only a outer part of the slip trace

% author: c.zambaldi@mpie.de

if nargin == 0
    slip_plane_normal = [1;0;0];
    plot_plane_normal = [0;0;1];
    shiftXYZ = [0;0;0];
    length_trace = 1;
    trace_frac = 0.5;
end

slip_trace = planenormals2trace(slip_plane_normal, plot_plane_normal);
p1 = shiftXYZ + slip_trace/2 * length_trace;
p2 = shiftXYZ - slip_trace/2 * length_trace;
p1_i = shiftXYZ + slip_trace/2 * trace_frac * length_trace;
p2_i = shiftXYZ - slip_trace/2 * trace_frac * length_trace;
h(1) = plot3([p1(1) p1_i(1)], [p1(2) p1_i(2)], [p1(3) p1_i(3)]);
h(2) = plot3([p2(1) p2_i(1)], [p2(2) p2_i(2)], [p2(3) p2_i(3)]);

end