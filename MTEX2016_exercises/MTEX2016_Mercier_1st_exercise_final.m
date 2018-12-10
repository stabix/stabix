%% 1st Exercise - Grain boundaries and plasticity
% From Mercier D. - MTEX 2016 Workshop - TU Chemnitz (Germany)

% Calculation of m' parameter
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Orientations and Rotation matrices
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EulA = [227, 4, 344];
EulB = [325, 177, 281];

% EulA = [270 121 105];
% EulB = [162 29 49];

oA = rotation('Euler',EulA(1)*degree,EulA(2)*degree,EulA(3)*degree);
oB = rotation('Euler',EulB(1)*degree,EulB(2)*degree,EulB(3)*degree);

ebsd.orientations(1) = orientation(oA,cs);
ebsd.orientations(2) = orientation(oB,cs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Misorientation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
misorientation = inv (oB) * oA

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Misorientation angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Misorientation angle = 13.9° with STABiX and 13.9 with MTEX
misorAngle = angle(ebsd.orientations(1), ebsd.orientations(2))*180/pi

% Is it the disorientation angle ?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% c-axis misorientation angle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Misorientation angle = 4.7°
zvector_rotA = rotate(zvector, oA);
zvector_rotB = rotate(zvector, oB);

% Wrong way
caxis_misorientation = angle(zvector_rotA, zvector_rotB)*180/pi

% Good way
caxis_misorientation = angle(cs.cAxis,inv(oA)*oB*cs.cAxis)/degree

% Misorientation between 2 plane directions...
h = Miller(1,1,-2,1,cs,'uvtw');
min(angle(h.symmetrise, inv(oA)*oB*h.symmetrise)/degree)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Slip systems
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st and 2nd examples
% Prismatic <a> / Prismatic <a>
hkil_A = [0,1,-1,0];
uvtw_A = [2,-1,-1,0];
hkil_B = [0,1,-1,0];
uvtw_B = [2,-1,-1,0];

% 1st example
% % Prismatic <a> / Basal <a>
hkil_A = [1,-1,0,0];
uvtw_A = [-1,-1,2,0];
hkil_B = [0,0,0,1];
uvtw_B = [-1,2,-1,0];

% 2nd example
% % Prismatic <a> / Pyramidal <a>
% hkil_A = [-1,0,1,0];
% uvtw_A = [-1,2,-1,0];
% hkil_B = [0,-1,1,1];
% uvtw_B = [2,-1,-1,0];

% What happens if you give opposite direction ?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conversion of slip vectors from Bravais-Miller to cartesian coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nA = Miller(hkil_A(1),hkil_A(2),hkil_A(3),hkil_A(4),cs,'hkil');
dA = Miller(uvtw_A(1),uvtw_A(2),uvtw_A(3),uvtw_A(4),cs,'UVTW');
nB = Miller(hkil_B(1),hkil_B(2),hkil_B(3),hkil_B(4),cs,'hkil');
dB = Miller(uvtw_B(1),uvtw_B(2),uvtw_B(3),uvtw_B(4),cs,'UVTW');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normalization of vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nA = vector3d(nA);
dA = vector3d(dA);
nB = vector3d(nB);
dB = vector3d(dB);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rotation of slip directions and normals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nA_rot = rotate(nA, oA);
dA_rot = rotate(dA, oA);
nB_rot = rotate(nB, oB);
dB_rot = rotate(dB, oB);

% Other solution
% nA_rot = o_grainA.' * nA;
% dA_rot = o_grainA.' * dA;
% nB_rot = o_grainB.' * nB;
% dB_rot = o_grainB.' * dB;

% Active or passive rotation ?

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check orthogonality (optional)
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
% 1st example
% m' = 0.94 in Guo's paper and 0.95 with MTEX
% m' = 0.08 in Guo's paper and 0.08 with MTEX

% 2nd example
% m' = 0.46 in Guo's paper and 0.45 with MTEX
% m' = 0.80 in Guo's paper and 0.72 with MTEX (0.72 in STABiX) ???

if orthoVal
    mp1 = dot(nA_rot.normalize, nB_rot.normalize) * ...
        dot(dA_rot.normalize, dB_rot.normalize);
    mp1 = abs(mp1)
    
    % Optionnal
    mp2 = dot(nB_rot.normalize, nA_rot.normalize) * ...
        dot(dB_rot.normalize, dA_rot.normalize);
    mp2 = abs(mp2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stress Tensor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r = vector3d(1,0,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation of Schmid factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st example
% tauB = 0.4993 for m' = 0.94
% tauB = -0.007 for m' = 0.08

% 2nd example
% tauB = -0.4475 for m' = 0.46
% tauB = 0.3334 for m' = 0.80

tauB_ = dot(nB_rot,r) * dot(dB_rot,r)
