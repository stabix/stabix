% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: plotGB_Bicrystal_slip_user_def.m 1201 2014-08-05 12:39:38Z d.mercier $
function specific_slips_AB = plotGB_Bicrystal_slip_user_def(slipA_all_vect, slipB_all_vect)
%% Script to get specific slips given by user
% handle_getSlipA : handle of the txt box where Miller (Miller-Bravais for hcp) indices of slip for grain A are given
% handle_getSlipB : handle of the txt box where Miller (Miller-Bravais for hcp) indices of slip for grain B are given
% slipA_all_vect : all slips with Miller indices of normal and direction vectors given for grain A
% slipB_all_vect : all slips with Miller indices of normal and direction vectors given for grain B

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

%% Get indices of vectors from txt box for slips of GrainA and GrainB
if isempty(get(gui.handles.getSlipA, 'String'))
    set(gui.handles.getSlipA, 'String', strcat('(',num2str(slipA_all_vect(1, :, 1)),') / [',num2str(slipA_all_vect(2, :, 1)), ']'));
end

if isempty(get(gui.handles.getSlipB, 'String'))
    set(gui.handles.getSlipB, 'String', strcat('(',num2str(slipB_all_vect(1, :, 1)),') / [',num2str(slipB_all_vect(2, :, 1)), ']'));
end

specific_slipA_strcat  = get(gui.handles.getSlipA, 'String');
specific_slipB_strcat  = get(gui.handles.getSlipB, 'String');

specific_slipA_unstrcat = strsplit(specific_slipA_strcat, {'(', '[', ']', ')'}); %specific_slipA_unstrcat(2) & specific_slipA_unstrcat(4)
specific_slipB_unstrcat = strsplit(specific_slipB_strcat, {'(', '[', ']', ')'}); %specific_slipB_unstrcat(2) & specific_slipB_unstrcat(4)

%% Get the normale directions of slips A and B from the GUI
% specific_slipA_unstrcat_num_norm = cell2mat(specific_slipA_unstrcat(2));
% specific_slipB_unstrcat_num_norm = cell2mat(specific_slipB_unstrcat(2));
% 
% specific_slipA_unstrcat_str_norm = num2str(specific_slipA_unstrcat_num_norm);
% specific_slipB_unstrcat_str_norm = num2str(specific_slipB_unstrcat_num_norm);
% 
% specific_slipA_unstrcat_str_norm(ismember(specific_slipA_unstrcat_str_norm,' ')) = [];
% specific_slipB_unstrcat_str_norm(ismember(specific_slipB_unstrcat_str_norm,' ')) = [];

%% Get the slip directions of slips A and B from the GUI
specific_slipA_unstrcat_num_dir = cell2mat(specific_slipA_unstrcat(4));
specific_slipB_unstrcat_num_dir = cell2mat(specific_slipB_unstrcat(4));

specific_slipA_unstrcat_str_dir = num2str(specific_slipA_unstrcat_num_dir);
specific_slipB_unstrcat_str_dir = num2str(specific_slipB_unstrcat_num_dir);

specific_slipA_unstrcat_str_dir(ismember(specific_slipA_unstrcat_str_dir,' ')) = [];
specific_slipB_unstrcat_str_dir(ismember(specific_slipB_unstrcat_str_dir,' ')) = [];

%% Definition of slips A and B
specific_slip_A = get_slip_indices(specific_slipA_unstrcat_str_dir, slipA_all_vect, 2);

specific_slip_B = get_slip_indices(specific_slipB_unstrcat_str_dir, slipA_all_vect, 2);

specific_slips_AB = [specific_slip_A, specific_slip_B];

guidata(gcf, gui);

end
