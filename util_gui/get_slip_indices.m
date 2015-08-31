% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function specific_slip = ...
    get_slip_indices(specific_slip_unstrcat_str, ...
    slip_all_vect, norm_or_dir, varargin)
%% Script to check validity of slip system given by user in a YAML file
% specific_slip_unstrcat_str: Slip system given as a concatenated string
% slip_all_vect : all slips systems for a given phase
% norm_or_dir: Flag to set the given vector as a direction or a normal to the slip plane

if nargin < 2
    norm_or_dir = 2;
    specific_slip_unstrcat_str = '2-1-10';
    slip_all_vect = slip_systems('hcp', 9);
end

for ii = 1:1:size(slip_all_vect, 3)
    slip_all_vect_str = num2str(slip_all_vect(norm_or_dir,:,ii));
    slip_all_vect_str(ismember(slip_all_vect_str,' ')) = [];
    slip_all_vect_str(norm_or_dir,:,ii) = slip_all_vect_str;
    
    specific_slip = 1;
    flag_match = 0;
    
    if strcmp(specific_slip_unstrcat_str, ...
            slip_all_vect_str(norm_or_dir,:,ii)) == 1
        specific_slip = ii;
        flag_match = 1;
        break;
    end
    
end

for ii = 1:1:size(slip_all_vect, 3) & flag_match == 0
    slip_all_vect_str = num2str(-slip_all_vect(norm_or_dir,:,ii));
    slip_all_vect_str(ismember(slip_all_vect_str,' ')) = [];
    slip_all_vect_str(norm_or_dir,:,ii) = slip_all_vect_str;
    
    if strcmp(specific_slip_unstrcat_str, ...
            slip_all_vect_str(norm_or_dir,:,ii)) == 1
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