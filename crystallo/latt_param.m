% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function lattice_parameters = latt_param(material, structure, varargin)
%% Function used to give the lattice parameter in Angstrom and to calculate
% the c/a ratio for a given material
% material : material to give in order to get the corresponding lattice
% parameter and the corresponding c/a ratio
% structure : structure of the given material (hcp, bcc, fcc, dia, tet or bct)
% author: d.mercier@mpie.de

% [DAVEY 1925] DOI ==> 10.1103/PhysRev.25.753
% [SPEDDING 1956] DOI ==> 10.1107/S0365110X5600156X
% [RAYNE 1960] : DOI ==> 10.1103/PhysRev.120.1658
% [ASHCROFT 1976] : Ashcroft and Mermin - "Solid State Physics"
% [YOO 1981] : DOI ==> 10.1007/BF02648537
% [LANDOLT-BORNSTEIN 2002] : DOI ==> 10.1007/10832182_543
% [BATTAINI 2008] : PhD thesis of Battaini M. -
% "Deformation behaviour and twinning mechanisms of commercially pure titanium alloys"
% [SEAL 2012] : http://dx.doi.org/10.1016/j.msea.2012.04.114

% Initialization
flag_error = 0;
c = 0;
a = 1;

if nargin == 0
    material = 'Ti';
    structure = 'hcp';
end

if nargin == 1
    warning_commwin('Please, give at least 1 material and 1 structure...');
    flag_error = 1;
end

if ~flag_error
    if strcmp(structure,'hcp') == 1
        if strcmp(material,'Be') == 1
            c = 3.58; a = 2.29;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Cd') == 1
            c = 5.62; a = 2.98;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Co') == 1                                  % || strcmp(material,'alpha-Co') == 1
            c = 4.07; a = 2.51;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Dy') == 1                                  % || strcmp(material,'alpha-Dy') == 1
            c = 5.65; a = 3.59;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Er') == 1                                  % || strcmp(material,'alpha-Er') == 1
            c = 5.59; a = 3.56;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Gd') == 1                                  % || strcmp(material,'alpha-Gd') == 1
            c = 5.78; a = 3.64;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Hf') == 1                                  % || strcmp(material,'alpha-Hf') == 1
            c = 5.06; a = 3.20;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Ho') == 1
            c = 5.62; a = 3.58;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'La') == 1
            c = 12.159; a = 3.770;                                         % from [SPEDDING 1956]
        elseif strcmp(material,'Lu') == 1                                  % || strcmp(material,'alpha-Lu') == 1
            c = 5.55; a = 3.50;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Mg') == 1
            c = 5.21; a = 3.21;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Nd') == 1                                  % || strcmp(material,'alpha-Nd') == 1
            c = 5.90; a = 3.66;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Pr') == 1                                  % || strcmp(material,'alpha-Pr') == 1
            c = 5.92; a = 3.67;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Re') == 1
            c = 4.46; a = 2.76;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Ru') == 1
            c = 4.28; a = 2.70;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Sc') == 1                                  % || strcmp(material,'alpha-Sc') == 1
            c = 5.27; a = 3.31;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Tb') == 1                                  % || strcmp(material,'alpha-Tb') == 1
            c = 5.69; a = 3.60;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Ti') == 1                                  % || strcmp(material,'alpha-Ti') == 1
            c = 4.683; a = 2.950;                                          % from [BATTAINI 2008] - NB: [ASHCROFT 1976] c = 4.69 ; a = 2.95;  NB:[YOO 1981] c/a(Ti)= 1.588
        elseif strcmp(material,'Tl') == 1                                  % || strcmp(material,'alpha-Tl') == 1
            c = 5.53; a = 3.46;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Tm') == 1
            c = 5.5546; a = 3.5375;                                        % from [SPEDDING 1956]
        elseif strcmp(material,'Y') == 1
            c = 5.73; a = 3.65;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Zn') == 1
            c = 4.95; a = 2.66;                                            % from [ASHCROFT 1976]
        elseif strcmp(material,'Zr') == 1                                  % || strcmp(material,'alpha-Zr') == 1
            c = 5.15; a = 3.23;                                            % from [ASHCROFT 1976]
        else
            c = 0; a = 1;
        end
        
    elseif strcmp(structure,'bcc') == 1
        if strcmp(material,'Ba') == 1
            a = 5.02; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Cr') == 1
            a = 2.88; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Cs') == 1
            a = 6.05; c = a;                                               % from [ASHCROFT 1976] @ 78K
        elseif strcmp(material,'Eu') == 1
            a = 4.606; c = a;                                              % from [SPEDDING 1956]
        elseif strcmp(material,'Fe') == 1                                  % || strcmp(material,'alpha-Fe') == 1
            a = 2.87; c = a;                                               % from [ASHCROFT 1976] (alpha-Ferrite)
        elseif strcmp(material,'K') == 1
            a = 5.23; c = a;                                               % from [ASHCROFT 1976] @ 5K
        elseif strcmp(material,'Li') == 1
            a = 3.49; c = a;                                               % from [ASHCROFT 1976] @ 78K
        elseif strcmp(material,'Mo') == 1
            a = 3.15; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Na') == 1
            a = 4.23; c = a;                                               % from [ASHCROFT 1976] @ 5K
        elseif strcmp(material,'Nb') == 1
            a = 3.30; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Rb') == 1
            a = 5.59; c = a;                                               % from [ASHCROFT 1976] @ 5K
        elseif strcmp(material,'Ta') == 1
            a = 3.31; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Ti') == 1
            a = 3.27; c = a;                                               % from [SEAL 2012]
        elseif strcmp(material,'V') == 1
            a = 3.02; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'W') == 1                                   % || strcmp(material,'alpha-W') == 1
            a = 3.16; c = a;                                               % from [ASHCROFT 1976]
        else
            a = 1; c = 0;
        end
        
    elseif strcmp(structure,'fcc') == 1
        if strcmp(material,'Ag') == 1
            a = 4.09; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Al') == 1
            a = 4.05; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Au') == 1
            a = 4.08; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Ca') == 1
            a = 5.58; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Ce') == 1                                  % || strcmp(material,'gamma-Ce') == 1
            a = 5.16; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Co') == 1                                  % || strcmp(material,'beta-Co') == 1
            a = 3.55; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Cu') == 1
            a = 3.61; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Fe') == 1                                  % || strcmp(material,'gamma-Fe') == 1
            a = 2.87; c = a;                                               % (gamma-Ferrite=austenite) To VERIFY !!!
        elseif strcmp(material,'Ir') == 1
            a = 3.84; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Kr') == 1
            a = 5.72; c = a;                                               % from [ASHCROFT 1976] @ 58K
        elseif strcmp(material,'Ni') == 1
            a = 3.52; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Pb') == 1
            a = 4.95; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Pd') == 1
            a = 3.89; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Pt') == 1
            a = 3.92; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Rh') == 1
            a = 3.80; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Sr') == 1                                  % || strcmp(material,'alpha-Sr') == 1
            a = 6.08; c = a;                                               % from [ASHCROFT 1976]
        elseif strcmp(material,'Yb') == 1
            a = 5.4862; c = a;                                             % from [SPEDDING 1956]
        else
            a = 1; c = 0;
        end
        
    elseif strcmp(structure,'dia') == 1
        if strcmp(material,'C') == 1
            a = 3.57;                                                      % from [ASHCROFT 1976]
        elseif strcmp(material,'Ge') == 1
            a = 5.66;                                                      % from [ASHCROFT 1976]
        elseif strcmp(material,'Si') == 1
            a = 5.43;                                                      % from [ASHCROFT 1976]
        elseif strcmp(material,'Sn') == 1                                  % || strcmp(material,'alpha-Sn') == 1
            a = 6.49;                                                      % from [ASHCROFT 1976]
        else
            a = 1;
        end
        c = a;
        
    elseif strcmp(structure,'tet') == 1
        if strcmp(material,'Sn') == 1                                      % || strcmp(material,'alpha-Sn') == 1
            c = 3.1815; a = 5.8316;                                        % from [LANDOLT-BORNSTEIN 2002] or [RAYNE 1960]
        end
        
    elseif strcmp(material,'bct') == 1
        c = 0; a = 1;
        
    elseif strcmp(material,'tri') == 1
        if strcmp(material,'Bi') == 1
            c = 3.1815; a = 5.8316;                                        % from [DAVEY 1925]
        end
        
    else
        c = 0; a = 1;
        warning_commwin(...
            'Given material and given structure don''t match...', 1);
    end
    
    lattice_parameters = [c/a c a];
    
end