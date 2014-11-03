% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function misorientation = MTEX_getBX_misorientation(ori_grainA, ori_grainB, varargin)
%% MTEX function used for the calculation of the misorientation between 2 grains in degrees
% Cho J.-H. et al., "Determination of a Mean Orientation in Electron
% Backscatter Diffraction Measurements", Met. & Mat. Trans. A, 2005, Vol.36A, pp. 3427.

% Biyikli E., "Three-dimensional modeling of the grain boundary
% misorientation angle distribution based on two-dimensional experimental texture measurements",
% Materials Science and Engineering, 2010, pp. 5604–5612.

% See in http://mtex-toolbox.github.io/

% ori_grainA / ori_grainB : defines an orientation (see MTEX documentation)
%
% Syntax
% ori = orientation(rot,cs,ss) -
% ori = orientation('Euler',phi1,Phi,phi2,cs,ss) - Euler angles in radians
% ori = orientation('Euler',alpha,beta,gamma,'ZYZ',cs,ss) -
% ori = orientation('Miller',[h k l],[u v w],cs,ss) -
% ori = orientation(name,cs,ss) -
% ori = orientation('axis,v,'angle',omega,cs,ss) -
% ori = orientation('matrix',A,cs) -
% ori = orientation('map',u1,v1,u2,v2,cs) -
% ori = orientation('quaternion',a,b,c,d,cs) -
%
% Input
% rot       - @rotation
% cs, ss    - @symmetry
% u1,u2     - @Miller
% v, v1, v2 - @vector3d
% name      - named orientation
% currently available:
%
% * 'Cube', 'CubeND22', 'CubeND45', 'CubeRD'
% * 'Goss', 'invGoss'
% * 'Copper', 'Copper2'
% * 'SR', 'SR2', 'SR3', 'SR4'
% * 'Brass', 'Brass2'
% * 'PLage', 'PLage2', 'QLage', 'QLage2', 'QLage3', 'QLage4'
%
% Ouptut
% ori - @orientation
%
% See also
% quaternion_index orientation_index

% author: d.mercier@mpie.de

if nargin < 2
    ori_grainB = orientation('Euler', 0.7854, 0.7854, 0.7854, 'hexagonal');
    display(ori_grainB);
end

if nargin < 1
    ori_grainA = orientation('Euler', 0, 0, 0, 'hexagonal');
    display(ori_grainA)
end

if nargin == 1
    warning('Missing inputs !');
    commandwindow;
    return
end

% Calculation of misorientation (in degrees)
misorientation = angle(ori_grainA, ori_grainB)*180/pi;

end