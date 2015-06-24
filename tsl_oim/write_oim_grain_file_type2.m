% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function fdata = write_oim_grain_file_type2(fdata, fpath, fname, varargin)
%% Function used to write TSL-OIM grain file type 2
% See TSL-OIM documentation for grain file type 2 format

% fname : Name of the grain file type 2 to create
% fpath : Path where to store the grain file type 2
% fdata : Data to store in the grain file type 2
% fdata.title : For the 1st line of the headerlines of grain file type 2
% fdata.number_of_grains
% fdata.eul_ang
% fdata.x_positions
% fdata.y_positions
% fdata.image_quality
% fdata.confidence_index
% fdata.fit
% fdata.phase : Number of phase
% fdata.edge_grain
% fdata.grain_diameter

% author: d.mercier@mpie.de

flag_missing_field = 0;
fpath_flag = 1;

if nargin == 0
    fdata = random_2D_microstructure_data(20);
    [fname, fpath] = uiputfile('*.txt', 'Save OIM grain file type 2 as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 1
    [fname, fpath] = uiputfile('*.txt', 'Save OIM grain file type 2 as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 2
    [fname] = uiputfile('*.txt', 'Save OIM grain file type 2 as');
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
        warning_commwin(...
            'No title given by user for the Grain File Type 2');
    end
    
    if ~isfield(fdata, 'number_of_grains')
        if isfield(fdata, 'eul_ang')
            fdata.number_of_grains = length(fdata.eul_ang);
        else
            warning_commwin(['No Euler angles found in the data ' ...
                'to store in Grain File Type 2']);
            flag_missing_field = 1;
        end
        if isfield(fdata, 'x_positions')
            fdata.number_of_grains = length(fdata.x_positions);
        else
            warning_commwin(['No X positions of grains found in the data ' ...
                'to store in Grain File Type 2']);
            flag_missing_field = 1;
        end
        if isfield(fdata, 'y_positions')
            fdata.number_of_grains = length(fdata.y_positions);
        else
            warning_commwin(['No Y positions of grains found in the data ' ...
                'to store in Grain File Type 2']);
            flag_missing_field = 1;
        end
    end
    
    if ~isfield(fdata, 'eul_ang')
        warning_commwin(['No Euler angles found in the data ' ...
            'to store in Grain File Type 2']);
        flag_missing_field = 1;
    end
    
    if ~isfield(fdata, 'x_positions')
        warning_commwin(['No X positions of grains found in the data ' ...
            'to store in Grain File Type 2']);
        flag_missing_field = 1;
    end
    
    if ~isfield(fdata, 'y_positions')
        warning_commwin(['No Y positions of grains found in the data ' ...
            'to store in Grain File Type 2']);
        flag_missing_field = 1;
    end
    
    if ~flag_missing_field
        
        if ~isfield(fdata, 'image_quality')
            for ngb = 1:fdata(1).number_of_grains
                fdata.image_quality(ngb) = 1;
            end
        end
        
        if ~isfield(fdata, 'confidence_index')
            for ngb = 1:fdata(1).number_of_grains
                fdata.confidence_index(ngb) = 1;
            end
        end
        
        if ~isfield(fdata, 'fit')
            for ngb = 1:fdata(1).number_of_grains
                fdata.fit(ngb) = 1;
            end
        end
        
        if ~isfield(fdata, 'phase')
            for ngb = 1:fdata(1).number_of_grains
                fdata.phase(ngb) = 0;
            end
        end
        
        if ~isfield(fdata, 'edge_grain')
            for ngb = 1:fdata(1).number_of_grains
                fdata.edge_grain(ngb) = 1;
            end
        end
        
        if ~isfield(fdata, 'grain_diameter')
            for ngb = 1:fdata(1).number_of_grains
                fdata.grain_diameter(ngb) = 1;
            end
        end
        
        %% Creation of the grain file type 2
        fid = fopen(fname, 'w+');
        fprintf(fid, '# Header: Project1::%s::All data::Grain Size\r\n', ...
            char(fdata(:,1).title));
        fprintf(fid, '#\r\n');
        fprintf(fid, '# Column 1: Integer identifying grain\r\n');
        fprintf(fid, ['# Column 2-4: Average orientation ' ...
            '(phi1, PHI, phi2) in degrees\r\n']);
        fprintf(fid, ['# Column 5-6: Average Position ' ...
            '(x, y) in microns\r\n']);
        fprintf(fid, '# Column 7: Average Image Quality (IQ)\r\n');
        fprintf(fid, '# Column 8: Average Confidence Index (CI)\r\n');
        fprintf(fid, '# Column 9: Average Fit (degrees)\r\n');
        fprintf(fid, '# Column 10: An integer identifying the phase\r\n');
        fprintf(fid, '#           0 -  Titanium (Alpha)\r\n');
        fprintf(fid, ['# Column 11: Edge grain (1) ' ...
            'or interior grain (0)\r\n']);
        fprintf(fid, '# Column 12: Diameter of grain in microns\r\n');
        for ii = 1:fdata(1).number_of_grains
            fprintf(fid, ['%i %6.2f %6.2f %6.2f %6.2f %6.2f ' ...
                '%i %i %i %i %i %6.2f\r\n'],...
                ii, ...
                fdata.eul_ang(ii,1), ...
                fdata.eul_ang(ii,2), ...
                fdata.eul_ang(ii,3),...
                fdata.x_positions(ii), ...
                fdata.y_positions(ii),...
                fdata.image_quality(ii),...
                fdata.confidence_index(ii),...
                fdata.fit(ii),...
                fdata.phase(ii),...
                fdata.edge_grain(ii),...
                fdata.grain_diameter(ii));
        end
        fclose(fid);
        
    end
end
return