% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function bool = isrot(g_mat, varargin)
%% Function to check if g_mat is a 3x3 rotation matrix
% g_mat: 3x3 rotation matrix
% see in the book "Introduction to Texture Analysis: Macrotexture, Microtexture and Orientation Mapping",
% written by Randle and Engler, (2000), p.27.

if nargin == 0
    g_mat = eulers2g;
    display(g_mat);
end

if abs(det(g_mat)-1) > 1e-14
    commandwindow;
    error(['Determinant of rotation Matrix is unequal +1.' ...
        'It deviates by %e\n'], det(g_mat)-1);
    bool = false;
else
    bool = true;
end

end