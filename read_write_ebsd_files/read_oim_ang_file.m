% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function fdata = read_oim_ang_file(fname, fpath, varargin)
%% Function to read TSL-OIM .Ang file
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

if nargin == 0
    [fname, fpath, FilterIndex] = uigetfile('*.ang');
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
fid = fopen(fdata.file,'r');
ii = 0;
header = {};
while feof(fid) ~= 1
    ln = fgetl(fid);
    if ln(1) == '#';
        header{end+1} = ln;
    else
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
end
fclose(fid);
fdata.data = data;
fdata.header = header;
end