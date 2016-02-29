% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function GB = load_YAML_BX_example_config_file(GB_YAML_filename)
%% Script to import YAML file and load data for mesh generation
% GB_YAML_filename: Name of the YAML file containing GB data...
% See in http://code.google.com/p/yamlmatlab/
% author : d.mercier@mpie.de

GB_YAML = ReadYaml(GB_YAML_filename);

%% Fill missing fields
if ~isfield(GB_YAML, 'filenameGF2_BC')
    GB_YAML.filenameGF2_BC = 'user_inputs';
end

if ~isfield(GB_YAML, 'filenameGF2_BC')
    GB_YAML.filenameRB_BC = 'user_inputs';
end

if ~isfield(GB_YAML, 'pathnameGF2_BC')
    GB_YAML.pathnameRB_BC = pwd;
end

if ~isfield(GB_YAML, 'pathnameGF2_BC')
    GB_YAML.pathnameRB_BC = pwd;
end

if ~isfield(GB_YAML, 'pathnameGF2_BC')
    GB_YAML.pathnameRB_BC = pwd;
end

if ~isfield(GB_YAML, 'eulerA')
    GB_YAML.eulerA = [0, 0, 0];
else
    GB_YAML.eulerA = cell2mat(GB_YAML.eulerA);
end
GB_YAML.eulerA_ori = GB_YAML.eulerA;

if ~isfield(GB_YAML, 'eulerB')
    GB_YAML.eulerB = [45, 45, 0];
else
    GB_YAML.eulerB = cell2mat(GB_YAML.eulerB);
end
GB_YAML.eulerB_ori = GB_YAML.eulerB;

if ~isfield(GB_YAML, 'GrainA')
    GB_YAML.GrainA = 1;
end

if ~isfield(GB_YAML, 'GrainB')
    GB_YAML.GrainB = 2;
end

if ~isfield(GB_YAML, 'activeGrain')
    GB_YAML.activeGrain = GB_YAML.GrainA;
end

if ~isfield(GB_YAML, 'Phase_A')
    GB_YAML.Phase_A = 'hcp';
end

if ~isfield(GB_YAML, 'Phase_B')
    GB_YAML.Phase_B = 'hcp';
end

if ~isfield(GB_YAML, 'number_phase')
    GB_YAML.number_phase = 1;
end

if ~isfield(GB_YAML, 'GB_Inclination')
    GB_YAML.GB_Inclination = 90;
end

if ~isfield(GB_YAML, 'GB_Trace_Angle')
    GB_YAML.GB_Trace_Angle = 0;
end

if ~isfield(GB_YAML, 'GB_Number')
    GB_YAML.GB_Number = 1;
end

if ~isfield(GB_YAML, 'Material_A')
    GB_YAML.Material_A = 'Ti';
end

if ~isfield(GB_YAML, 'ca_ratio_A')
    GB_YAML.ca_ratio_A = latt_param(GB_YAML.Material_A, GB_YAML.Phase_A);
end

if ~isfield(GB_YAML, 'Material_B')
    GB_YAML.Material_B = 'Ti';
end

if ~isfield(GB_YAML, 'ca_ratio_B')
    GB_YAML.ca_ratio_B = latt_param(GB_YAML.Material_B, GB_YAML.Phase_B);
end

%% Set specific slips for grains A and B
if (~isfield(GB_YAML, 'SlipA_norm') && ~isfield(GB_YAML, 'SlipA_dir')) ...
        && (~isfield(GB_YAML, 'SlipB_norm') ...
        && ~isfield(GB_YAML, 'SlipB_dir'))
    GB_YAML.SlipA_norm = {[0], [0], [0], [1]};
    GB_YAML.SlipA_dir  = {[2], [-1], [-1], [0]};
    GB_YAML.SlipB_norm = {[0], [0], [0], [1]};
    GB_YAML.SlipB_dir  = {[2], [-1], [-1], [0]};
end

% Get the normal plane of slips A and B from the GUI
GB_YAML.slipA_str_norm = num2str(cell2mat(GB_YAML.SlipA_norm));
GB_YAML.slipA_str_norm(ismember(GB_YAML.slipA_str_norm,' ')) = [];
GB_YAML.slipB_str_norm = num2str(cell2mat(GB_YAML.SlipB_norm));
GB_YAML.slipB_str_norm(ismember(GB_YAML.slipB_str_norm,' ')) = [];
% Get the slip directions of slips A and B from the GUI
GB_YAML.slipA_str_dir = num2str(cell2mat(GB_YAML.SlipA_dir));
GB_YAML.slipA_str_dir(ismember(GB_YAML.slipA_str_dir,' ')) = [];
GB_YAML.slipB_str_dir = num2str(cell2mat(GB_YAML.SlipB_dir));
GB_YAML.slipB_str_dir(ismember(GB_YAML.slipB_str_dir,' ')) = [];


slipA_all_vect = slip_systems(GB_YAML.Phase_A, 9);
slipB_all_vect = slip_systems(GB_YAML.Phase_B, 9);
specific_slips_A = ...
    get_slip_indices(GB_YAML.slipA_str_norm, GB_YAML.slipA_str_dir, ...
    slipA_all_vect, 2);
specific_slips_B = ...
    get_slip_indices(GB_YAML.slipB_str_norm, GB_YAML.slipB_str_dir, ...
    slipB_all_vect, 2);

specific_slips_AB = [specific_slips_A, specific_slips_B];

GB_YAML.slipA = specific_slips_AB(1);
GB_YAML.slipB = specific_slips_AB(2);

% if GB_YAML.slipA = 0

if GB_YAML.slipA < 0
    GB_YAML.slipA_ind = -(slipA_all_vect(:, :, abs(GB_YAML.slipA)));
end

if GB_YAML.slipA > 0
    GB_YAML.slipA_ind = slipA_all_vect(:, :, GB_YAML.slipA);
end

if GB_YAML.slipB < 0
    GB_YAML.slipB_ind = -(slipB_all_vect(:, :, abs(GB_YAML.slipB)));
end

if GB_YAML.slipB > 0
    GB_YAML.slipB_ind = slipB_all_vect(:, :, GB_YAML.slipB);
end

%% Setting of GB's properties
Names = fieldnames(GB_YAML);
for fn = 1:length(Names)
    GB.(Names{fn}) = GB_YAML.(Names{fn});
end
clear Names;

end