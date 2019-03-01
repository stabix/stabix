% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [fpath, fname_GF2, fname_RB] = ...
    mtex_convert2TSLdata(ebsd, GrainCalc, varargin)
%% Function used to convert data loaded via the import_wizard of MTEX
% into TSL format files (GF2 and RB files)
% ebsd: MTEX structure variable
% angle_value: A grain is defined as a region, in which the misorientation
% of neighbored measurements is less than the given angle. Or using 'unitcell'
% method (omit voronoi decomposition and treat a unitcell lattice).

% See in http://mtex-toolbox.github.io

% author: d.mercier@mpie.de

if nargin < 2
    GrainCalc = 5; %Default value for misorientation angle
end

if nargin < 1
    mtex_getEBSDdata;
    ebsd = evalin('base','ebsd');
end

ebsd = ebsd('indexed');

if max(ebsd.phase) < 3
    %% Grains definition
    if ~strcmp(GrainCalc, 'unitcell')
        grains = calcGrains(ebsd, 'angle', GrainCalc * degree);
    else
        grains = calcGrains(ebsd, 'unitcell');
    end
    % subSet function to get only 1 grain
    
    % grains = smooth(grains,iter,..,param,val,..);
    
    %% Initialization of path
    fpath = get_stabix_root;
    
    %% Grain File type 2
    fname_GF2 = 'EBSD_data_from_MTEX_GF2.txt';
    
    fdata.title = 'EBSD data imported using import_wizard from MTEX toolbox';
    fdata.number_of_grains = grains.size(1);
    if max(ebsd.phase) == 0 || max(ebsd.phase) == 1
        fdata.eul_ang = (grains.meanOrientation.Euler) * 180/pi;
        grain_position = grains.centroid;
        fdata.phase = grains.phase;
    else
        eul_ang_1 = (grains(grains.phase==1).meanOrientation.Euler)*180/pi;
        eul_ang_2 = (grains(grains.phase==2).meanOrientation.Euler)*180/pi;
        fdata.eul_ang = [eul_ang_1;eul_ang_2];
        grain_position_1 = grains(grains.phase==1).centroid;
        grain_position_2 = grains(grains.phase==2).centroid;
        grain_position = [grain_position_1;grain_position_2];
        fdata.phase = [ones(1,length(grain_position_1)), 2*ones(1,length(grain_position_2))]';
    end
    fdata.x_positions = grain_position(:,1);
    fdata.y_positions = grain_position(:,2);
    fdata.grain_diameter = ((grains.area/pi).^0.5)./2;
    
    % Write TSL-OIM grain file type 2
    write_oim_grain_file_type2(fdata, fpath, fname_GF2);
    
    %% Reconstructed Boundaries file
    fname_RB = 'EBSD_data_from_MTEX_RB.txt';
    
    %p = patch('Faces',grains.boundary.F,'Vertices',grains.boundary.V,'FaceColor','w');
    %fdata.number_of_grain_boundaries = size(grains.boundary.F,1);
    
    [grains_x, grains_y] = centroid(grains);
    
    % From Voronoi's tessellation (faster but GBs segments are lost frome real microstructure)
    %     [fdata.GBvx, ...
    %         fdata.GBvy, ...
    %         fdata.GB2cells, ...
    %         fdata.flag_VorFailed] = ...
    %         neighbooring_edge_of_2cells(...
    %         grains_x', grains_y');
    
    %	 fdata.GBvx = fdata.GBvx';
    % 	 fdata.GBvy = fdata.GBvy';
    %	 fdata.GB2cells = fdata.GB2cells';
    
    % From MTEX (real microstructure, with all GBs segments --> very slow)
    gB = grains.boundary('indexed');
    fdata.GBvx = [gB.V(gB.F(:,1),1), gB.V(gB.F(:,2),1)];
    fdata.GBvy = [gB.V(gB.F(:,1),2), gB.V(gB.F(:,2),2)];
    fdata.GB2cells = gB.grainId;
    fdata.number_of_grain_boundaries = gB.length;
    
    %% Check of left and right grains
    %CoordSysVal = mtex_setCoordSys(xAxisDirection, zAxisDirection)
    
%     for ii = 1:gB.length
%         gbci = [fdata.GBvx(ii,1); fdata.GBvy(ii,1); 0];
%         gbcf = [fdata.GBvx(ii,2); fdata.GBvy(ii,2); 0];
%         grAcoord = grain_position(:,1);
%         grBcoord = grain_position(:,2);
%         
%         gb_vec = gbcf - gbci;                       % Trace of the GB
%         gb_vec_norm = (gb_vec/norm(gb_vec));        % Normalization of the trace of the GB
%         grgr_vec = grBcoord - grAcoord;
%         grgr_vec_norm = grgr_vec/norm(grgr_vec);    % Normalization of the trace of Grain to Grain
%         GrAGrB = cross(gb_vec_norm,grgr_vec_norm);
%         zvec = COORDSYS_eulers * [0;0;1];
%         
%         % test_vectors_orthogonality ???
%         
%         if sign(GrAGrB(3)) ~= sign(zvec)
%             fdata.GB2cells(ii,1) = id_grB;
%             fdata.GB2cells(ii,2) = id_grA;
%         end
%     end
    
    % Write TSL-OIM grain file type 2
    write_oim_reconstructed_boundaries_file(fdata, fpath, fname_RB);
else
    disp('Only permitted for a single phase or a 2 phases material!');
end

end
