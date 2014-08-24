% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: read_oim_grain_file_type2.m 1228 2014-08-13 14:54:04Z d.mercier $
function GF2 = read_oim_grain_file_type2(fname, fpath, varargin)
%% Function to read TSL-OIM grain file type 2
% fname : Name of the grain file type 2 to read
% fpath : Path where is stored the grain file type 2 to read

% Grain File Type 2
% # Column 1: Integer identifying grain
% # Column 2-4: Average orientation (phi1, PHI, phi2) in degrees
% # Column 5-6: Average Position (x, y) in microns
% # Column 7: Average Image Quality (IQ)
% # Column 8: Average Confidence Index (CI)
% # Column 9: Average Fit (degrees)
% # Column 10: An integer identifying the phase ==> 0 -  Titanium (Alpha)
% # Column 11: Edge grain (1) or interior grain (0)
% # Column 12: Diameter of grain in microns

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0
    [fname, fpath, FilterIndex] = uigetfile('*.txt');
    if isequal(fname,0)
        GF2 = -1;
        return;
    end
end

if nargin == 1
    fpath = '';
end

GF2 = struct();

%disp([mfilename,' file:', fname]);
GF2.file = fullfile(fpath, fname);
fid = fopen(GF2.file,'r');
ii = 0;
header = {};
while feof(fid) ~= 1
    ln = fgetl(fid);
    if ln(1) == '#';
        %ln % plot headers
        header{end+1} = ln;
        if strcmp('# Column 1: Integer identifying grain',ln)
            GRAIN_NUMBERS_OK = true;
        end
        if strcmp('# Column 2-4: Average orientation (phi1, PHI, phi2) in degrees',ln)
            EULER_ANGLES_OK = true;
        end
    else
        if ~(GRAIN_NUMBERS_OK && EULER_ANGLES_OK)
            fclose(fid);
            error('Grain File Type 2 columns are wrong !')
        end
        ii = ii + 1;
        data(ii,:) = sscanf(ln,'%f'); %,N
    end
end
fclose(fid);
GF2.data = data;
GF2.header = header;
GF2.col_idx = header2struct(header);
% Split relevant data into separate fields to be more flexible against changes in GF2
% file format and contents.
if isfield(GF2.col_idx,'GRAIN_IDs')
    GF2.GRAIN_ID = data(:,GF2.col_idx.GRAIN_ID);
end
if isfield(GF2.col_idx,'GB_ENDPOINT_XY')
    GF2.GB_XY = data(:,GF2.col_idx.GB_XY);
end

function col_idx = header2struct(header)
% Seems that the format in which TSL-OIM exports reconstructed boundaries files
% has changed slightly for OIM 7. So we need to be more flexible in
% reading of the resulting RB and GF2 files.
col_idx = struct();  % column indices
for i_ln = 1:numel(header)
    ln = header{i_ln};
    if strfind(ln, '# Column')
        % Tells us which columns contain what data
        [cols, desc] = strtok(ln,':'); % split columns : description substrings
        cols = strrep(cols, '# Column', '');
        cols = strrep(cols, '-', ' ');
        cols = strtrim(cols);
        idx = sscanf(cols, '%i');
        if ~isempty(idx)
            if length(idx) == 2 % a range of columns
                idx = idx(1) : idx(2);
            end
        end
        desc = strtrim(desc);
        if strfind(desc, 'Integer identifying grain')
            col_idx.INT_ID_GRAIN = idx;
        elseif strfind(desc, 'Average orientation')
            col_idx.AVG_ORI = idx;
        elseif strfind(desc, 'Average Position (x, y) in microns')
            col_idx.AVG_POS_XY = idx;
        elseif strfind(desc, 'An integer identifying the phase')
            col_idx.PHASE = idx;
        end
    end
end