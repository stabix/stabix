% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: check_TSL_data.m 1200 2014-08-05 09:52:15Z d.mercier $
function check_TSL_data(eul_rot0, eul_rot90ND, struct, varargin)
%% Function to check TSL-OIM data
% eul_rot0 : Euler angles in degrees with a rotation of 0°
% eul_rot90ND : Euler angles in degrees with a rotation of 90°
% struct : structure of the sample ('hcp', 'bcc, 'fcc'...)
% author: c.zambaldi@mpie.de

if nargin < 3
    struct = 'hcp';
end

if nargin < 2
    eul_rot90ND = randBunges;
end

if nargin < 1
    eul_rot0 = randBunges;
end

figure('name','rot0')
vis_lattice(struct, eul_rot0);
axis on;
xyzlabel

figure('name','rot90')
vis_lattice(struct, eul_rot90ND);
axis on;
xyzlabel;

end