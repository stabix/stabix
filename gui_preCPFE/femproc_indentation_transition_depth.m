% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function h_trans = femproc_indentation_transition_depth(tip_radius, cone_angle, varargin)
%% Function used to calculate the transition depth between the spherical and the conical
% tip_radius : radius in micron of the spherical part of the tip
% cone_angle : half angle in degrees at the apex of the conical part of the tip
% From PhD Thesis of C. Zambaldi - "Micromechanical modeling of
% -TiAl based alloys" (2010).
% doi : 10.2370/9783832297176

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 2
    cone_angle = 90; % in degrees
    display(strcat('cone_angle =', num2str(cone_angle), ('degrees')));
end

if nargin < 1
    tip_radius = 1; % in microns
    display(strcat('tip_radius =', num2str(tip_radius), ('microns')));
    display('transition depth in microns');
end

h_trans = tip_radius * (1 - sind(cone_angle));

end