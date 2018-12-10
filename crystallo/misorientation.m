% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [misor_angle, misor_axis] = misorientation(euler1, euler2, struct1, struct2, varargin)
%% Function used to calculate misorientation between 2 grains.
% From Kamp A. - Master Thesis (06/2007) -  Delft Universit of Technology
% see the book "Introduction to Texture Analysis: Macrotexture,
% Microtexture and Orientation Mapping", by Randle and Engler (2000), p.27.

% euler1 : Euler angles of the 1st crystal in degrees
% euler2 : Euler angles of the 2nd crystal in degrees
% struct1 : Structure of the 1st crystal (hcp, bcc or fcc)
% struct2 : Structure of the 2nd crystal (hcp, bcc or fcc)

if nargin < 4
    struct1 = 'hcp';
    struct2 = 'hcp';
end

if nargin < 2
    euler1 = randBunges; disp(euler1);
    euler2 = randBunges; disp(euler2);
end

g1 = eulers2g(euler1);
g2 = eulers2g(euler2);
g_mis = g2 * inv(g1);
sym_op1 = sym_operators(struct1);
sym_op2 = sym_operators(struct2);

if size(sym_op1,1) == size(sym_op2,1)
    theta = 180;
    for t = 1:size(sym_op1,1)/3
        for m = 1:size(sym_op2,1)/3
            C = sym_op1(((3*t)-2):3*t,:)*g_mis*sym_op2(((3*m)-2):3*m,:);
            test = acosd((C(1,1)+C(2,2)+C(3,3)-1)/2);
            if test < theta
                theta = test;
                ang = acosd((C(1,1)+C(2,2)+C(3,3)-1)/2); % trace(C) = C(1,1)+C(2,2)+C(3,3)
                axis = [(C(2,3)-C(3,2)),(C(3,1)-C(1,3)),(C(1,2)-C(2,1))];
            else
                clear test;
            end
        end
    end
    misor_angle = ang;
    misor_axis = axis;
else
    misor_angle = NaN;
    misor_axis = NaN;
end

end