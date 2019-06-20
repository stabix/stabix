% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function compliances = stiffness_to_compliance(material, structure, varargin)
%% Function used to give the elastic stiffness constants in 1/GPa
% material : material to give in order to get the corresponding lattice
% structure : structure of the given material (hcp, bcc, fcc, dia, tet or bct)
% elast_const: [S11 S12 S13 S33 S44 S66] in 1/TPa;
% compliances: [C11 C12 C13 C33 C44 C66] in TPa;

% author: d.mercier@mpie.de

% From J.F. Nye, "Physical properties of crystals - Their representation by
% tensors and matrices." (1985) Oxford Univ. Presse (p. 147)
% ISBN-13: 978-0198511656  ISBN-10: 0198511655

if nargin < 2
    material = 'Ti';
    structure = 'hcp';
end

elast_const = listElasticConstants(material, structure);

S11 = elast_const(1);
S12 = elast_const(2);
S13 = elast_const(3);
S33 = elast_const(4);
S44 = elast_const(5);
S66 = elast_const(6);

if strcmp(structure, 'bcc') || strcmp(structure, 'fcc') %All classes
    C11 = (S11 + S12)/((S11 - S12)*(S11 + 2*S12));
    C12 = -S12/((S11 - S12)*(S11 + 2*S12));
    C44 = 1/S44;
    C13 = C12; C33 = C11; C66 = C44;
    
elseif strcmp(structure, 'hcp') %All classes
    s = S33*(S11+S12)-2*(S13)^2;
    
    C11 = 0.5*((S33/s)+(1/(S11-S12)));
    C12 = 0.5*((S33/s)-(1/(S11-S12)));
    C13 = -S13/s;
    C33 = (S11 + S12)/s;
    C44 = 1/S44;
    C66 = (S11 - S12)/2;
    
elseif strcmp(structure, 'bct') || strcmp(structure, 'fct') %Classes 4mm, 42m, 422, 4/mmm
    s = S33*(S11+S12)-2*(S13)^2;
    
    C11 = 0.5*((S33/s)+(1/(S11-S12)));
    C12 = 0.5*((S33/s)-(1/(S11-S12)));
    C13 = -S13/s;
    C33 = (S11 + S12)/s;
    C44 = 1/S44;
    C66 = 1/S66;
    
elseif strcmp(structure, 'tri') %Classes 3m, 32, 3m
    
end

compliances = [C11 C12 C13 C33 C44 C66]; % in TPa;

end