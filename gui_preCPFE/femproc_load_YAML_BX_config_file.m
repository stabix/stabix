% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: femproc_load_YAML_BX_config_file.m 1230 2014-08-14 11:37:09Z d.mercier $
function femproc_load_YAML_BX_config_file(YAML_GB_config_file_2_import, interface, varargin)
%% Function to import YAML Bicrystal config. file
% YAML_GB_config_file_2_import : Name of YAML GB config. to import
% interface: type of interface (1 for SX or 2 for BX meshing interface)
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if YAML_GB_config_file_2_import == 0
    YAML_GB_config_file_2_import = uigetfile('*.yaml', 'Get YAML config. file');
    
    % Handle canceled file selection
    if YAML_GB_config_file_2_import == 0
        YAML_GB_config_file_2_import = '';
    end
    
    if isequal(YAML_GB_config_file_2_import, 0) || strcmp(YAML_GB_config_file_2_import, '') == 1
        disp('User selected Cancel');
        if interface == 1
            YAML_GB_config_file_2_import = sprintf('config_gui_SX_example.yaml');
        elseif interface == 2
            YAML_GB_config_file_2_import = sprintf('config_gui_BX_example.yaml');
        end
    else
        disp(['User selected :', fullfile(YAML_GB_config_file_2_import)]);
    end
    
end

%% Loading YAML file
GB_YAML = ReadYaml(YAML_GB_config_file_2_import);

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
    if strcmp(GB_YAML.Phase_A, GB_YAML.Phase_A) == 1
        GB_YAML.number_phase = 1;
    else
        GB_YAML.number_phase = 2;
    end
end

if ~isfield(GB_YAML, 'GB_Inclination')
    GB_YAML.GB_Inclination = randi(40,1) + 70; % 70-110° or round(rand(1)*100)+1 between 0 and 100°
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
else
    GB_YAML.ca_ratio_A = cell2mat(GB_YAML.ca_ratio_A);
end

if ~isfield(GB_YAML, 'Material_B')
    GB_YAML.Material_B = 'Ti';
end

if ~isfield(GB_YAML, 'ca_ratio_B')
    GB_YAML.ca_ratio_B = latt_param(GB_YAML.Material_B, GB_YAML.Phase_B);
else
    GB_YAML.ca_ratio_B = cell2mat(GB_YAML.ca_ratio_B);
end

%% Setting of grains Euler angles when only misorientation and mis. axis are given
if isfield(GB_YAML, 'Misorientation_angle') && isfield(GB_YAML, 'Misorientation_axis')
    GB_YAML.Misorientation_axis = cell2mat(GB_YAML.Misorientation_axis);
    GB_YAML.eulerA = [0 0 0];
    GB_YAML.eulerA_ori = GB_YAML.eulerA;
    GB_YAML.Misorientation_vect = [1 1 1 1; GB_YAML.Misorientation_axis];
    GB_YAML.Misorientation_vect_cs = slip_vectors_normalization(GB_YAML. Phase_B, GB_YAML.ca_ratio_B, GB_YAML.Misorientation_vect);
    GB_YAML.rot_mat = axisang2g(GB_YAML.Misorientation_vect_cs(2,:), GB_YAML.Misorientation_angle);
    %GB.Misorientation_vect = millerbravaisdir2cart(GB.Misorientation_axis, GB.ca_ratio_B(1));
    %GB.rot_mat = axisang2g(GB.Misorientation_vect, GB.Misorientation_angle);
    GB_YAML.eulerB = g2eulers(GB_YAML.rot_mat);
    GB_YAML.eulerB_ori = GB_YAML.eulerB;
end

if interface == 1
    gui_SX = gui;
    gui_SX.GB = GB_YAML;
    guidata(gcf, gui_SX);
elseif interface == 2
    gui_BX = gui;
    gui_BX.GB = GB_YAML;
    guidata(gcf, gui_BX);
end

end