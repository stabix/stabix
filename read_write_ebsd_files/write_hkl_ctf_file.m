% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function fdata = write_hkl_ctf_file(fdata, fpath, fname, varargin)
%% Function used to write HKL .ctf file for OIM Analysis 7
% See HKL documentation for .ctf file format

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
% fdata.phase_ang : Number of phase
% fdata.detector_intensity
% fdata.fit

% The fields of each line in the body of the .ctf file are as follows:
% Phase	X Y	Bands Error Euler1 Euler2 Euler3 MAD BC BS

% author: d.mercier@mpie.de

fpath_flag = 1;
if nargin == 0
    fdata = random_2D_microstructure_data(20, 100);
    fdata.eul_ang = randBunges((100*100))*pi/(180);  %in radians !!!
    [fname, fpath] = uiputfile('*.ctf', 'Save HKL .ctf file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 1
    [fname, fpath] = uiputfile('*.ctf', 'Save HKL .ctf file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 2
    [fname, fpath] = uiputfile('*.ctf', 'Save HKL .ctf file as');
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
        warning_commwin('No title given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'user')
        fdata.user = 'No_username_given_by_user';
        warning_commwin('No username given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'eul_ang')
        fdata.eul_ang = randBunges((100*100))*pi/(180); %in radians !!!
        warning_commwin('No Euler angles given by user for the .Ang file');
    end
    
    % Check of Euler angles values
    for ii = 1:3
        for jj = 1:size(fdata.eul_ang,1)
            if fdata.eul_ang(jj,ii) > 2*pi
                fdata.eul_ang(jj,ii) = mod(fdata.eul_ang(jj,ii),2*pi);
                warning_commwin('Recalculated Euler angles modulo 2 pi');
            end
        end
    end
    
    if ~isfield(fdata, 'x_pixel_pos')
        fdata.x_pixel_pos =  1:(100*100);
        warning_commwin(['No x positions of pixels given ' ...
            'by user for the .Ang file']);
    end
    
    if ~isfield(fdata, 'y_pixel_pos')
        fdata.y_pixel_pos = 1:(100*100);
        
        warning_commwin(['No y positions of pixels given ' ...
            'by user for the .Ang file']);
    end
    
    if ~isfield(fdata, 'image_quality')
        fdata.image_quality = ones(length(fdata.x_pixel_pos), 1);
        warning_commwin('No image quality given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'confidence_index')
        fdata.confidence_index = ones(length(fdata.x_pixel_pos), 1);
        warning_commwin(...
            'No confidence index given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'phase_ang')
        fdata.phase_ang = zeros(length(fdata.x_pixel_pos), 1);
        warning_commwin('No phase given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'detector_intensity')
        fdata.detector_intensity = ones(length(fdata.x_pixel_pos), 1);
        warning_commwin(...
            'No detector intensity given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'fit')
        fdata.fit = ones(length(fdata.x_pixel_pos), 1);
        warning_commwin('No fit values given by user for the .Ang file');
    end
    
    % Check of Euler angles values
    for jj = 1:size(fdata.confidence_index,1)
        if fdata.confidence_index < 1
            fdata.fit(jj) = 0;
            warning_commwin('Reset value of the fit');
        end
    end
    
    if ~isfield(fdata, 'x_step')
        fdata.x_step = fdata.x_pixel_pos(2) - fdata.x_pixel_pos(1);
        warning_commwin(...
            'No x step values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'y_step')
        fdata.y_step = fdata.x_step;
        warning_commwin(...
            'No y step values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'n_col_odd')
        fdata.n_col_odd = single(max(fdata.x_pixel_pos)/fdata.x_step);
        warning_commwin(...
            'No n_col_odd values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'n_col_even')
        fdata.n_col_even = fdata.n_col_odd;
        warning_commwin(...
            'No n_col_even values given by user for the .Ang file');
    end
    
    if ~isfield(fdata, 'n_rows')
        fdata.n_rows = single(max(fdata.y_pixel_pos)/fdata.x_step);
        warning_commwin(...
            'No n_rows values given by user for the .Ang file');
    end
    
    %% Creation of the .ctf file
    fid = fopen(fname,'w+');
    fprintf(fid, 'Channel Text File\r\n');
    fprintf(fid, 'Prj unnamed\r\n');
    fprintf(fid, 'Author [STABiX]\r\n');
    fprintf(fid, 'JobMode Grid\r\n');
    fprintf(fid, 'XCells 1000\r\n');
    fprintf(fid, 'YCells 750#\r\n');
    fprintf(fid, 'XStep	0,124997558665273\r\n');
    fprintf(fid, 'YStep	0,124997558665273\r\n');
    fprintf(fid, 'AcqE1	0\r\n');
    fprintf(fid, 'AcqE2	0\r\n');
    fprintf(fid, 'AcqE3	0\r\n');
    fprintf(fid, 'Euler angles refer to Sample Coordinate system (CS0)!	Mag	1000	Coverage	100	Device	0	KV	20,008695602417	TiltAngle	70	TiltAxis	0\r\n');
    fprintf(fid, 'Phases %i\r\n', fdata.phase_ang);
    for ii = 1:max(fdata.phase_ang)
        fprintf(fid, '2,866;2,866;2,866	90;90;90	Ferrite	11	229 \r\n');
    end
    fprintf(fid, 'Phase	X	Y	Bands	Error	Euler1	Euler2	Euler3	MAD	BC	BS\r\n');
    for ii = 1:length(fdata.x_pixel_pos)
        fprintf(fid, ['%i	%6.3f	%6.3f	%i	%i	%6.4f %6.4f %6.4f %6.4f	%i %i'], ...
            fdata.phase_ang(ii),...
            fdata.x_pixel_pos(ii), fdata.y_pixel_pos(ii),...
            10, 0, ...
            fdata.eul_ang(ii,1), fdata.eul_ang(ii,2), fdata.eul_ang(ii,3),...
            1.0003, 237, 255);
    end
    fclose(fid);
    
end

return