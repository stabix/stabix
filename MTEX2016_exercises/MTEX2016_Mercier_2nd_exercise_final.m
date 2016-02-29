%% 2nd Exercise - Grain boundaries and plasticity
% From Mercier D. - MTEX 2016 Workshop - TU Chemnitz (Germany)

% Calculation of residual Burgers vector
% Data from paper written by Kacher J and Robertson I.M.
% "In situ and tomographic analysis of dislocation/grain boundary interactions in α-titanium.",
% Philosophical Magazine (2014), 94(8), pp. 814-829.

% cp-Ti sample (alpha phase - hcp) compressed in situ TEM

clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Crystal symmetry
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = 1; b = 1; c = 1.5875;
cs = loadCIF('Ti-Titanium-alpha.cif');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rotation matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
angleVal = 32;
UVTW = [1,5,-6,16];

angleVal = 40;
UVTW = [1,-2,1,-3];

axisVec = Miller(UVTW(1),UVTW(2),UVTW(3),UVTW(4),cs,'UVTW');

% Calculation of rotation matrices with MTEX
o_grainA = rotation('axis',xvector,'angle',0*degree);
o_grainB = rotation('axis',axisVec,'angle',angleVal*degree);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Definition of slip directions (Burger vectors)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
uvtw_1 = [-1, 2, -1, 0];
uvtw_2 = [2, -1, -1, 0];

uvtw_1 = [-1,2,-1,3];
uvtw_2 = [1,1,-2,0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Conversion of slip vectors from Bravais-Miller to cartesian coordinates
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dA = Miller(uvtw_1(1),uvtw_1(2),uvtw_1(3),uvtw_1(4),cs,'UVTW');
dB = Miller(uvtw_2(1),uvtw_2(2),uvtw_2(3),uvtw_2(4),cs,'UVTW');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normalization of vectors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Normalization of vectors ???

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Rotation of slip directions and normals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dA_rot = rotate(dA, o_grainA);
dB_rot = rotate(dB, o_grainB);

% dA_rot = o_grainA.' * dA;
% dB_rot = o_grainB.' * dB;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculation of rbv
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rbv = 4.2 from Kacher and 4.23 with STABIX or 4.15 with MTEX
% rbv = 4.1 from Kacher and 5.63 with STABIX or 5.53 with MTEX
rbv = dA_rot - dB_rot;
rbv = norm(rbv)