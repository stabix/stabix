% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [X, Y, data, fvc, handle_indax] = preCPFE_3d_indenter_topo_AFM(topo, h_indent, smooth_factor, z_factor, varargin)
%% Function to correct topography from Gwyddion file
% topo: Struct. variable imported from Gwyddion file (see
% read_gwyddion_ascii function)
% h_indent: Depth indentation to shift indenter vertically (in um)
% smooth_factor: Factor used to reduce number of points for the plot of the
% indenter ==> 2^n with n = 1,2,3,...10 (2^3 = 8 and 512 pixels become 64 pixels)
% z_factor: Unit conversion (e.g.: 1e6 for [m] to micrometer)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 4
    % Unit conversion from [m] to micrometer
    z_factor = 1e6;
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
handle_indax = surf(X, Y, data);

%% Get patch for generation of Abaqus .inp file
fvc = surf2patch(X, Y, data); 

end