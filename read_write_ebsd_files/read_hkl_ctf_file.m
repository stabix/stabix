% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function fdata = read_hkl_ctf_file(fname, fpath, varargin)
%% Function to read .ctf file
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
% Phase	X Y	Bands Error Euler1 Euler2 Euler3 MAD BC BS

% author: d.mercier@mpie.de

if nargin == 0
    [fname, fpath, FilterIndex] = uigetfile('*.ctf');
    if isequal(fname,0)
        fdata = -1;
        return;
    end
end

if nargin == 1
    fpath = '';
end

fdata = struct();

%disp([mfilename,' file:', fname]);
fdata.file = fullfile(fpath, fname);

% Replace comma by dot
[pathstr, name, ext] = fileparts(fname);
NewFileName = strcat(name, 'mod', ext);
Data = fileread(fdata.file);
Data = strrep(Data, ',', '.');
fid = fopen(fullfile(fpath,NewFileName), 'w');
fwrite(fid, Data, 'char');
fclose(fid);

fdata.file = fullfile(fpath, NewFileName);

fid = fopen(fdata.file,'r');
header = {};
ii = 0;
while ii < 17
    ii = ii + 1;
    ln = fgetl(fid);
    header{ii} = ln;
end
ii = 0;
while feof(fid) ~= 1
    ln = fgetl(fid);
    ii = ii + 1;
    try
        data(ii,:) = sscanf(ln, '%f');
    catch  % handle empty lines or other problems in data
        if ~isempty(strtrim(ln))
            warning('Could not make sense of this line:');
            disp(ln);
        end
    end
end
fclose(fid);
fdata.path = fpath;
fdata.data = data;
fdata.header = header;
end