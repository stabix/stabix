% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [X, Y, data, fvc] = preCPFE_correct_indenter_topo_AFM(topo, h_indent, smooth_factor, rotation_angle, z_factor, varargin)
%% Function to correct topography from Gwyddion file
% topo: Struct. variable imported from Gwyddion file (see
% read_gwyddion_ascii function)
% h_indent: Depth indentation to shift indenter vertically (in um)
% smooth_factor: Factor used to reduce number of points for the plot of the
% indenter ==> 2^n with n = 1,2,3,...10 (2^3 = 8 and 512 pixels become 64 pixels)
% rotation_angle: Angle to rotate indenter (from 0 to 360°)
% z_factor: Unit conversion (e.g.: 1e6 for [m] to micrometer)

% Data format from Gwyddion
% - channel: 'Height'
% - width: 5
% - height: 5
% - FEM_mode: 0
% - data: [512x512 double]
% - nX: 512
% - nY: 512
% - resX: 0.0098
% - resY: 0.0098
% - linX: [1x512 double]
% - linY: [1x512 double]
% - max: 1.9029e-06
% - min: -7.2871e-07
% - data_range: 2.6316e-06
% - X: [512x512 double]
% - Y: [512x512 double]

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 5
    % Unit conversion from [m] to micrometer
    z_factor = 1e6;
end

if nargin < 4
    rotation_angle = 0;
end

if nargin < 3
    % Factor used to reduce number of points for the plot...
    smooth_factor = 16; % 2^n with n = 1,2,3,...10 (2^3 = 8 and 512 pixels become 64 pixels)
end

if nargin < 2
    % Indentation depth in um
    h_indent = 0;
end

if nargin <1
    [file_AFM, dir_AFM, filterindex] = uigetfile('*.txt', 'Select a Gwyddion file');
    topo = read_gwyddion_ascii(fullfile(dir_AFM,file_AFM));
end

%% Rotate data
distance = zeros(size(topo.X, 1), size(topo.X, 2));
gamma_angle = zeros(size(topo.X, 1), size(topo.X, 2));
for ii = 1:size(topo.X, 1)
    for jj = 1:size(topo.X, 2)
        distance(ii, jj) = (topo.X_ori(ii,jj)^2 + topo.Y_ori(ii,jj)^2)^0.5;
        if topo.X_ori(ii,jj) > 0 && topo.Y_ori(ii,jj) > 0
            gamma_angle(ii, jj) = acosd(topo.X_ori(ii,jj)/distance(ii, jj));
        elseif topo.X_ori(ii,jj) < 0 && topo.Y_ori(ii,jj) > 0
            gamma_angle(ii, jj) = acosd(topo.Y_ori(ii,jj)/distance(ii, jj)) + 90;
        elseif topo.X_ori(ii,jj) < 0 && topo.Y_ori(ii,jj) < 0
            gamma_angle(ii, jj) = acosd(abs(topo.X_ori(ii,jj))/distance(ii, jj)) + 180;
        elseif topo.X_ori(ii,jj) > 0 && topo.Y_ori(ii,jj) < 0
            gamma_angle(ii, jj) = acosd(abs(topo.Y_ori(ii,jj))/distance(ii, jj)) + 270;
        end
        topo.X(ii, jj) = distance(ii, jj) * cosd(rotation_angle + gamma_angle(ii, jj));
        topo.Y(ii, jj) = distance(ii, jj) * sind(rotation_angle + gamma_angle(ii, jj));
    end
end

%% Rescale data
topo.data = topo.data * z_factor;
topo.max = topo.max * z_factor;
topo.min = topo.min * z_factor;

%% Center data
[mm, nm] = find(topo.data==topo.max);
xShift = topo.X(mm(1),nm(1));
yShift = topo.Y(mm(1),nm(1));
topo.X = topo.X - xShift;
topo.Y = topo.Y - yShift;

%% Smooth data
for ii = 1:1:topo.nX/smooth_factor
    for jj = 1:1:topo.nY/smooth_factor
        topo.X_smoothed(ii,jj) = mean([topo.X(smooth_factor*ii-1,2*jj-1),...
            topo.X(smooth_factor*ii-1,smooth_factor*jj),...
            topo.X(smooth_factor*ii,smooth_factor*jj-1),...
            topo.X(smooth_factor*ii,smooth_factor*jj)]);
        topo.Y_smoothed(ii,jj) = mean([topo.Y(smooth_factor*ii-1,2*jj-1),...
            topo.Y(smooth_factor*ii-1,smooth_factor*jj),...
            topo.Y(smooth_factor*ii,smooth_factor*jj-1),...
            topo.Y(smooth_factor*ii,smooth_factor*jj)]);
        topo.data_smoothed(ii,jj) = mean([topo.data(smooth_factor*ii-1,2*jj-1),...
            topo.data(smooth_factor*ii-1,smooth_factor*jj),...
            topo.data(smooth_factor*ii,smooth_factor*jj-1),...
            topo.data(smooth_factor*ii,smooth_factor*jj)]);
    end
end

%% Inverse and Z-shift data (because of AFM measurement)
topo.data_smoothed = (-(topo.data_smoothed - max(max(topo.data_smoothed)))) - h_indent;

%% Save data
X = topo.X_smoothed;
Y = topo.Y_smoothed;
data = topo.data_smoothed;

%% 3D Plot
surf(X, Y, data);
fvc = surf2patch(X, Y, data); % for generation of Abaqus .inp file
colormap gray;

end