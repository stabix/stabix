% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function g_mat = axisang2g(axis, ang, varargin)
%% Function adapted from A.D. Rollet subroutine axisang2rot(axis,ang,rot)
% axis: Normalized axis vector and will be normalized anyway
% ang: Rotation angle in degrees
% rot: 3x3 matrix , CZ: active Rotation, rotates points
% real cc, ss, rnorm, rsum, axis(3), axis2(3), ang,rot(3,3)

if nargin < 2
    ang = 45; disp(ang);
end

if nargin == 0
    axis = [1 0 0]; disp(axis);
end

flag_error = 0;
if length(axis) > 3
    flag_error = 1;
    commandwindow;
    error(['Axis is defined with only 3 indices.'...
        'It has to be given in cartesian coordinates system...']);
end

if ~flag_error
    ang_rad = ang/180*pi;
    %do 100, i=1,3
    axis2 = axis.^2; %axis2(i)=axis(i)^2
    %100continue
    rnorm = sqrt(sum(axis2));
    %do 200, i=1,3
    axis_n = axis/rnorm; %axis(i)=axis(i)/rnorm
    axis_n2 = axis_n.^2;% necessary because axis2 is used below!!
    %200continue
    % normalize anyway!
    cc = cos(ang_rad);
    ss = sin(ang_rad);
    g_mat(1,1) = axis_n2(1) + cc * (1-axis_n2(1));
    g_mat(2,2) = axis_n2(2) + cc * (1-axis_n2(2));
    g_mat(3,3) = axis_n2(3) + cc * (1-axis_n2(3));
    g_mat(1,2) = (1.-cc) * axis_n(1) * axis_n(2) + ss*axis_n(3);
    g_mat(2,1) = (1.-cc) * axis_n(1) * axis_n(2) - ss*axis_n(3);
    g_mat(2,3) = (1.-cc) * axis_n(2) * axis_n(3) + ss*axis_n(1);
    g_mat(3,2) = (1.-cc) * axis_n(2) * axis_n(3) - ss*axis_n(1);
    g_mat(3,1) = (1.-cc) * axis_n(1) * axis_n(3) + ss*axis_n(2);
    g_mat(1,3) = (1.-cc) * axis_n(1) * axis_n(3) - ss*axis_n(2);
end

end

% if isrot(g_mat)==1
%     return
% else
%     fprintf('**axisang2g error: isrot\n')
% end

% test with
% axisang2g([1 1 1],180) ?= axisang2g([1 1 1]/sqrt(3),180)
