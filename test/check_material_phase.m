% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [lattice_parameters, flag_error] = ...
    check_material_phase(material, phase, varargin)
%% Check match between a given material and a given phase

% author: d.mercier@mpie.de

if nargin < 2
    phaseList = listPhase;
    phase = phaseList(randi(length(phaseList)));
    disp(phase);
end
   
if nargin < 1
    materialList = listMaterial;
    material = materialList(randi(length(materialList)));
    disp(material);
end

% Get the lattice parameter for the grain
lattice_parameters = listLattParam(material, phase);
if lattice_parameters(1) == 0
    warning_commwin('Wrong input for material and structure !!!');
    flag_error = 1;
else
    flag_error = 0;
end

end