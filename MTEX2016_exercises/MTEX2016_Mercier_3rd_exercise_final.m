%% 3rd Exercise - Grain boundaries and plasticity
% From Mercier D. - MTEX 2016 Workshop - TU Chemnitz (Germany)

% Calculation of LRB factor
% Data from paper written by Guo Y. et al.
% "Slip band-grain boundary interactions in commercial-purity titanium",
% Acta Materialia 79 (2014), pp. 1-12.

% cp-Ti sample (alpha phase - hcp) deformed under tension to 1% plastic strain
% measured by in situ HR-EBSD.

clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load sample / Crystal Symmetry and Specimen Symmetry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = 1; b = 1; c = 1.5875;
cs = crystalSymmetry('hexagonal', [a b c] , 'X||a' , 'Y||b*');
ss = specimenSymmetry('622');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rotation matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EulA = [227, 4, 344];
EulB = [325, 177, 281];

o_grainA = rotation('Euler',EulA(1)*degree,EulA(2)*degree,EulA(3)*degree);
o_grainB = rotation('Euler',EulB(1)*degree,EulB(2)*degree,EulB(3)*degree);

ebsd.orientations(1) = orientation(o_grainA,cs,ss);
ebsd.orientations(2) = orientation(o_grainB,cs,ss);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Slip systems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prismatic <a> / Prismatic <a>
hkil_A = [0,1,-1,0];
uvtw_A = [2,-1,-1,0];
hkil_B = [0,1,-1,0];
uvtw_B = [2,-1,-1,0];

% % % Prismatic <a> / Basal <a>
% hkil_A = [1,-1,0,0];
% uvtw_A = [-1,-1,2,0];
% hkil_B = [0,0,0,1];
% uvtw_B = [-1,2,-1,0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conversion of slip vectors from Bravais-Miller to cartesian coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nA = Miller(hkil_A(1),hkil_A(2),hkil_A(3),hkil_A(4),cs,'hkil');
dA = Miller(uvtw_A(1),uvtw_A(2),uvtw_A(3),uvtw_A(4),cs,'UVTW');
nB = Miller(hkil_B(1),hkil_B(2),hkil_B(3),hkil_B(4),cs,'hkil');
dB = Miller(uvtw_B(1),uvtw_B(2),uvtw_B(3),uvtw_B(4),cs,'UVTW');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of GB plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GB_trace_angle = 45;
GB_inclination = 70;

rotataxis = rotation('axis',zvector,'angle',GB_trace_angle*degree);
gbVec = rotate(xvector, rotataxis);
gbVec = gbVec./norm(gbVec);
perp_gb = cross(zvector, gbVec);

rotataxis = rotation('axis',gbVec,'angle',GB_inclination*degree);
gbVecInc = rotate(perp_gb, rotataxis) + gbVec;

dGB = gbVec - gbVecInc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normalization of vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dGB = dGB./norm(dGB);
dA = dA./norm(dA);
dB = dB./norm(dB);
nA = nA./norm(nA);
nB = nB./norm(nB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rotation of slip directions and normals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nA_rot = rotate(nA, o_grainA);
dA_rot = rotate(dA, o_grainA);
nB_rot = rotate(nB, o_grainB);
dB_rot = rotate(dB, o_grainB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of intersection lines between GB plane and slip plane
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lA = cross(dGB, dA_rot);
lB = cross(dGB, dB_rot);
lA = lA./norm(lA);
lB = lB./norm(lB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check orthogonality (optional)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tol = 1e-9; % tolerance for test if normals and directions are perpendicular
resA = dot(lA, dA_rot);
resB = dot(lB, dB_rot);
if resA < tol && resB < tol
    orthoVal = 1;
else
    orthoVal = 0;
    disp('Vectors are not orthogonals !');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation of LRB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LRB = 0.95 with STABIX and 0.95 with MTEX for both cases
if orthoVal
    LRB = dot(lA, lB) * dot(dA_rot, dB_rot)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check orthogonality (optionnal)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tol = 1e-9; % tolerance for test if normals and directions are perpendicular
resA = dot(nA_rot, dA_rot);
resB = dot(nB_rot, dB_rot);
if resA < tol && resB < tol
    orthoVal = 1;
else
    orthoVal = 0;
    disp('Vectors are not orthogonals !');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation of m'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% m' = 0.94 and 0.9455 with MTEX
if orthoVal
    mp1 = dot(nA_rot, nB_rot) * dot(dA_rot, dB_rot);
    mp1 = abs(mp1)
    
    % Optionnal
    mp2 = dot(nB_rot, nA_rot) * dot(dB_rot, dA_rot);
    mp2 = abs(mp2)
end