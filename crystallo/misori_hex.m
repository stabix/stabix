% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function axis_angle = misori_hex(eulers1, eulers2, varargin)
%% Function used to calculate misorientation between 2 HCP grains.
% see the book "Introduction to Texture Analysis: Macrotexture, Microtexture and Orientation Mapping",
% written by Randle and Engler (2000), p.27.

% eulers1 : Euler angles of the 1st crystal in degrees
% eulers2 : Euler angles of the 2nd crystal in degrees

% author: c.zambaldi@mpie.de

% axis_angle = 4 values in a row vector (1 to 3 values are thes
% misorientation axis and 4th value is the misorientation angle)

% COULD BE MUCH IMPROVED BY USING g2axisang,
% SEE misori_hex_TEST

%%
if nargin < 3
    nsym=12;
    %nsym=24;  % with inversion
else
    nsym = varargin{1};
    if nsym ~= 12 && nsym ~= 24
        error('3rd argument (nsym) must be 12 or 24')
    end
end

if nargin < 2
    eulers1 = randBunges; disp(eulers1);
    eulers2 = randBunges; disp(eulers2);
end

fi1 = [eulers1(1) eulers2(1)];
fi = [eulers1(2) eulers2(2)];
fi2 = [eulers1(3) eulers2(3)];

axis_angle(1) = 0 ;
axis_angle(2) = 0 ;
axis_angle(3) = 0 ;
axis_angle(4) = 360 ;

%%
SYM = zeros(3,3,nsym);

% maybe use mtex (see ex. sym2mat) for SYM calc. or sym_operators function

a = sqrt(3)/2;

x = [1;0;0];
y = [0;1;0];
ax = [a; -.5; 0];
ay = [-.5; a; 0];
z = [0;0;1];

%Kocks: Texture and Anisotropy, Chp. 1, Tab 1, pg.25
SYM(:,:,1) = [ x      y     z]';
SYM(:,:,2) = [ -x-ay  ax    z]';
SYM(:,:,3) = [ ay    -y-ax  z]';
SYM(:,:,4) = [ -ay    y+ax  z]';
SYM(:,:,5) = [ -x    -y     z]';
SYM(:,:,6) = [ x+ay  -ax    z]';
SYM(:,:,7) = [ -x-ay -ax   -z]';
SYM(:,:,8) = [ x     -y    -z]';
SYM(:,:,9) = [ ay     y+ax -z]';
SYM(:,:,10) =[ x+ay  ax    -z]';
SYM(:,:,11) =[  -x   y     -z]';
SYM(:,:,12) =[ -ay  -y-ax  -z]';

%%
if nsym == 24
    inv33 = eye(3,3)*(-1);
    for ii = 13:24
        SYM(:,:,ii) = SYM(:,:,ii-12)*inv33;
    end
end

for ll = 0:.5:1
    
    g(:,:,1) = eulers2g(eulers1);
    g(:,:,2) = eulers2g(eulers2);
    
    DM  = g(:,:,1)'; %DM[i][j] = D[j][i][0] ;
    DR  = zeros(3,3) ;
    DRR = zeros(3,3,nsym) ;
    
    %     for i=1:3
    %         for j=1:3
    %             for k=1:3
    %                 DR(i,j) = D(i,k,2) * DM(k,j) + DR(i,j) ;
    %             end
    %         end
    %     end
    %neu eingefügt
    DR = g(:,:,2)*DM;
    %ende eingefügt
    for m = 1:nsym
        %         for i=1:3
        %             for j=1:3
        %                 for k=1:3
        %                     DRR(i,j,m) = SYM(i,k,m) .* DR(k,j) + DRR (i,j,m) ;
        %                 end
        %             end
        %         end
        %neu eingefügt
        DRR(:,:,m) = SYM(:,:,m)*DR;
        %ende eingefügt
        spur = 0 ;
        for ii = 1:3
            spur = spur + DRR(ii,ii,m);
        end
        sp = (spur - 1) * 0.499999 ;
        if (sp >= 1)
            sp = 0.9999 ;
        end
        if (sp <= -1)
            sp = -0.9999 ;
        end
        omega = pi * 0.5 - asin(sp) ;
        alpha = omega * 180 / pi ;
        x = 2 * sin(omega) ;
        if (x < 0.001)
            x = 0.001 ;
        end
        xx = 1 / x ;
        A(1) = 100 * (DRR(2,3,m) - DRR (3,2,m)) * xx ;
        A(2) = 100 * (DRR(3,1,m) - DRR (1,3,m)) * xx ;
        A(3) = 100 * (DRR(1,2,m) - DRR (2,1,m)) * xx ;
        for ii = 1:3
            if (abs(A(ii))<0.001)
                IA(ii) = 0 ;
            else
                IA(ii) = round( (A(ii) + 0.5 * A(ii) / abs(A(ii)))) ;
            end
        end
        if abs(alpha) < axis_angle(4)
            axis_angle(1) = IA(1) ;
            axis_angle(2) = IA(2) ;
            axis_angle(3) = IA(3) ;
            axis_angle(4) = abs(alpha) ;
        end
    end
    if ll == 0
        fi1(1) = 180 + fi1(1) ;
    end
    if ll == 1
        fi1(1) = 360 - fi1(1) ;
        fi2(1) = 90 - fi2(1) ;
    end
    if ll == 2
        fi1(1) = 180 + fi1(1) ;
    end
end

i_min = 100 ;

if((abs(axis_angle(1))<i_min)&&(abs(axis_angle(1))>0))
    i_min = abs(axis_angle(1)) ;
end

if((abs(axis_angle(2))<i_min)&&(abs(axis_angle(2))>0))
    i_min = abs(axis_angle(2)) ;
end

if((abs(axis_angle(3))<i_min)&&(abs(axis_angle(3))>0))
    i_min = abs(axis_angle(3)) ;
end

for ii = 1:3
    axis_angle(ii) = round((axis_angle(ii) / i_min)) ;
end

return

end
