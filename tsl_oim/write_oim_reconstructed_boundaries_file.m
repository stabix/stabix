% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function fdata = ...
    write_oim_reconstructed_boundaries_file(fdata, fpath, fname, varargin)
%% Function used to write TSL-OIM reconstructed boundaries file
% fname : Name of the reconstructed boundaries file to create
% fpath : Path where to store the reconstructed boundaries file
% fdata : Data to store in the reconstructed boundaries file
% fdata.title : For the 1st line of the headerlines of the reconstructed boundaries file
% fdata.number_of_grain_boundaries
% fdata.eul_ang
% fdata.gb_length
% fdata.gb_trace_angle
% fdata.GBvx : X Coordinates of GB endpoints
% fdata.GBvy : Y Coordinates of GB endpoints
% fdata.GB2cells : Id. of left and right grains

% author: d.mercier@mpie.de

flag_missing_field = 0;
fpath_flag = 1;

if nargin == 0
    fdata = random_TSL_data (200);
    [fname, fpath] = ...
        uiputfile('*.txt', 'Save OIM reconstructed boundaries file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
    if isfield(fdata, 'rdm_TSL_data_flag')
        while fdata.rdm_TSL_data_flag == 0
            fdata = random_TSL_data (20);
        end
    end
end

if nargin == 1
    [fname, fpath] = ...
        uiputfile('*.txt', 'Save OIM reconstructed boundaries file as');
    if isequal(fpath,0)
        fpath_flag = 0;
    end
end

if nargin == 2
    [fname] = ...
        uiputfile('*.txt', 'Save OIM reconstructed boundaries file as');
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
        commandwindow;
        warning(['No title given by user for the ' ...
            'Reconstructed Boundaries File']);
    end
    
    if ~isfield(fdata, 'number_of_grain_boundaries')
        if isfield(fdata, 'GBvx')
            fdata.number_of_grain_boundaries = length(fdata.x_positions);
        else
            commandwindow;
            warning(['No X positions of grain boundaries found ' ...
                'in the data to store in Reconstructed Boundaries File']);
            flag_missing_field = 1;
        end
        
        if isfield(fdata, 'GBvy')
            fdata.number_of_grain_boundaries = length(fdata.y_positions);
        else
            commandwindow;
            warning(['No Y positions of grain boundaries found ' ...
                'in the data to store in Reconstructed Boundaries File']);
            flag_missing_field = 1;
        end
    end
    
    if ~isfield(fdata, 'eul_ang')
        commandwindow;
        warning(['No Euler angles found in the data to store ' ...
            'in Reconstructed Boundaries File']);
        flag_missing_field = 1;
    end
    
    if ~isfield(fdata, 'GBvx')
        commandwindow;
        warning(['No X positions of grain boundaries found ' ...
            'in the data to store in Reconstructed Boundaries File']);
        flag_missing_field = 1;
    end
    
    if ~isfield(fdata, 'GBvy')
        commandwindow;
        warning(['No Y positions of grain boundaries found ' ...
            'in the data to store in Reconstructed Boundaries File']);
        flag_missing_field = 1;
    end
    
    if ~isfield(fdata, 'GB2cells')
        commandwindow;
        warning(['No grains identification found ' ...
            'in the data to store in Reconstructed Boundaries File']);
        flag_missing_field = 1;
    end
    
    if ~isfield(fdata, 'gb_length')
        commandwindow;
        warning(['No grains boundaries length found ' ...
            'in the data to store in Reconstructed Boundaries File']);
        for ii = 1:fdata(1).number_of_grain_boundaries
            fdata.gb_length(ii) = 1;
        end
    end
    
    if ~isfield(fdata, 'gb_trace_angle')
        commandwindow;
        warning(['No grains boundaries trace angle found ' ...
            'in the data to store in Reconstructed Boundaries File']);
        for ii = 1:fdata(1).number_of_grain_boundaries
            fdata.gb_trace_angle(ii) = 1;
        end
    end
    
    if ~flag_missing_field
        %% Creation of the reconstructed boundaries file
        fid = fopen(fname, 'w+');
        fprintf(fid, '# Header: Project1::%s:All data::Grain Size\r\n', ...
            char(fdata(:,1).title));
        fprintf(fid, '#\r\n');
        fprintf(fid, ['# Column 1-3:    right hand average orientation ' ...
            '(phi1, PHI, phi2 in radians)\r\n']);
        fprintf(fid, ['# Column 4-6:    left hand average orientation '...
            '(phi1, PHI, phi2 in radians)\r\n']);
        fprintf(fid, '# Column 7:      length (in microns)\r\n');
        fprintf(fid, '# Column 8:      trace angle (in degrees)\r\n');
        fprintf(fid, ['# Column 9-12:   x,y coordinates of endpoints '...
            '(in microns)\r\n']);
        fprintf(fid, ['# Column 13-14:  IDs of right hand and '...
            'left hand grains\r\n']);
        for ii = 1:fdata(1).number_of_grain_boundaries
            id_grA = fdata.GB2cells(ii,1);
            id_grB = fdata.GB2cells(ii,2);
            fprintf(fid, ['%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f ' ...
                '%6.2f %6.2f %6.2f %6.2f %6.2f %i %i\r\n'], ...
                fdata.eul_ang(id_grA ,1), ...
                fdata.eul_ang(id_grA ,2), ...
                fdata.eul_ang(id_grA ,3),...
                fdata.eul_ang(id_grB,1), ...
                fdata.eul_ang(id_grB,2), ...
                fdata.eul_ang(id_grB,3),...
                fdata.gb_length(ii),...
                fdata.gb_trace_angle(ii),...
                fdata.GBvx(ii,1), ...
                fdata.GBvy(ii,1), ...
                fdata.GBvx(ii,2), ...
                fdata.GBvy(ii,2),...
                id_grA, id_grB);
        end
        fclose(fid);
        
    end
end
end