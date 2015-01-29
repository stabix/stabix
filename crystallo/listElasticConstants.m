% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function elast_const = elastic_constants(material, structure, varargin)
%% Function used to give the elastic stiffness constants in 1/GPa
% material : material to give in order to get the corresponding lattice
% parameter and the corresponding c/a ratio
% structure : structure of the given material (hcp, bcc, fcc, dia, tet or bct)
% elast_const: Stiffnesses [S11 S12 S13 S33 S44 S66] in 1/TPa; 

% author: d.mercier@mpie.de

% [LEVY 2001] : "Handbook of elastic properties of solids, liquids and
% gases" by M. Levy, H.E. Bass and R.S. Stern (Vol. 2 - Elastic 
% Properties of Solids: Theory, Elements, and Compounds, Novel Materials,
% Technological Materials, Alloys, Building Materials)
% Chapter 7 / p. 97
% ISBN-13: 978-0124457607  ISBN-10: 0124457606

% Initialization
flag_error = 0;
S11 = 0;
S12 = 0;
S13 = 0;
S33 = 0;
S44 = 0;
S66 = 0;

if nargin == 0
    material = 'Ti';
    structure = 'hcp';
end

if nargin == 1
    warning('Please, give at least 1 material and 1 structure...');
    flag_error = 1;
end

if ~flag_error
    if strcmp(structure,'hcp') == 1
        if strcmp(material,'Be') == 1
            S11 = 3.45; S12 = -0.28; S13 = -0.05; S33 = 2.87; S44 = 6.13; S66 = 7.46;
        elseif strcmp(material,'Cd') == 1
            S11 = 12.19; S12 = -1.32; S13 = -8.76; S33 = 33.76; S44 = 51.02; S66 = 27.03;
        elseif strcmp(material,'Co') == 1                                  % || strcmp(material,'alpha-Co') == 1
            S11 = 4.99; S12 = -2.36; S13 = -0.87; S33 = 3.56; S44 = 14.08; S66 = 14.71;
        elseif strcmp(material,'Dy') == 1                                  % || strcmp(material,'alpha-Dy') == 1
            S11 = 16.03; S12 = -4.59; S13 = -3.17; S33 = 14.48; S44 = 41.15; S66 = 41.24;
        elseif strcmp(material,'Er') == 1                                  % || strcmp(material,'alpha-Er') == 1
            S11 = 14.07; S12 = -4.21; S13 = -2.63; S33 = 13.21; S44 = 36.50; S66 = 36.56;
        elseif strcmp(material,'Gd') == 1                                  % || strcmp(material,'alpha-Gd') == 1
            S11 = 17.99; S12 = -5.70; S13 = -3.57; S33 = 16.12; S44 = 48.08; S66 = 47.39;
        elseif strcmp(material,'Hf') == 1                                  % || strcmp(material,'alpha-Hf') == 1
            S11 = 7.15; S12 = -2.47; S13 = -1.57; S33 = 6.13; S44 = 17.95; S66 = 19.23;
        elseif strcmp(material,'Ho') == 1
            S11 = 15.32; S12 = -4.33; S13 = -2.90; S33 = 14.09; S44 = 38.61; S66 = 39.29;
        elseif strcmp(material,'Lu') == 1                                  % || strcmp(material,'alpha-Lu') == 1
            S11 = 14.28; S12 = -4.17; S13 = -3.50; S33 = 14.79; S44 = 37.31; S66 = 36.90;
        elseif strcmp(material,'Mg') == 1
            S11 = 22.01; S12 = -7.75; S13 = -4.96; S33 = 19.71; S44 = 60.98; S66 = 59.52;
        elseif strcmp(material,'Nd') == 1                                  % || strcmp(material,'alpha-Nd') == 1
            S11 = 23.66; S12 = -9.45; S13 = -3.87; S33 = 18.53; S44 = 66.67; S66 = 66.23;
        elseif strcmp(material,'Pr') == 1                                  % || strcmp(material,'alpha-Pr') == 1
            S11 = 26.60; S12 = -11.28; S13 = -3.82; S33 = 19.32; S44 = 73.53; S66 = 75.76;
        elseif strcmp(material,'Re') == 1
            S11 = 2.11; S12 = -0.80; S13 = -0.39; S33 = 1.70; S44 = 6.21; S66 = 5.83;
        elseif strcmp(material,'Ru') == 1
            S11 = 2.09; S12 = -0.58; S13 = -0.41; S33 = 1.82; S44 = 5.52; S66 = 5.33;
        elseif strcmp(material,'Sc') == 1                                  % || strcmp(material,'alpha-Sc') == 1
            S11 = 12.46; S12 = -4.32; S13 = -2.24; S33 = 10.57; S44 = 36.10; S66 = 33.56;
        elseif strcmp(material,'Tb') == 1                                  % || strcmp(material,'alpha-Tb') == 1
            S11 = 17.45; S12 = -5.17; S13 = -3.60; S33 = 15.55; S44 = 45.87; S66 = 45.25;
        elseif strcmp(material,'Ti') == 1                                  % || strcmp(material,'alpha-Ti') == 1
            S11 = 9.62; S12 = -4.67; S13 = -1.81; S33 = 6.84; S44 = 21.51; S66 = 28.57;
        elseif strcmp(material,'Tl') == 1                                  % || strcmp(material,'alpha-Tl') == 1
            S11 = 105.23; S12 = -83.45; S13 = -11.86; S33 = 31.13; S44 = 138.89; S66 = 377.36;
        elseif strcmp(material,'Y') == 1
            S11 = 15.44; S12 = -5.10; S13 = -2.69; S33 = 14.40; S44 = 41.15; S66 = 41.07;
        elseif strcmp(material,'Zn') == 1
            S11 = 8.07; S12 = 0.61; S13 = -7.02; S33 = 27.55; S44 = 25.25; S66 = 14.94;
        elseif strcmp(material,'Zr') == 1                                  % || strcmp(material,'alpha-Zr') == 1
            S11 = 10.09; S12 = -4.00; S13 = -2.42; S33 = 7.98; S44 = 31.18; S66 = 28.17;
        else
            S11 = 0; S12 = 0; S13 = 0; S33 = 0; S44 = 0; S66 = 0;
        end
        
    elseif strcmp(structure,'bcc') == 1
        if strcmp(material,'Ba') == 1
            S11 = 73.293; S12 = -19.304; S44 = 138.696;
        elseif strcmp(material,'Cr') == 1
            S11 = 3.049; S12 = -0.495; S44 = 6.13;
        elseif strcmp(material,'Cs') == 1
            S11 = 734.788; S12 = -275.313; S44 = 485.437;
        elseif strcmp(material,'Fe') == 1                                  % || strcmp(material,'alpha-Fe') == 1
            S11 = 7.56; S12 = -2.781; S44 = 8.591;
        elseif strcmp(material,'K') == 1
            S11 = 1223.876; S12 = -561.838; S44 = 531.915;
        elseif strcmp(material,'Li') == 1
            S11 = 332.787; S12 = -152.650; S44 = 113.895;
        elseif strcmp(material,'Mo') == 1
            S11 = 2.607; S12 = -0.662; S44 = 9.158;
        elseif strcmp(material,'Na') == 1
            S11 = 586.610; S12 = -268.091; S44 = 238.663;
        elseif strcmp(material,'Nb') == 1
            S11 = 6.495; S12 = -2.23; S44 = 35.436;
        elseif strcmp(material,'Rb') == 1
            S11 = 1557.941; S12 = -714.786; S44 = 609.756;
        elseif strcmp(material,'Ta') == 1
            S11 = 6.889; S12 = -2.556; S44 = 12.114;
        elseif strcmp(material,'V') == 1
            S11 = 6.791; S12 = -2.324; S44 = 23.175;
        elseif strcmp(material,'W') == 1                                   % || strcmp(material,'alpha-W') == 1
            S11 = 2.454; S12 = -0.69; S44 = 6.218;
        else
            S11 = 0; S12 = 0; S44 = 0;
        end
        S13 = S12; S33 = S11; S66 = S44;
        
    elseif strcmp(structure,'fcc') == 1
        if strcmp(material,'Ag') == 1
            S11 = 22.262; S12 = -9.484; S44 = 22.026;
        elseif strcmp(material,'Al') == 1
            S11 = 15.851; S12 = -5.728; S44 = 35.286;
        elseif strcmp(material,'Au') == 1
            S11 = 23.55; S12 = -10.814; S44 = 24.096;
        elseif strcmp(material,'Ca') == 1
            S11 = 74.637; S12 = -29.530; S44 = 61.350;
        elseif strcmp(material,'Ce') == 1                                  % || strcmp(material,'gamma-Ce') == 1
            S11 = 63.085; S12 = -22.385; S44 = 57.803;
        elseif strcmp(material,'Co') == 1                                  % || strcmp(material,'beta-Co') == 1
            S11 = 9.314; S12 = -3.775; S44 = 7.496;
        elseif strcmp(material,'Cu') == 1
            S11 = 14.949; S12 = -6.269; S44 = 13.424;
        elseif strcmp(material,'Fe') == 1                                  % || strcmp(material,'gamma-Fe') == 1
            S11 = 7.039; S12 = -2.717; S44 = 7.337;
        elseif strcmp(material,'Ir') == 1
            S11 = 2.24; S12 = -0.67; S44 = 3.72;
        elseif strcmp(material,'Kr') == 1
            S11 = 373.060; S12 = -134.555; S44 = 384.615;
        elseif strcmp(material,'Ni') == 1
            S11 = 7.751; S12 = -2.979; S44 = 8.052;
        elseif strcmp(material,'Pb') == 1
            S11 = 93.185; S12 = -42.869; S44 = 66.756;
        elseif strcmp(material,'Pd') == 1
            S11 = 13.632; S12 = -5.953; S44 = 13.941;
        elseif strcmp(material,'Pt') == 1
            S11 = 7.337; S12 = -3.079; S44 = 13.072;
        elseif strcmp(material,'Rh') == 1
            S11 = 3.46; S12 = -1.106; S44 = 5.435;
        elseif strcmp(material,'Sr') == 1                                  % || strcmp(material,'alpha-Sr') == 1
            S11 = 148.551; S12 = -59.783; S44 = 174.216;
        else
            S11 = 0; S12 = 0; S44 = 0;
        end
        S13 = S12; S33 = S11; S66 = S44;
        
    elseif strcmp(structure,'dia') == 1
        if strcmp(material,'C') == 1
            S11 = 0.952; S12 = -0.099; S44 = 1.737;
        elseif strcmp(material,'Ge') == 1
            S11 = 9.786; S12 = -2.671; S44 = 14.97;
        elseif strcmp(material,'Si') == 1
            S11 = 7.681; S12 = -2.138; S44 = 12.56;
        else
            S11 = 0; S12 = 0; S44 = 0;
        end
        S13 = S12; S33 = S11; S66 = S44;
        
    elseif strcmp(structure,'tet') == 1
        if strcmp(material,'Sn') == 1                                      % || strcmp(material,'alpha-Sn') == 1
            S11 = 73.293; S12 = -19.304; S44 = 138.696;
        end
        
    elseif strcmp(material,'bct') == 1
        S11 = 0; S12 = 0; S13 = 0; S33 = 0; S44 = 0; S66 = 0;
        
    else
        S11 = 0; S12 = 0; S13 = 0; S33 = 0; S44 = 0; S66 = 0;
        warning('Given material and given structure don''t match...');
    end
    
    elast_const = [S11 S12 S13 S33 S44 S66];                               % in 1/TPa; 
    
end

