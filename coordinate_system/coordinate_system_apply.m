% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function eulers_out = ...
    coordinate_system_apply(eulers_in, CCM, testFlag, varargin)
%% Function used to apply the user selected coordinate system to the orientation
% eulers_in : Euler angles in degree before modification of the coordinates sytem
% ccm (coordinate convention matrix): Results from the function coordinate_convention_matrix.m
% testFlag: Flag to test the function (1 if the user want to test)

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin < 3
    testFlag = false;
end

if nargin < 2
    e1 = [1;0;0];
    e2 = [0;1;0];
    e3 = [0;0;1];
    CCM = [ e1, e2, e3];
    testFlag = false;
end

if nargin == 0
    e1 = [1;0;0];
    e2 = [0;1;0];
    e3 = [0;0;1];
    CCM = [ e1, e2, e3];
    eulers_in = randBunges;
    testFlag = true;
end

g_in       = eulers2g(eulers_in);
g_out      = g_in * CCM';
eulers_out = g2eulers(g_out);

if testFlag
    fprintf('Euler angles in : %.1f° %.1f° %.1f°\n', ...
        eulers_in(1),eulers_in(2),eulers_in(3));
    fprintf('Euler angles out : %.1f° %.1f° %.1f°\n', ...
        eulers_out(1),eulers_out(2),eulers_out(3));
end

end