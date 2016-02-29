% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function specific_slip = ...
    get_slip_indices(specific_Nslip_unstrcat_str, specific_Dslip_unstrcat_str, ...
    slip_all_vect, norm_or_dir, varargin)
%% Script to check validity of slip system given by user in a YAML file
% specific_slip_unstrcat_str: Slip system given as a concatenated string
% slip_all_vect : all slips systems for a given phase
% norm_or_dir: Flag to set the given vector as a direction or a normal to the slip plane

if nargin < 2
    norm_or_dir = 2;
    specific_Nslip_unstrcat_str = '0001';
    specific_Dslip_unstrcat_str = '2-1-10';
    slip_all_vect = slip_systems('hcp', 9);
end

if norm_or_dir == 2
    check_norm_or_dir = 1;
else
    check_norm_or_dir = 2;
end

for ii = 1:1:size(slip_all_vect, 3)
    slip_all_vect_str_dir = num2str(slip_all_vect(norm_or_dir,:,ii));
    slip_all_vect_str_dir(ismember(slip_all_vect_str_dir,' ')) = [];
    slip_all_vect_str_dir(norm_or_dir,:,ii) = slip_all_vect_str_dir;
    slip_all_vect_str_norm = num2str(slip_all_vect(check_norm_or_dir,:,ii));
    slip_all_vect_str_norm(ismember(slip_all_vect_str_norm,' ')) = [];
    slip_all_vect_str_norm(check_norm_or_dir,:,ii) = slip_all_vect_str_norm;
    slip_all_vect_str_norm_neg = num2str(-slip_all_vect(check_norm_or_dir,:,ii));
    slip_all_vect_str_norm_neg(ismember(slip_all_vect_str_norm_neg,' ')) = [];
    slip_all_vect_str_norm_neg(check_norm_or_dir,:,ii) = slip_all_vect_str_norm_neg;
    
    specific_slip = 1;
    flag_match = 0;
    
    if strcmp(specific_Dslip_unstrcat_str, ...
            slip_all_vect_str_dir(norm_or_dir,:,ii)) == 1 && ...
            strcmp(specific_Nslip_unstrcat_str, ...
            slip_all_vect_str_norm(check_norm_or_dir,:,ii)) == 1
        specific_slip = ii;
        flag_match = 1;
        break;
    elseif strcmp(specific_Dslip_unstrcat_str, ...
            slip_all_vect_str_dir(norm_or_dir,:,ii)) == 1 && ...
            strcmp(specific_Nslip_unstrcat_str, ...
            slip_all_vect_str_norm_neg(check_norm_or_dir,:,ii)) == 1
        specific_slip = ii;
        flag_match = 1;
        break;
    end
    
end

for ii = 1:1:size(slip_all_vect, 3) & flag_match == 0
    slip_all_vect_str_dir = num2str(-slip_all_vect(norm_or_dir,:,ii));
    slip_all_vect_str_dir(ismember(slip_all_vect_str_dir,' ')) = [];
    slip_all_vect_str_dir(norm_or_dir,:,ii) = slip_all_vect_str_dir;
    slip_all_vect_str_norm = num2str(slip_all_vect(check_norm_or_dir,:,ii));
    slip_all_vect_str_norm(ismember(slip_all_vect_str_norm,' ')) = [];
    slip_all_vect_str_norm(check_norm_or_dir,:,ii) = slip_all_vect_str_norm;
    slip_all_vect_str_norm_neg = num2str(-slip_all_vect(check_norm_or_dir,:,ii));
    slip_all_vect_str_norm_neg(ismember(slip_all_vect_str_norm_neg,' ')) = [];
    slip_all_vect_str_norm_neg(check_norm_or_dir,:,ii) = slip_all_vect_str_norm_neg;
    
    if strcmp(specific_Dslip_unstrcat_str, ...
            slip_all_vect_str_dir(norm_or_dir,:,ii)) == 1 && ...
            strcmp(specific_Nslip_unstrcat_str, ...
            slip_all_vect_str_norm(check_norm_or_dir,:,ii)) == 1
        specific_slip = -ii;
        flag_match = 1;
        break;
    elseif strcmp(specific_Dslip_unstrcat_str, ...
            slip_all_vect_str_dir(norm_or_dir,:,ii)) == 1 && ...
            strcmp(specific_Nslip_unstrcat_str, ...
            slip_all_vect_str_norm_neg(check_norm_or_dir,:,ii)) == 1
        specific_slip = -ii;
        flag_match = 1;
        break;
    end
    
end

if ~flag_match
    display(['No matching between slip system given ' ...
        'by user and slip systems in the database !']);
end

end