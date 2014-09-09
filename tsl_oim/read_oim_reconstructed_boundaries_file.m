% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function RB = read_oim_reconstructed_boundaries_file(fname, fpath, varargin)
%% Function to read TSL-OIM reconstructed boundaries file
% fname : Name of the reconstructed boundaries file
% fpath : Path to the reconstructed boundaries file

% Example of headerlines of a Reconstructed Boundaries file (TSL-OIM v6.2.0)
%                                                                                    x axis or TD Direction (Transverse)
% # Column 1-3:    right hand average orientation (phi1, PHI, phi2 in radians)       ---->
% # Column 4-6:    left hand average orientation (phi1, PHI, phi2 in radians)      y |
% # Column 7:      length (in microns)                                         or RD |
% # Column 8:      trace angle (in degrees)                                Reference v
% Column 8 = angle alpha from [RANDLE 2006] --> 90° if vertical (// to y-axis) and 0° if horizontal (// to x-axis)
% # Column 9-12:   x,y coordinates of endpoints (in microns)
% # Column 13-14:  IDs of right hand and left hand grains
% In column 8, put the angle from the horizontal of the GB, e.g. 90deg if you want a vertical boundary.
% [RANDLE 2006] : DOI ==> 10.1111/j.1365-2818.2006.01575.x

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0
    [fname, fpath, FilterIndex] = uigetfile('*.txt');
    if isequal(fname,0)
        RB = -1;
        return;
    end
end

if nargin == 1
    fpath = '';
end

RB = struct();

RIGHT_ORI_OK = false;
LEFT_ORI_OK = false;
GB_LENGTH_OK = false;
GB_TRACE_ANGLE_OK = false;
GB_ENDPOINTS_COORD_OK = false;
ID_GRAINS_OK = false;

%disp([mfilename,' file:', fname]);
RB.file = fullfile(fpath, fname);
fid = fopen(RB.file,'r');
ii = 0;
header = {};
while feof(fid) ~= 1
    ln = fgetl(fid);
    if ln(1) == '#';
        header{end+1} = ln;
        if strfind(ln, 'right hand average orientation (phi1, PHI, phi2 in radians)')
            RIGHT_ORI_OK = true;
        end
        if strfind(ln, 'left hand average orientation (phi1, PHI, phi2 in radians)')
            LEFT_ORI_OK = true;
        end
        if strfind(ln, 'length (in microns)')
            GB_LENGTH_OK = true;
        end
        if strfind(ln, 'trace angle (in degrees)')
            GB_TRACE_ANGLE_OK = true;
        end
        if strfind(ln, 'x,y coordinates of endpoints (in microns)')
            GB_ENDPOINTS_COORD_OK = true;
        end
        if strfind(ln, 'IDs of right hand and left hand grains')
            ID_GRAINS_OK = true;
        end
    else
        if ~(RIGHT_ORI_OK && LEFT_ORI_OK && GB_LENGTH_OK&& GB_TRACE_ANGLE_OK&& GB_ENDPOINTS_COORD_OK && ID_GRAINS_OK)
           fclose(fid);
           error('Reconstructed Boundaries File columns are wrong !')
        end
        ii = ii + 1;
        data(ii,:) = sscanf(ln,'%f');
    end
end
fclose(fid);
RB.data = data;
RB.header = header;
RB.col_idx = header2struct(header);
% Split relevant data into separate fields to be more flexible against changes in RB
% file format and contents.
if isfield(RB.col_idx,'GRAIN_IDs')
    RB.GRAIN_ID = data(:,RB.col_idx.GRAIN_ID);
end
if isfield(RB.col_idx,'GB_ENDPOINT_XY')
    RB.GB_XY = data(:,RB.col_idx.GB_XY);
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
        if strfind(desc, 'right hand average orientation')
            col_idx.AVG_ORI_RIGHT = idx;
        elseif strfind(desc, 'left hand average orientation')
            col_idx.AVG_ORI_LEFT = idx;
        elseif strfind(desc, 'length (in microns)')
            col_idx.LENGTH = idx;
        elseif strfind(desc, 'trace angle (in degrees)')
            col_idx.TRACE_ANGLE = idx;
        elseif strfind(desc, 'x,y coordinates of endpoints (in microns)')
            col_idx.GB_XY = idx;
            assert(length(idx) == 4);
        elseif strfind(desc, 'IDs of right hand and left hand grains')
            col_idx.GRAIN_ID = idx;
        end
    end
end

