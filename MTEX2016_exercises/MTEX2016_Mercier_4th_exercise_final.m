%% 4th Exercise - Grain boundaries and plasticity
% From Mercier D. - MTEX 2016 Workshop - TU Chemnitz (Germany)

% Calculation and plot on GBs of m' parameter
% Dataset from Mercier D. - cp-Ti (alpha phase - hcp)

clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load sample
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load 'cpTi.mat';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Grains and GBs calculations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Grains
[grains, ebsd.grainId] = calcGrains(ebsd('indexed'));

% GBs
gB = grains.boundary('indexed','indexed');
ids = gB.ebsdId;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Slip systems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hkil_1 = [0,1,-1,0];
uvtw_1 = [2,-1,-1,0];
hkil_2 = [0,1,-1,0];
uvtw_2 = [2,-1,-1,0];

nA = Miller(hkil_1(1),hkil_1(2),hkil_1(3),hkil_1(4),ebsd.CS,'hkil');
dA = Miller(uvtw_1(1),uvtw_1(2),uvtw_1(3),uvtw_1(4),ebsd.CS,'UVTW');
nB = Miller(hkil_2(1),hkil_2(2),hkil_2(3),hkil_2(4),ebsd.CS,'hkil');
dB = Miller(uvtw_2(1),uvtw_2(2),uvtw_2(3),uvtw_2(4),ebsd.CS,'UVTW');

nA = nA./norm(nA);
dA = dA./norm(dA);
nB = nB./norm(nB);
dB = dB./norm(dB);

nA_rot = rotate(nA, ebsd.orientations);
dA_rot = rotate(dA, ebsd.orientations);
nB_rot = rotate(nB, ebsd.orientations);
dB_rot = rotate(dB, ebsd.orientations);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% m' calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wrong way
tic
mp = zeros(size(gB,1),1); % Preallocation
for ii = 1:size(gB,1)
    mpLoop(ii) = abs(dot(nA_rot(ids(ii,1)), nB_rot(ids(ii,2))) .* ...
        dot(dA_rot(ids(ii,1)), dB_rot(ids(ii,2))));
end
toc

% Good way
tic
mpVect = abs(dot(nA_rot(ids(:,1)), nB_rot(ids(:,2))) .* ...
         dot(dA_rot(ids(:,1)), dB_rot(ids(:,2))));
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(grains,'translucent',.3);
hold on;
plot(gB,gB.misorientation.angle./degree,'linewidth',1.5);
mtexColorbar
hold off;

plot(grains,'translucent',.3);
hold on;
plot(gB,mpVect,'linewidth',1.5);
mtexColorbar;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot only GBs with m' > 0.7
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind = mpVect>0.7;

plot(grains,'translucent',.3);
hold on;
plot(gB(ind),mpVect(ind),'linewidth',1.5);
mtexColorbar;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Schmid factor for prismatic slip system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M = zeros(3);M(1,1) = 1;
sigma001 = tensor(M,'name','stress');
sigmaCS = rotate(sigma001,inv(ebsd.orientations));

[tauMax,mActive,nActive,tau,ind] = calcShearStress(sigmaCS,nA,dA,'symmetrise');
plot(ebsd('indexed'),tauMax');
mtexColorbar
title('Schmidt factors for (0,1,-1,0)/[2,-1,-1,0]')