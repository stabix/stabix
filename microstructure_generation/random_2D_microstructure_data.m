% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: random_2D_microstructure_data.m 1244 2014-08-20 14:54:55Z d.mercier $
function rdm_microstructure_dataset = random_2D_microstructure_data (number_of_grains, resolution, varargin)
%% Function used to create random EBSD data based on TSL files (GF Type2 and RB file)
% number_of_grains : Number of grains for the Voronoi tesselation
% resolution : resolution along x and y axis for generation of seeds file
% (see documentation in http://damask.mpie.de/)
% author: d.mercier@mpie.de

if nargin < 2
    resolution = 100;
end

if nargin < 1
    number_of_grains = 20;
end

if number_of_grains < 3
    number_of_grains = 20;
    display('3 Grains are needed at least for Voronoi tessalation...');
end

rdm_microstructure_dataset = struct();

%% Tesselation de Voronoi
% Random EBSD map (with 10 grains)
rdm_microstructure_dataset.x_positions = rand(number_of_grains, 1);   % Grains coordinates
rdm_microstructure_dataset.y_positions = rand(number_of_grains, 1);   % Grains coordinates
rdm_microstructure_dataset.z_positions = 0;   % Grains coordinates

% GBs endpoints coordinates
%[vx, vy] = voronoi(rdm_TSL_dataset.x,rdm_TSL_dataset.y);

% Script to determine neighbooring grains (not used here)
rawdata(:,1) = rdm_microstructure_dataset.x_positions;
rawdata(:,2) = rdm_microstructure_dataset.y_positions;
[V_voronoin, C_voronoin] = voronoin(rawdata);

%for i=1:length(C_voronoin), disp(C_voronoin{i}); end

vn = sparse (number_of_grains, number_of_grains);
for ii = 1 : number_of_grains
    for jj = ii + 1 : number_of_grains
        s = size (intersect (C_voronoin{ii}, C_voronoin{jj}));
        if ( 1 < s(2) )
            vn(ii, jj) = 1;
        end
    end
end

% GBs endpoints coordinates
[rdm_microstructure_dataset.GBvx, rdm_microstructure_dataset.GBvy, rdm_microstructure_dataset.GB2cells(:,:), rdm_microstructure_dataset.flag_VorFailed] = ...
    neighbooring_edge_of_2cells(rdm_microstructure_dataset.x_positions', rdm_microstructure_dataset.y_positions');

% GBs coordinates
GB(1,:) = rdm_microstructure_dataset.GBvx(2,:) - rdm_microstructure_dataset.GBvx(1,:);
GB(2,:) = rdm_microstructure_dataset.GBvy(2,:) - rdm_microstructure_dataset.GBvy(1,:);
GB(3,:) = zeros;

% flag is to know if the voronoiDiagram fails (degenerated case?)

if rdm_microstructure_dataset.flag_VorFailed
    disp('voronoiDiagram fails (degenerated case?)');
    rdm_microstructure_dataset.rdm_TSL_data_flag = false;
    return
else
    rdm_microstructure_dataset.rdm_TSL_data_flag = true;
end

rdm_microstructure_dataset.title = 'Random EBSD Data';
rdm_microstructure_dataset.user = 'No user - Random data';

rdm_microstructure_dataset.number_of_grains = number_of_grains;
rdm_microstructure_dataset.number_of_grain_boundaries = length(GB);
rdm_microstructure_dataset.eul_ang = randBunges(number_of_grains);
rdm_microstructure_dataset.phase = zeros(number_of_grains,1);
rdm_microstructure_dataset.edge_grain = ones(number_of_grains,1);
rdm_microstructure_dataset.grain_diameter = 10*ones(number_of_grains,1);
for ii = 1:length(GB);
    rdm_microstructure_dataset.gb_length(1,ii) = norm(GB(ii));
    
    CosTheta = dot(GB(:,ii),[1,0,0])/(norm(GB(:,ii))*norm([1,0,0]));
    rdm_microstructure_dataset.gb_trace_angle(1,ii) = acos(CosTheta)*180/pi;
end

rdm_microstructure_dataset.GBvx = rdm_microstructure_dataset.GBvx';
rdm_microstructure_dataset.GBvy = rdm_microstructure_dataset.GBvy';
rdm_microstructure_dataset.GB2cells = rdm_microstructure_dataset.GB2cells';

rdm_microstructure_dataset.confidence_index = ones((resolution*resolution), 1);
rdm_microstructure_dataset.image_quality = ones((resolution*resolution), 1);
rdm_microstructure_dataset.phase_ang = ones((resolution*resolution), 1);
rdm_microstructure_dataset.detector_intensity  = ones((resolution*resolution), 1);
rdm_microstructure_dataset.fit = ones((resolution*resolution), 1);

rdm_microstructure_dataset.x_pixel_pos = 1:(resolution*resolution);
rdm_microstructure_dataset.y_pixel_pos = 1:(resolution*resolution);

rdm_microstructure_dataset.x_step = resolution;
rdm_microstructure_dataset.y_step = resolution;
rdm_microstructure_dataset.n_col_odd = resolution;
rdm_microstructure_dataset.n_col_even = resolution;
rdm_microstructure_dataset.n_rows = resolution;

end
