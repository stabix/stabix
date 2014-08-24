% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: write_oim_ang_file.m 1233 2014-08-14 12:28:10Z d.mercier $
function write_oim_ang_file(fdata, fpath, fname, varargin)
%% Function used to write TSL-OIM .Ang file
% fname : Name of the .Ang file to create
% fpath : Path where to store the .Ang file
% fdata : Data to store in the .Ang file
% fdata.title : For the 1st line of the headerlines of .Ang file
% fdata.user
% fdata.eul_ang (in radians)
% fdata.x_pixel_pos
% fdata.y_pixel_pos
% fdata.image_quality
% fdata.confidence_index
% fdata.phase : Number of phase
% fdata.detector_intensity
% fdata.fit

% The fields of each line in the body of the file are as follows:
% j1 F j2 x y IQ CI Phase ID Detector Intensity Fit
% where:
% j1,F,j2: Euler angles (in radians) in Bunge's notation for describing the lattice orientations and are given in radians.
% A value of 4 is given to each Euler angle when an EBSP could not be indexed. These points receive negative confidence index values when read into an OIM dataset.
% x,y: The horizontal and vertical coordinates of the points in the scan, in microns. The origin (0,0) is defined as the top-left corner of the scan.
% IQ: The image quality parameter that characterizes the contrast of the EBSP associated with each measurement point.
% CI: The confidence index that describes how confident the software is that it has correctly indexed the EBSP, i.e., confidence that the angles are correct.
% Phase ID: The material phase identifier. This field is 0 for single phase OIM scans or 1,2,3... for multi-phase scans.
% Detector Intensity: An integer describing the intensity from whichever detector was hooked up to the OIM system at the time of data collection, typically a forward scatter detector.
% Fit: The fit metric that describes how the indexing solution matches the bands detected by the Hough transform or manually by the user.
% Footers:
% In addition there also may be extra sections - such as EDS counts data.

% author: d.mercier@mpie.de

fpath_flag = 1;
if nargin == 0
    fdata = random_TSL_data(20, 100);
    fdata.eul_ang = randBunges((100*100))*pi/(180);  %in radians !!!
    [fname, fpath] = uiputfile('*.txt', 'Save OIM .Ang file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 1
    [fname, fpath] = uiputfile('*.txt', 'Save OIM .Ang file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 2
    [fname] = uiputfile('*.txt', 'Save OIM .Ang file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if fpath_flag
    if ~isempty(fpath)
        cd(fpath);
    end
    
    %% Check fields of fdata
    if ~isfield(fdata, 'title')
        fdata.title = 'No_title_given_by_user';
        warning('No title given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'user')
        fdata.user = 'No_username_given_by_user';
        warning('No username given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'eul_ang')
        fdata.eul_ang = randBunges((100*100))*pi/(180); %in radians !!!
        warning('No Euler angles given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'x_pixel_pos')
        fdata.x_pixel_pos =  1:(100*100);
        warning('No x positions of pixels given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'y_pixel_pos')
        fdata.y_pixel_pos = 1:(100*100);
        warning('No y positions of pixels given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'image_quality')
        fdata.image_quality = ones(length(fdata.x_pixel_pos), 1);
        warning('No image quality given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'confidence_index')
        fdata.confidence_index = ones(length(fdata.x_pixel_pos), 1);
        warning('No confidence index given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'phase')
        fdata.phase_ang = zeros(length(fdata.x_pixel_pos), 1);
        warning('No phase given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'detector_intensity')
        fdata.detector_intensity = ones(length(fdata.x_pixel_pos), 1);
        warning('No detector intensity given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'fit')
        fdata.fit = ones(length(fdata.x_pixel_pos), 1);
        warning('No fit values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'x_step')
        fdata.x_step = length(fdata.x_pixel_pos);
        warning('No x step values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'y_step')
        fdata.y_step = length(fdata.y_pixel_pos);
        warning('No y step values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'n_col_odd')
        fdata.n_col_odd = length(fdata.x_pixel_pos);
        warning('No n_col_odd values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'n_col_even')
        fdata.n_col_even = length(fdata.y_pixel_pos);
        warning('No n_col_even values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'n_rows')
        fdata.n_rows = length(fdata.x_pixel_pos);
        warning('No n_rows values given by user for the .Ang file');
    end
    
    %% Creation of the ang. file
    fid = fopen(fname,'w+');
    fprintf(fid, '# TEM_PIXperUM          1.000000\n');
    fprintf(fid, '# x-star                0.507048\n');
    fprintf(fid, '# y-star                0.818235\n');
    fprintf(fid, '# z-star                0.663141\n');
    fprintf(fid, '# WorkingDistance       22.000000\n');
    fprintf(fid, '#\n');
    fprintf(fid, '# Phase 1\n');
    fprintf(fid, '# MaterialName  	Titanium (Alpha)\n');
    fprintf(fid, '# Formula     	Ti\n');
    fprintf(fid, '# Info\n');
    fprintf(fid, '# Symmetry              62\n');
    fprintf(fid, '# LatticeConstants      2.950 2.950 4.680  90.000  90.000 120.000\n');
    fprintf(fid, '# NumberFamilies        8\n');
    fprintf(fid, '# hklFamilies   	 1  0  0 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 0  0  2 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 1  0  1 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 1  0  2 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 1  1  0 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 1  0  3 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 1  1  2 1 0.000000 1\n');
    fprintf(fid, '# hklFamilies   	 2  0  1 1 0.000000 1\n');
    fprintf(fid, '# ElasticConstants 	0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');
    fprintf(fid, '# ElasticConstants 	0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');
    fprintf(fid, '# ElasticConstants 	0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');
    fprintf(fid, '# ElasticConstants 	0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');
    fprintf(fid, '# ElasticConstants 	0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');
    fprintf(fid, '# ElasticConstants 	0.000000 0.000000 0.000000 0.000000 0.000000 0.000000\n');
    fprintf(fid, '# Categories0 0 0 0 0\n');
    fprintf(fid, '#\n');
    fprintf(fid, '# GRID: SqrGrid\n');
    fprintf(fid, '# XSTEP: %6.2f\n', fdata.x_step);
    fprintf(fid, '# YSTEP: %6.2f\n', fdata.y_step);
    fprintf(fid, '# NCOLS_ODD: %i\n', fdata.n_col_odd);
    fprintf(fid, '# NCOLS_EVEN: %i\n', fdata.n_col_even);
    fprintf(fid, '# NROWS: %i\n', fdata.n_rows);
    fprintf(fid, '#\n');
    fprintf(fid, '# OPERATOR: 	%s\n', fdata.user);
    fprintf(fid, '#\n');
    fprintf(fid, '# SAMPLEID:\n');
    fprintf(fid, '#\n');
    fprintf(fid, '# SCANID:\n');
    fprintf(fid, '#\n');
    for ii = 1:length(fdata.x_pixel_pos)
        fprintf(fid, '%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f \n\l',...
            fdata.eul_ang(ii,1), fdata.eul_ang(ii,2), fdata.eul_ang(ii,3),...
            fdata.x_pixel_pos(ii), fdata.y_pixel_pos(ii),...
            fdata.image_quality(ii),...
            fdata.confidence_index(ii),...
            fdata.phase_ang(ii),...
            fdata.detector_intensity(ii),...
            fdata.fit(ii));
    end
    fclose(fid);
    
end

return