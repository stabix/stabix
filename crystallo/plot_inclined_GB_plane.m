% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function GB_inclined = plot_inclined_GB_plane(GB_endpoint_1, ...
    GB_endpoint_2, GB_trace_angle, GB_inclination, varargin)
%% Function to update GB plot with a new inclination
% GB_endpoint_1: Coordinates 1 of GB segment (at the sample's surface) obtained from EBSD measurement
% GB_endpoint_2: Coordinates 2 of GB segment (at the sample's surface) obtained from EBSD measurement
% GB_trace_angle: Trace angle of GB segment (at the sample's surface) obtained from EBSD measurement
% GB_inclination: Inclination of the GB in the sample.
% author: d.mercier@mpie.de

if nargin == 0
    GB_endpoint_1 = [0;0;0];
    GB_endpoint_2 = [0;0;0];
    GB_trace_angle = randi(180);
    GB_inclination = randi(40,1) + 70;
    % 70-110° or round(rand(1)*100)+1 between 0 and 100°
end

GB_inclination = mod(GB_inclination, 180);

if norm(GB_endpoint_1) == 0 && norm(GB_endpoint_2) == 0
    rotataxis = axisang2g([0;0;1], GB_trace_angle);
    gb_vec = rotataxis.'*[1;0;0];
    gb_vec_norm = (gb_vec/norm(gb_vec));
    gb1 = GB_endpoint_1 - gb_vec_norm;
    gb2 = GB_endpoint_2 + gb_vec_norm;
    perp_gb1 = cross([0;0;1], gb2 - gb1);
else
    gb1 = GB_endpoint_1;
    gb2 = GB_endpoint_2;
    gb_vec = gb2 - gb1;
    gb_vec_norm = (gb_vec/norm(gb_vec));
    perp_gb1 = cross([0;0;1], gb_vec_norm);
end

if norm(GB_endpoint_1) == 0 && norm(GB_endpoint_2) == 0
    rotataxis = axisang2g(gb_vec, -GB_inclination);
    gb_new = rotataxis.'*perp_gb1;
    gb_new1 = gb_new - gb_vec_norm;
    gb_new2 = gb_new + gb_vec_norm;
else
    rotataxis = axisang2g(gb_vec, -GB_inclination);
    gb_new = rotataxis.'*perp_gb1;
    gb_new1 = gb_new + gb1;
    gb_new2 = gb_new + gb2;
end
GB_inclined = [gb1 gb2 gb_new1 gb_new2];

patch('Vertices', GB_inclined', 'Faces', [1 3 4 2], ...
    'FaceColor', 'k', 'FaceAlpha', 0.4);

end
