% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [fpath, fname_GF2, fname_RB] = ...
    mtex_convert2TSLdata(ebsd, angle_value, varargin)
%% Function used to convert data loaded via the import_wizard of MTEX
% into TSL format files (GF2 and RB files)
% ebsd: MTEX structure variable
% angle_value: A grain is defined as a region, in which the misorientation
% of neighbored measurements is less than the given angle.

% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

if nargin < 2
    angle_value = 5;
end

if nargin < 1
    import_wizard;
end

%% Grains definition
grains = calcGrains(ebsd, 'angle', angle_value * degree);
% subSet function to get only 1 grain

% grains = smooth(grains,iter,..,param,val,..);

%% Initialization of path
fpath = get_stabix_root;

%% Grain File type 2
fname_GF2 = 'importEBSDdata_frommtex_GF2.txt';

fdata.title = 'EBSD data imported using import_wizard from MTEX toolbox';
fdata.number_of_grains = grains.size(1);
fdata.eul_ang = (grains.meanOrientation.Euler) * 180/pi;
grain_position = grains.centroid;
fdata.x_positions = grain_position(:,1);
fdata.y_positions = grain_position(:,2);
fdata.phase = nonzeros(grains.phaseId);
fdata.grain_diameter = ((grains.area/pi).^0.5)./2;

% Write TSL-OIM grain file type 2
write_oim_grain_file_type2(fdata, fpath, fname_GF2);

%% Reconstructed Boundaries file
fname_RB = 'importEBSDdata_frommtex_RB.txt';

%p = patch('Faces',grains.boundary.F,'Vertices',grains.boundary.V,'FaceColor','w');
%fdata.number_of_grain_boundaries = size(grains.boundary.F,1);

[grains_x, grains_y] = centroid(grains);

[fdata.GBvx, ...
    fdata.GBvy, ...
    fdata.GB2cells, ...
    fdata.flag_VorFailed] = ...
    neighbooring_edge_of_2cells(...
    grains_x', grains_y');

fdata.GBvx = fdata.GBvx';
fdata.GBvy = fdata.GBvy';
fdata.GB2cells = fdata.GB2cells';
fdata.number_of_grain_boundaries = size(fdata.GBvx, 1);

% Write TSL-OIM grain file type 2
write_oim_reconstructed_boundaries_file(fdata, fpath, fname_RB);

end
