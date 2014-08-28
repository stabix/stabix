% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_MTEX_plotIPF4BC
%% Plot IPDF of the bicrystal with MTEX
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

if gui.flag.installation_mtex == 1
    
    % Specify how to align the x-axis in plots
    plotx2east %set the default plot direction of the xaxis
    %plotx2north %set the default plot direction of the xaxis
    %plotx2south %set the default plot direction of the xaxis
    %plotx2west %set the default plot direction of the xaxis
    %plotzIntoPlane %set the default plot direction of the zaxis
    %plotzOutOfPlane %set the default plot direction of the zaxis
    
    %% Plot IPF for the bicrystal
    figure('Name', 'IPF');
    hold on;
    ori_bicrystal = [gui.GB.orientation_grA; gui.GB.orientation_grB];
    plotipdf(ori_bicrystal, zvector);
%     %% Plot PF for the bicrystal
%     figure('Name','IPF'); hold on;
%     ori_bicrystal = [gui_data.GB.orientation_grA;gui_data.GB.orientation_grB];
%     cs = symmetry('hexagonal');
%     m = Miller(0,0,0,1,cs);
%     plotpdf(ori_bicrystal,m);

end

guidata(gcf, gui);

end