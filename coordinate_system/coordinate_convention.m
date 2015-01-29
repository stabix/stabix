% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function coordinate_convention_matrix = ...
    coordinate_convention(coordinate_angle, varargin)
% coordinate_angle: Angle to rotate coordinate system of EBSD system

% Z out of the plane
%    0   X right, Y up
%   90   X up, Y left
%  180   X left, Y down
%  270   X down, Y right
%
% Z into the plane
% -360  X right, Y down
%  -90  X up, Y right
% -180  X left, Y up
% -270  X down, Y left

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0
    coordinate_angle = 0;
    testFlag = true;
else
    testFlag = false;
end

e1 = [1;0;0];
e2 = [0;1;0];
e3 = [0;0;1];

switch coordinate_angle
    case 0
        CCM = [ e1, e2,e3];
    case 90
        CCM = [ e2,-e1,e3];   
    case 180
        CCM = [-e1,-e2,e3];
    case 270
        CCM = [-e2, e1,e3];   
    case -360  % X right, Y down
        CCM = [ e1,-e2,-e3];  
    case -90   % X up, Y right
        CCM = [ e2, e1,-e3];   
    case -180  % X left, Y up
        CCM = [-e1, e2,-e3];
    case -270  % X down, Y left
        CCM = [-e2,-e1,-e3];           
end

coordinate_convention_matrix = CCM;

if testFlag
    fprintf('Coordinate convention matrix :')
    coordinate_convention_matrix;
end

end