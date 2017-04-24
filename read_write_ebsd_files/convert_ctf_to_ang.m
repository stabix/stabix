% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function fdata = convert_ctf_to_ang(angVers, varargin)
%% Function to convert .ctf file into .ang file

% author: d.mercier@mpie.de

if nargin == 0
    angVers = 7;
end

% Import hkl file (.ctf)
dataHKL = read_hkl_ctf_file;

% Attribution of fields for data variable
fname = strcat(char(dataHKL.header(2)), '.ang');
fpath = dataHKL.path;
fdata.user = char(dataHKL.header(3));
fdata.eul_ang = dataHKL.data(:,6:8)/180*pi;
fdata.x_pixel_pos = dataHKL.data(:,2);
fdata.y_pixel_pos = dataHKL.data(:,3);
fdata.image_quality = ones(length(dataHKL.data), 1);
fdata.confidence_index = ones(length(dataHKL.data), 1);
fdata.phase = max(dataHKL.data(:,1));
fdata.detector_intensity = ones(length(dataHKL.data), 1);
fdata.fit = ones(length(dataHKL.data), 1);

% Creation of .ang file
if angVers == 6
    write_oim_ang_file_v6(fdata, fpath, fname);
elseif angVers == 7
    write_oim_ang_file_v7(fdata, fpath, fname);
end

end