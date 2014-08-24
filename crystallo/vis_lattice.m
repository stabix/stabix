% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: vis_lattice.m 1198 2014-08-05 09:13:00Z d.mercier $
function h_lattice = vis_lattice(lattice_type, eulers, slip, shiftXYZ, sz, plotAxes, fast, numph, line_width, varargin)
%% Function to plot lattice cell for hcp, bcc and fcc crystals
% lattice_type : hcp, bcc or fcc
% eulers : Bunge Euler angles in degrees
% slip : slip plane to plot
% shiftXYZ : translate the cell
% sz : sizeFactor multiplier
% plotAxes
% fast : do not change daspect or axis modes to gain performance
% numph : number of phases
% line_width
% authors: d.mercier@mpie.de/c.zambaldi@mpie.de

if nargin < 9
    line_width = 2;
end
if nargin < 8
    numph = 0;
end
if nargin < 7
    fast = 0;
end
if nargin < 6
    plotAxes = 0;
end

if nargin < 5
    sz = 1;
end
if nargin < 4
    shiftXYZ = [0,0,0]';
end
if nargin < 3
    slip = 0;
end
if nargin < 2
    eulers = randBunges(1);
end
if nargin < 1
    lattice_type = 'hcp';
end

if strcmp(lattice_type,'hcp') == 1
    h_lattice = vis_hex(eulers, slip, shiftXYZ, sz, plotAxes, fast, numph, line_width);
elseif strcmp(lattice_type,'fcc') == 1
    h_lattice = vis_fcc(eulers, slip, shiftXYZ, 1.5*sz, plotAxes, fast, numph, line_width);
elseif strcmp(lattice_type,'bcc') == 1
    h_lattice = vis_bcc(eulers, slip, shiftXYZ, 1.5*sz, plotAxes, fast, numph, line_width);
end
set(h_lattice, 'LineWidth', 2);

return