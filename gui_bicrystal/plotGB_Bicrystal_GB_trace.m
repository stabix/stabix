% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [gb_vec_norm, gb_vec, GB_arrow] = ...
    plotGB_Bicrystal_GB_trace(GB_trace_angle, varargin)
%% Function to update GB plot for a new GB trace
% GB_trace_angle: Trace angle of the grain boundary (in degrees)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Rotation of the vector
rotataxis = axisang2g([0;0;1],GB_trace_angle);
gb_vec = rotataxis.'*[1;0;0];

%% Setting of GB vector
gb_vec_norm = (gb_vec/norm(gb_vec)); % Normalization of the trace of the GB
gb1 = [0;0;0] - gb_vec;
gb2 = [0;0;0] + gb_vec;
GB_arrow = [gb1, gb2];

end