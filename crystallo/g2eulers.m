% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function eulers = g2eulers(g_mat, varargin)
%% Function used to return three Bunge Euler Angles in degrees
% g_mat : 3x3 rotation matrix g_mat
% see in the book "Introduction to Texture Analysis: Macrotexture,
% Microtexture and Orientation Mapping", by Randle and Engler (2000), p.27.

% translated from MPIE dreheul.f subroutine (see below)
% author: c.zambaldi@mpie.de

if nargin == 0
    g_mat = eulers2g;
    disp(g_mat);
end

tol2 = 1e-6; % insertion made by C. Zambaldi

if abs(det(g_mat))-1 > tol2 % det~=1
    det_g = det(g_mat);
    if abs(det_g - 1) > tol2  % orthogonality
        error('g matrix not orthogonal. det ~= 1');
    elseif det(g_mat)+1<tol2
        error('g matrix  det = -1');
    end
end

% improper rotation (containing inversion), det == -1
%if abs(det(g_mat)+1)>tol
%g_mat = -g_mat; % introduced 2010-09-03
%end

tol2 = 1e-10; % insertion made by C. Zambaldi

% norm of first column
squvw = sqrt(g_mat(1,1)^2 + g_mat(2,1)^2 + g_mat(3,1)^2);
% norm of last column
sqhkl = sqrt(g_mat(1,3)^2 + g_mat(2,3)^2 + g_mat(3,3)^2);
sqhk = sqrt(g_mat(1,3)^2 + g_mat(2,3)^2);

% calculate PHI
val = g_mat(3,3)/sqhkl;

if abs(g_mat(3,3)) < tol2  % insertion made by C. Zambaldi (28.5.2007)
    val = 0;               % insertion made by C. Zambaldi (for specific case)
end                        % C. Zambaldi g = [1 0 0; 0 -1 0; 0 0 -1]

PHI = acos(val);

if(PHI < 1.e-30)%       if(PHI.LT.1.d-30) then
    % calculate phi2
    phi2 = 0.0;
    % calculate phi1
    val = g_mat(1,1)/squvw;
    if(g_mat(2,1) <= 0.0)  % if(g(2,1).LE.0.0) then
        phi1 = acos(val);
    else
        phi1 = 2*pi-acos(val);
    end
else
    % calculate phi2
    val = g_mat(2,3)/sqhk;
    if abs(g_mat(2,3)) < tol2 % insertion made by C. Zambaldi (28.5.2007)
        val = 0;              % insertion made by C. Zambaldi (for specific case)
    end                       % C. Zambaldi   g = [1 0 0; 0 -1 0; 0 0 -1]
    if(g_mat(1,3) >= 0.0)
        phi2 = acos(val);
    else
        phi2 = 2*pi-acos(val);
    end
    % calculate phi1
    val = -g_mat(3,2)/sin(PHI);
    if abs(g_mat(3,2)) < 1e-16 % insertion made by C. Zambaldi (28.5.2007)
        val = 0;               % insertion made by C. Zambaldi (for specific case)
    end                        % C. Zambaldi   g = [1 0 0; 0 -1 0; 0 0 -1]
    if(g_mat(3,1) >= 0.0)
        phi1 = acos(val);
    else
        phi1 = 2*pi-acos(val);
    end
end

eulers = [phi1 PHI phi2]*180/pi;
if norm(imag(eulers)) < tol2
    eulers = real(eulers);
end

return

end

% subroutine mpie_dreheul(g, phi1, PHI, phi2)
% c********************************************************************
% c     This MPIE routine calculates Euler angles [°] from orientation matrix
% c********************************************************************
%       use mpie, only: pi, r2g, g2r
%       implicit real(8) (a-h,o-z)
% c
%       dimension g(3,3)
% c
%       sqhkl=sqrt(g(1,3)*g(1,3)+g(2,3)*g(2,3)+
%      1             g(3,3)*g(3,3))
%       squvw=sqrt(g(1,1)*g(1,1)+g(2,1)*g(2,1)+
%      1             g(3,1)*g(3,1))
%       sqhk=sqrt(g(1,3)*g(1,3)+g(2,3)*g(2,3))
% c     calculate PHI
%       val=g(3,3)/sqhkl
%       PHI=acos(val)
% c
%       if(PHI.LT.1.d-30) then
% c       calculate phi2
%           phi2=0.0
% c       calculate phi1
%           val=g(1,1)/squvw
%           if(g(2,1).LE.0.0) then
%               phi1=acos(val)
%           else
%               phi1=2*pi-acos(val)
%           end if
%       else
% c       calculate phi2
%           val=g(2,3)/sqhk
%           if(g(1,3).GE.0.0) then
%               phi2=acos(val)
%           else
%               phi2=2*pi-acos(val)
%           end if
% c       calculate phi1
%           val=-g(3,2)/sin(PHI)
%           if(g(3,1).GE.0.0) then
%               phi1=acos(val)
%           else
%               phi1=2*pi-acos(val)
%           end if
%       end if
% c     convert angles to grad
%       phi1=phi1*r2g
%       PHI=PHI*r2g
%       phi2=phi2*r2g
%       end
% c
% c
% c #####################################################