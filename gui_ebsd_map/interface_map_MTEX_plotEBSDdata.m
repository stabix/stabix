% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: interface_map_MTEX_plotEBSDdata.m 1233 2014-08-14 12:28:10Z d.mercier $
function interface_map_MTEX_plotEBSDdata(ebsd)
%% Visualization of EBSD data (phase, EBSD map, IPF) with MTEX Toolbox
% ebsd : Name of the structure variable created after importing EBSD data
% .ang file ('ebsd' is default name use by MTEX...)
% See in http://code.google.com/p/mtex/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Visualization of EBSD data
figure('Name', 'EBSDmap');
hold on;
plot(ebsd);

%% Calculation of an ODF
%odf = calcODF(ebsd);

%% Detection of grains
%segmentation angle
segAngle = 10*degree;
grains = calcGrains(ebsd, 'threshold', segAngle);

%% Orientation of Grains
%figure('Name','EBSDmap'); hold on;
%plot(grains)
figure('Name', 'Phase');
hold on;
plot(grains, 'property', 'phase');

%% Plot Inverse Pole Figure
v = vector3d(0, 0, 1);
figure('Name', 'IPF');
hold on;
plotipdf(ebsd, v);

end