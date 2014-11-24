% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function MTEX_plotGrainsStat(ebsdData, segAngle, varargin)
%% Visualization of grains statistics (grain size, distribution...) with MTEX Toolbox
% ebsdData : Name of the structure variable created after importing EBSD data
% .ang file ('ebsd' is default name use by MTEX...)

% See in http://code.google.com/p/mtex/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

flagEBSDdata = 1;

if nargin < 2
    segAngle = 10;
end

if nargin < 1
    warning_commwin('No EBSD data to load !');
    flagEBSDdata = 0;
end

if flagEBSDdata
    %% Detection of grains
    grains = MTEX_calcGrains(ebsdData, segAngle);
    
    %% Plot Grain Diameter distribution
    diamgr = diameter(grains);
    binsdiam = 0:(max(diamgr)/10):max(diamgr);
    figure('Name', 'Statistical datas');
    hold on;
    subplot(4,1,1);
    hist(diamgr, binsdiam);
    %title ('Grain Diameter distribution');
    xlabel('Grain diameter - µm');
    ylabel('Number of grains');
    
    %% Plot Grain Area distribution
    ar = area(grains);
    binsar = exp(-1:0.5:log(max(ar)));
    subplot(4,1,2);
    bar(hist(ar,binsar));
    xlabel('Grain Area distribution');
    %xlabel('Grain Area - µm2');
    ylabel('Number of grains');
    
    %% Plot Grain Shape distribution
    sf = shapefactor(grains);
    as = aspectratio(grains);
    subplot(4, 1, [3 4]);
    scatter(sf, as, ar/20);
    xlabel('Grain Shape Factor');
    ylabel('Grain Aspect Ratio');
    
end

end