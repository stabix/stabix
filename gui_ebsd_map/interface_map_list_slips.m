% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: interface_map_list_slips.m 1203 2014-08-05 13:07:41Z d.mercier $
function interface_map_list_slips(pmStruct1, pmStruct2, pmlistslips1, pmlistslips2, number_phase, slip_family_1, slip_family_2, varargin)
%% Function used to define the list of slips and twins systems used for mprime calculation
% Definition of slip and twin systems in function of the number of phases
% pmStruct1 and pmStruct1 : Handles of popup-menu where phases of material are given
% pmlistslips1 and pmlistslips2 : Handles of popup-menu where list of slip
% families are selected bu user for calculations...
% number_phase : Number of phase of the material
% slip_family_1 and slip_family_2 : Indice of slip families to set in the
% popup menus...

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if number_phase == 1
    list_struct1 = get(pmStruct1, 'String');
    num_struct1  = get(pmStruct1, 'Value');
    struct1      = list_struct1(num_struct1, :);
    struct1      = num2str(struct1);
    
    set(pmlistslips1, 'String', slip_systems_names(struct1), 'Value', slip_family_1);
    
elseif number_phase == 2
    list_struct1 = get(pmStruct1, 'String');
    num_struct1  = get(pmStruct1, 'Value');
    struct1      = list_struct1(num_struct1, :);
    struct1      = num2str(struct1);
    
    list_struct2 = get(pmStruct2, 'String');
    num_struct2  = get(pmStruct2, 'Value');
    struct2      = list_struct2(num_struct2, :);
    struct2      = num2str(struct2);
    
    set(pmlistslips1, 'String', slip_systems_names(struct1), 'Value', slip_family_1);
    set(pmlistslips2, 'String', slip_systems_names(struct2), 'Value', slip_family_2);
    
end

end