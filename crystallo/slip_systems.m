% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [slip_syst, check_flag] = slip_systems(structure, slip_system, varargin)
%% Function used to calculate normal and Burgers vectors for given slip systems and for a given grain
% structure : hcp, bcc or fcc
% slip_system : setting of slip systems to take into account

% [YOO 1981] : DOI ==> 10.1007/BF02648537
% [WANG 2003]: DOI ==> 10.1016/S0254-0584(03)00168-8
% [CAPOLUNGO 2008] : DOI ==> 10.1103/PhysRevB.78.024117
% [BATTAINI 2008] : PhD thesis of Battaini M. - "Deformation behaviour and twinning mechanisms of commercially pure titanium alloys"
% [POTY 2011] : DOI ==> 10.1063/1.3599870
% [WANG 2011] : DOI ==> 10.1016/j.actamat.2011.03.024
% [BAO 2011] : PhD thesis of Bao L. - "Contribution to the Study of Deformation Twinning in Titanium"
% popLA : http://dx.doi.org/10.1155/TSM.14-18.1203

% Same indexation as in DAMASK (http://damask.mpie.de/)
% authors: d.mercier@mpie.de / bieler@egr.msu.edu

if nargin < 2
    slip_system = 9;
end

if nargin < 1
    structure = 'hcp';
end

if strcmp(structure, 'hcp') == 1
    slip_syst =  NaN(2, 4, 57);
elseif strcmp(structure, 'bcc') == 1
    slip_syst =  NaN(2, 3, 60);
elseif strcmp(structure, 'fcc') == 1
    slip_syst =  NaN(2, 3, 24);
end

for ii = 1:1:size(slip_system, 2) % If more than 1 slip/twin system is defined by the user in the popup menu (ctrl + left click)
    %% hcp structure - Slip system (in Bravais-Miller notation)
    if strcmp(structure,'hcp')
        % ss(:,:,nslphex) = [plane normal ; slip direction = Burgers vector direction];
        % If a direction has the same Miller Indices as a plane, it is NORMAL to that plane
        % [POTY 2011]  == > Principal slip for Ti = basal <a> and prisma <a> !!!! [WANG 2003]
        % See "millerbravaisdir2cart.m" and "millerbravaisplane2cart.m" for
        % conversion in cartesian notations.
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 2 ...
                || slip_system(ii) == 9
            % basal <a> - glide [Cd Be Zn Mg Re Ti Re]
            % {00.1} <11.0>
            slip_syst(:,:,1) = [0 0 0 1 ;  2 -1 -1 0];
            slip_syst(:,:,2) = [0 0 0 1 ; -1  2 -1 0];
            slip_syst(:,:,3) = [0 0 0 1 ; -1 -1  2 0];
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 3 ...
                || slip_system(ii) == 9
            % prisma1 <a> - glide [Ti Zr Re Be Re Mg] - 1st order
            % {10.0} <11.0>
            slip_syst(:,:,4) = [ 0  1 -1 0 ;  2 -1 -1 0];
            slip_syst(:,:,5) = [-1  0  1 0 ; -1  2 -1 0];
            slip_syst(:,:,6) = [ 1 -1  0 0 ; -1 -1  2 0];
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 4 ...
                || slip_system(ii) == 9
            % prisma2 <a> - 2nd order
            % {11.0}<10.0>
            slip_syst(:,:,7) = [ 2 -1 -1 0 ; 0  1 -1 0];
            slip_syst(:,:,8) = [-1  2 -1 0 ;-1  0  1 0];
            slip_syst(:,:,9) = [-1 -1  2 0 ; 1 -1  0 0];
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 5 ...
                || slip_system(ii) == 9
            % pyramidal <a> - glide [Mg Ti]
            % {-11.1} <11.0>
            slip_syst(:,:,10) = [ 0 -1  1 1 ;  2 -1 -1 0];
            slip_syst(:,:,11) = [ 1  0 -1 1 ; -1  2 -1 0];
            slip_syst(:,:,12) = [-1  1  0 1 ; -1 -1  2 0];
            slip_syst(:,:,13) = [ 1 -1  0 1 ;  1  1 -2 0];
            slip_syst(:,:,14) = [ 0  1 -1 1 ; -2  1  1 0];
            slip_syst(:,:,15) = [-1  0  1 1 ;  1 -2  1 0];
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 6 ...
                || slip_system(ii) == 9
            % pyramidal <c+a> - glide - 1st order
            % {-10.1} <11.3>
            slip_syst(:,:,16) = [-1  1  0 1 ;  2 -1 -1 3];
            slip_syst(:,:,17) = [-1  1  0 1 ;  1 -2  1 3];
            slip_syst(:,:,18) = [ 1  0 -1 1 ; -1 -1  2 3];
            slip_syst(:,:,19) = [ 1  0 -1 1 ; -2  1  1 3];
            slip_syst(:,:,20) = [ 0 -1  1 1 ; -1  2 -1 3];
            slip_syst(:,:,21) = [ 0 -1  1 1 ;  1  1 -2 3];
            slip_syst(:,:,22) = [ 1 -1  0 1 ; -2  1  1 3];
            slip_syst(:,:,23) = [ 1 -1  0 1 ; -1  2 -1 3];
            slip_syst(:,:,24) = [-1  0  1 1 ;  1  1 -2 3];
            slip_syst(:,:,25) = [-1  0  1 1 ;  2 -1 -1 3];
            slip_syst(:,:,26) = [ 0  1 -1 1 ;  1 -2  1 3];
            slip_syst(:,:,27) = [ 0  1 -1 1 ; -1 -1  2 3];
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 7 ...
                || slip_system(ii) == 9
            %  pyramidal <c+a> - glide - 2nd order
            % {-1-1.2} <11.3>
            slip_syst(:,:,28) = [-2  1  1 2 ;  2 -1 -1 3];
            slip_syst(:,:,29) = [ 1 -2  1 2 ; -1  2 -1 3];
            slip_syst(:,:,30) = [ 1  1 -2 2 ; -1 -1  2 3];
            slip_syst(:,:,31) = [ 2 -1 -1 2 ; -2  1  1 3];
            slip_syst(:,:,32) = [-1  2 -1 2 ;  1 -2  1 3];
            slip_syst(:,:,33) = [-1 -1  2 2 ;  1  1 -2 3];
        end
        %-------------------------------------------------------------------------------------------------------------------------------------------
        % hcp structure - Twins
        % twshzr = shear strain of twinning and corr = correction parameter for twinning shear as a function of c/a (from Kock's file = popLA)
        % Compression or Tension = f(twinning shear=f(c/a)) for each metal ! [YOO 1981]
        % [CAPOLUNGO 2008] & [WANG 2011] & [BAO 2011]
        %  == > [BATTAINI 2008]
        
        % *** Twin directions are opposite in Christian and Mahajan, and are not correcte to to be consistent with them
        if slip_system(ii) == 8 || slip_system(ii) == 9
            % {10.2}<-10.1> T1 - Tension twins twshzr=0.17; corr=-1.3; [all but compression for Zn and Cd]
            slip_syst(:,:,34) = [-1  1  0 2 ;  1 -1  0 1];
            slip_syst(:,:,35) = [ 1  0 -1 2 ; -1  0  1 1];
            slip_syst(:,:,36) = [ 0 -1  1 2 ;  0  1 -1 1];
            slip_syst(:,:,37) = [ 1 -1  0 2 ; -1  1  0 1];
            slip_syst(:,:,38) = [-1  0  1 2 ;  1  0 -1 1];
            slip_syst(:,:,39) = [ 0  1 -1 2 ;  0 -1  1 1];
            % {-1-1.1}<11.6> T2 - Tension twins: twshzr=0.63;  corr=-0.4; [Ti Zr Re];
            slip_syst(:,:,40) = [ 2 -1 -1 1 ; -2  1  1 6];
            slip_syst(:,:,41) = [-1  2 -1 1 ;  1 -2  1 6];
            slip_syst(:,:,42) = [-1 -1  2 1 ;  1  1 -2 6];
            slip_syst(:,:,43) = [-2  1  1 1 ;  2 -1 -1 6];
            slip_syst(:,:,44) = [ 1 -2  1 1 ; -1  2 -1 6];
            slip_syst(:,:,45) = [ 1  1 -2 1 ; -1 -1  2 6];
            % {10.1}<10.-2> C1 - Compression twins: twshzr=0.10; corr=1.1; [Ti Zr Mg];
            slip_syst(:,:,46) = [-1  1  0 1 ; -1  1  0 -2];
            slip_syst(:,:,47) = [ 1  0 -1 1 ;  1  0 -1 -2];
            slip_syst(:,:,48) = [ 0 -1  1 1 ;  0 -1  1 -2];
            slip_syst(:,:,49) = [ 1 -1  0 1 ;  1 -1  0 -2];
            slip_syst(:,:,50) = [-1  0  1 1 ; -1  0  1 -2];
            slip_syst(:,:,51) = [ 0  1 -1 1 ;  0  1 -1 -2];
            % {11.2}<11.-3> C2 - Compression twins:; twshzr=0.22; corr=1.2; [Ti Zr];
            slip_syst(:,:,52) = [ 2 -1 -1 2 ;  2 -1 -1 -3];
            slip_syst(:,:,53) = [-1  2 -1 2 ; -1  2 -1 -3];
            slip_syst(:,:,54) = [-1 -1  2 2 ; -1 -1  2 -3];
            slip_syst(:,:,55) = [-2  1  1 2 ; -2  1  1 -3];
            slip_syst(:,:,56) = [ 1 -2  1 2 ;  1 -2  1 -3];
            slip_syst(:,:,57) = [ 1  1 -2 2 ;  1  1 -2 -3];
        end
    end
    
    %% bcc structure - Slip system
    if strcmp(structure,'bcc')
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 2 ...
                || slip_system(ii) == 9
            slip_syst(:,:,1) =  [ 0  1  1 ;  1 -1  1];                                     %Index 1 in Damask
            slip_syst(:,:,2) =  [ 0  1  1 ; -1 -1  1];                                     %Index 2 in Damask
            slip_syst(:,:,3) =  [ 0 -1  1 ;  1  1  1];                                     %Index 3 in Damask
            
            slip_syst(:,:,4) =  [ 0 -1  1 ; -1  1  1];                                     %Index 4 in Damask
            slip_syst(:,:,5) =  [ 1  0  1 ; -1  1  1];                                     %Index 5 in Damask
            slip_syst(:,:,6) =  [ 1  0  1 ; -1 -1  1];                                     %Index 6 in Damask
            
            slip_syst(:,:,7) =  [-1  0  1 ;  1  1  1];                                     %Index 7 in Damask
            slip_syst(:,:,8) =  [-1  0  1 ;  1 -1  1];                                     %Index 8 in Damask
            slip_syst(:,:,9) =  [ 1  1  0 ; -1  1  1];                                     %Index 9 in Damask
            
            slip_syst(:,:,10) = [ 1  1  0 ; -1  1 -1];                                     %Index 10 in Damask
            slip_syst(:,:,11) = [-1  1  0 ;  1  1  1];                                     %Index 11 in Damask
            slip_syst(:,:,12) = [-1  1  0 ;  1  1 -1];                                     %Index 12 in Damask
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 3 ...
                || slip_system(ii) == 9
            % Mode 2,   plane direction, Define four points in the plane
            slip_syst(:,:,13) = [ 2  1  1 ; -1  1  1];                                     %Index 13 in Damask
            slip_syst(:,:,14) = [-2  1  1 ;  1  1  1];                                     %Index 14 in Damask
            slip_syst(:,:,15) = [ 2 -1  1 ;  1  1 -1];                                     %Index 15 in Damask
            
            slip_syst(:,:,16) = [ 2  1 -1 ;  1 -1  1];                                     %Index 16 in Damask
            slip_syst(:,:,17) = [ 1  2  1 ;  1 -1  1];                                     %Index 17 in Damask
            slip_syst(:,:,18) = [-1  2  1 ;  1  1 -1];                                     %Index 18 in Damask
            
            slip_syst(:,:,19) = [ 1 -2  1 ;  1  1  1];                                     %Index 19 in Damask
            slip_syst(:,:,20) = [ 1  2 -1 ; -1  1  1];                                     %Index 20 in Damask
            slip_syst(:,:,21) = [ 1  1  2 ;  1  1 -1];                                     %Index 21 in Damask
            
            slip_syst(:,:,22) = [-1  1  2 ;  1 -1  1];                                     %Index 22 in Damask
            slip_syst(:,:,23) = [ 1 -1  2 ; -1  1  1];                                     %Index 23 in Damask
            slip_syst(:,:,24) = [ 1  1 -2 ;  1  1  1];                                     %Index 24 in Damask
        end
        if slip_system(ii) == 1 ...
                || slip_system(ii) == 4 ...
                || slip_system(ii) == 9
            % Mode 3,   plane direction, Define four points in the plane
            slip_syst(:,:,25) = [ 1  2  3 ;  1  1 -1];                                     %Index 25 in Damask
            slip_syst(:,:,26) = [-1  2  3 ;  1 -1  1];                                     %Index 26 in Damask
            slip_syst(:,:,27) = [ 1 -2  3 ; -1  1  1];                                     %Index 27 in Damask
            slip_syst(:,:,28) = [ 1  2 -3 ;  1  1  1];                                     %Index 28 in Damask
            slip_syst(:,:,29) = [ 1  3  2 ;  1 -1  1];                                     %Index 29 in Damask
            slip_syst(:,:,30) = [-1  3  2 ;  1  1 -1];                                     %Index 30 in Damask
            
            slip_syst(:,:,31) = [ 1 -3  2 ;  1  1  1];                                     %Index 31 in Damask
            slip_syst(:,:,32) = [ 1  3 -2 ; -1  1  1];                                     %Index 32 in Damask
            slip_syst(:,:,33) = [ 2  1  3 ;  1  1 -1];                                     %Index 33 in Damask
            slip_syst(:,:,34) = [-2  1  3 ;  1 -1  1];                                     %Index 34 in Damask
            slip_syst(:,:,35) = [ 2 -1  3 ; -1  1  1];                                     %Index 35 in Damask
            slip_syst(:,:,36) = [ 2  1 -3 ;  1  1  1];                                     %Index 36 in Damask
            
            slip_syst(:,:,37) = [ 2  3  1 ;  1 -1  1];                                     %Index 37 in Damask
            slip_syst(:,:,38) = [-2  3  1 ;  1  1 -1];                                     %Index 38 in Damask
            slip_syst(:,:,39) = [ 2 -3  1 ;  1  1  1];                                     %Index 39 in Damask
            slip_syst(:,:,40) = [ 2  3 -1 ; -1  1  1];                                     %Index 40 in Damask
            slip_syst(:,:,41) = [ 3  1  2 ; -1  1  1];                                     %Index 41 in Damask
            slip_syst(:,:,42) = [-3  1  2 ;  1  1  1];                                     %Index 42 in Damask
            
            slip_syst(:,:,43) = [ 3 -1  2 ;  1  1 -1];                                     %Index 43 in Damask
            slip_syst(:,:,44) = [ 3  1 -2 ;  1 -1  1];                                     %Index 44 in Damask
            slip_syst(:,:,45) = [ 3  2  1 ; -1  1  1];                                     %Index 45 in Damask
            slip_syst(:,:,46) = [-3  2  1 ;  1  1  1];                                     %Index 46 in Damask
            slip_syst(:,:,47) = [ 3 -2  1 ;  1  1 -1];                                     %Index 47 in Damask
            slip_syst(:,:,48) = [ 3  2 -1 ;  1 -1  1];                                     %Index 48 in Damask
        end
        if slip_system(ii) == 8 || slip_system(ii) == 9
            % Twins
            slip_syst(:,:,49) = [ 2  1  1 ; -1  1  1];                                     %Index 1 in Damask
            slip_syst(:,:,50) = [-2  1  1 ;  1  1  1];                                     %Index 2 in Damask
            slip_syst(:,:,51) = [ 2 -1  1 ;  1  1 -1];                                     %Index 3 in Damask
            
            slip_syst(:,:,52) = [ 2  1 -1 ; 1 -1  1];                                      %Index 4 in Damask
            slip_syst(:,:,53) = [ 1  2  1 ; 1 -1  1];                                      %Index 5 in Damask
            slip_syst(:,:,54) = [-1  2  1 ; 1  1 -1];                                      %Index 6 in Damask
            
            slip_syst(:,:,55) = [ 1 -2  1 ;  1  1  1];                                     %Index 7 in Damask
            slip_syst(:,:,56) = [ 1  2 -1 ; -1  1  1];                                     %Index 8 in Damask
            slip_syst(:,:,57) = [ 1  1  2 ;  1  1 -1];                                     %Index 9 in Damask
            
            slip_syst(:,:,58) = [-1  1  2 ;  1 -1  1];                                     %Index 10 in Damask
            slip_syst(:,:,59) = [ 1 -1  2 ; -1  1  1];                                     %Index 11 in Damask
            slip_syst(:,:,60) = [ 1  1 -2 ;  1  1  1];                                     %Index 12 in Damask
        end
    end
    
    %% fcc structure - Slip system
    if strcmp(structure,'fcc')
        if slip_system(ii) == 1 || slip_system(ii) == 9
            % Mode 1,  plane direction, Define four points in the plane       For TiAl, 1,4,7,10 are ordinary dislocations
            slip_syst(:,:,1) =  [ 1  1  1 ;  0  1 -1];                                     %Index 1 in Damask
            slip_syst(:,:,2) =  [ 1  1  1 ; -1  0  1];                                     %Index 2 in Damask
            slip_syst(:,:,3) =  [ 1  1  1 ;  1 -1  0];                                     %Index 3 in Damask
            
            slip_syst(:,:,4) =  [-1 -1  1 ;  0 -1 -1];                                     %Index 4 in Damask
            slip_syst(:,:,5) =  [-1 -1  1 ;  1  0  1];                                     %Index 5 in Damask
            slip_syst(:,:,6) =  [-1 -1  1 ; -1  1  0];                                     %Index 6 in Damask
            
            slip_syst(:,:,7) =  [ 1 -1 -1 ;  0 -1  1];                                     %Index 7 in Damask
            slip_syst(:,:,8) =  [ 1 -1 -1 ; -1  0 -1];                                     %Index 8 in Damask
            slip_syst(:,:,9) =  [ 1 -1 -1 ;  1  1  0];                                     %Index 9 in Damask
            
            slip_syst(:,:,10) = [-1  1 -1 ;  0  1  1];                                     %Index 10 in Damask
            slip_syst(:,:,11) = [-1  1 -1 ;  1  0 -1];                                     %Index 11 in Damask
            slip_syst(:,:,12) = [-1  1 -1 ; -1 -1  0];                                     %Index 12 in Damask
        end
        if slip_system(ii) == 8 || slip_system(ii) == 9
            % Mode 2 twins    plane    direction, Define four points in the plane
            slip_syst(:,:,13) = [ 1  1  1 ; -2  1  1];                                     %Index 1 in Damask
            slip_syst(:,:,14) = [ 1  1  1 ;  1 -2  1];                                     %Index 2 in Damask
            slip_syst(:,:,15) = [ 1  1  1 ;  1  1 -2];                                     %Index 3 in Damask
            
            slip_syst(:,:,16) = [-1 -1  1 ;  2 -1  1];                                     %Index 4 in Damask
            slip_syst(:,:,17) = [-1 -1  1 ; -1  2  1];                                     %Index 5 in Damask
            slip_syst(:,:,18) = [-1 -1  1 ; -1 -1 -2];                                     %Index 6 in Damask
            
            slip_syst(:,:,19) = [ 1 -1 -1 ; -2 -1 -1];                                     %Index 7 in Damask
            slip_syst(:,:,20) = [ 1 -1 -1 ;  1  2 -1];                                     %Index 8 in Damask
            slip_syst(:,:,21) = [ 1 -1 -1 ;  1 -1  2];                                     %Index 9 in Damask
            
            slip_syst(:,:,22) = [-1  1 -1 ;  2  1 -1];                                     %Index 10 in Damask
            slip_syst(:,:,23) = [-1  1 -1 ; -1 -2 -1];                                     %Index 11 in Damask
            slip_syst(:,:,24) = [-1  1 -1 ; -1  1  2];                                     %Index 12 in Damask
        end
    end
end

slip_syst_check = zeros(2,3,size(slip_syst,3));
if strcmp(structure,'hcp')
    for ii = 1:size(slip_syst,3)
        slip_syst_check(1,:,ii) = ...
            millerbravaisplane2cart(slip_syst(1,:,ii));
        slip_syst_check(2,:,ii) = ...
            millerbravaisdir2cart(slip_syst(2,:,ii));
    end
else
    slip_syst_check = slip_syst;
end

check_flag = zeros(size(slip_syst,3),1);
for ii = 1:size(slip_syst,3)
    if ~isnan(slip_syst_check(1,:,ii)) & ~isnan(slip_syst_check(2,:,ii))
        check_flag(ii) = check_vectors_orthogonality(...
            slip_syst_check(1,:,ii), slip_syst_check(2,:,ii));
    else
        check_flag(ii) = 1;
    end
end

end