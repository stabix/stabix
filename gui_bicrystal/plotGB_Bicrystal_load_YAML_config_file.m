% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_load_YAML_config_file
%% Script to import YAML Bicrystal config. file
% See in http://code.google.com/p/yamlmatlab/
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);
gui.GB_YAML = struct();
gui.GB = struct();

[filename, pathname, filterindex] = uigetfile('*.yaml', 'Get YAML config file');

% Handle canceled file selection
if filename == 0
    filename = '';
end

if isequal(filename, 0) || strcmp(filename, '') == 1
    disp('User selected Cancel');
else
    disp(['User selected', fullfile(filename)]);
    
    gui.GB_YAML = ReadYaml(fullfile(pathname,filename));
    
    %% Fill missing fields
    
    gui.GB.YAML.filename = filename;
    gui.GB_YAML.filenameGF2_BC = 'user_inputs';
    gui.GB_YAML.filenameRB_BC = 'user_inputs';
    gui.GB_YAML.pathnameGF2_BC = pathname;
    gui.GB_YAML.pathnameRB_BC = pathname;
    
    if ~isfield(gui.GB_YAML, 'eulerA')
        gui.GB_YAML.eulerA = [0, 0, 0];
    else
        gui.GB_YAML.eulerA = cell2mat(gui.GB_YAML.eulerA);
    end
    gui.GB_YAML.eulerA_ori = gui.GB_YAML.eulerA;
    
    if ~isfield(gui.GB_YAML, 'eulerB')
        gui.GB_YAML.eulerB = [45, 45, 0];
    else
        gui.GB_YAML.eulerB = cell2mat(gui.GB_YAML.eulerB);
    end
    gui.GB_YAML.eulerB_ori = gui.GB_YAML.eulerB;
    
    if ~isfield(gui.GB_YAML, 'GrainA')
        gui.GB_YAML.GrainA = 1;
    end
    
    if ~isfield(gui.GB_YAML, 'GrainB')
        gui.GB_YAML.GrainB = 2;
    end
    
    if ~isfield(gui.GB_YAML, 'activeGrain')
        gui.GB_YAML.activeGrain = gui.GB_YAML.GrainA;
    end
    
    if ~isfield(gui.GB_YAML, 'Phase_A')
        gui.GB_YAML.Phase_A = 'hcp';
    end
    
    if ~isfield(gui.GB_YAML, 'Phase_B')
        gui.GB_YAML.Phase_B = 'hcp';
    end
    
    if ~isfield(gui.GB_YAML, 'number_phase')
        gui.GB_YAML.number_phase = 1;
    end
    
    if ~isfield(gui.GB_YAML, 'GB_Inclination')
        gui.GB_YAML.GB_Inclination = 90;
    end
    
    if ~isfield(gui.GB_YAML, 'GB_Trace_Angle')
        gui.GB_YAML.GB_Trace_Angle = 0;
    end
    
    if ~isfield(gui.GB_YAML, 'GB_Number')
        gui.GB_YAML.GB_Number = 1;
    end
    
    if ~isfield(gui.GB_YAML, 'Material_A')
        gui.GB_YAML.Material_A = 'Ti';
    end
    
    if ~isfield(gui.GB_YAML, 'ca_ratio_A')
        gui.GB_YAML.ca_ratio_A = latt_param(gui.GB_YAML.Material_A, gui.GB_YAML.Phase_A);
    else
        gui.GB_YAML.ca_ratio_A = cell2mat(gui.GB_YAML.ca_ratio_A);
    end
    
    if isfield(gui.GB_YAML, 'lattice_parameter_A')
        gui.GB_YAML.ca_ratio_A = [1 gui.GB_YAML.lattice_parameter_A gui.GB_YAML.lattice_parameter_A];
    end
    
    if ~isfield(gui.GB_YAML, 'Material_B')
        gui.GB_YAML.Material_B = 'Ti';
    end
    
    if ~isfield(gui.GB_YAML, 'ca_ratio_B')
        gui.GB_YAML.ca_ratio_B = latt_param(gui.GB_YAML.Material_B, gui.GB_YAML.Phase_B);
    else
        gui.GB_YAML.ca_ratio_B = cell2mat(gui.GB_YAML.ca_ratio_B);
    end
    
    if isfield(gui.GB_YAML, 'lattice_parameter_B')
        gui.GB_YAML.ca_ratio_B = [1 gui.GB_YAML.lattice_parameter_B gui.GB_YAML.lattice_parameter_B];
    end
    
    %% Set specific slips for grains A and B
    if isfield(gui.GB_YAML, 'SlipA_norm') && isfield(gui.GB_YAML, 'SlipA_dir')
        % Get the normal plane and direction of slip A from the GUI
        gui.GB_YAML.GB_YAML_slipA_unstrcat_num_norm = cell2mat(gui.GB_YAML.SlipA_norm);
        gui.GB_YAML.GB_YAML_slipA_unstrcat_num_dir = cell2mat(gui.GB_YAML.SlipA_dir);
    end
    
    if isfield(gui.GB_YAML, 'SlipB_norm') && isfield(gui.GB_YAML, 'SlipB_dir')
        % Get the normal plane and direction of slip B from the GUI
        gui.GB_YAML.GB_YAML_slipB_unstrcat_num_norm = cell2mat(gui.GB_YAML.SlipB_norm);
        gui.GB_YAML.GB_YAML_slipB_unstrcat_num_dir = cell2mat(gui.GB_YAML.SlipB_dir);
    end
    
    if ~isfield(gui.GB_YAML, 'SlipA_norm') || ~isfield(gui.GB_YAML, 'SlipA_dir')
        if strcmp (gui.GB_YAML.Phase_A, 'hcp') == 1
            gui.GB_YAML.GB_YAML_slipA_unstrcat_num_norm = [0, 0, 0, 1];
            gui.GB_YAML.GB_YAML_slipA_unstrcat_num_dir  = [2 -1 -1 0];
        elseif strcmp(gui.GB_YAML.Phase_A, 'bcc') == 1
            gui.GB_YAML.GB_YAML_slipA_unstrcat_num_norm = [0,  1,  1];
            gui.GB_YAML.GB_YAML_slipA_unstrcat_num_dir  = [1, -1,  1];
        elseif strcmp(gui.GB_YAML.Phase_A, 'fcc') == 1
            gui.GB_YAML.GB_YAML_slipA_unstrcat_num_norm = [1,  1,  1];
            gui.GB_YAML.GB_YAML_slipA_unstrcat_num_dir  = [0,  1, -1];
        end
    end
    
    if ~isfield(gui.GB_YAML, 'SlipB_norm') || ~isfield(gui.GB_YAML, 'SlipB_dir')
        if strcmp (gui.GB_YAML.Phase_B, 'hcp') == 1
            gui.GB_YAML.GB_YAML_slipB_unstrcat_num_norm = [0, 0, 0, 1];
            gui.GB_YAML.GB_YAML_slipB_unstrcat_num_dir  = [2 -1 -1 0];
        elseif strcmp(gui.GB_YAML.Phase_B, 'bcc') == 1
            gui.GB_YAML.GB_YAML_slipB_unstrcat_num_norm = [0,  1,  1];
            gui.GB_YAML.GB_YAML_slipB_unstrcat_num_dir  = [1, -1,  1];
        elseif strcmp(gui.GB_YAML.Phase_B, 'fcc') == 1
            gui.GB_YAML.GB_YAML_slipB_unstrcat_num_norm = [1,  1,  1];
            gui.GB_YAML.GB_YAML_slipB_unstrcat_num_dir  = [0,  1, -1];
        end
    end
    
    set(gui.handles.getSlipA, 'String', strcat('(',num2str(gui.GB_YAML.GB_YAML_slipA_unstrcat_num_norm),') / [',num2str(gui.GB_YAML.GB_YAML_slipA_unstrcat_num_dir), ']'));
    set(gui.handles.getSlipB, 'String', strcat('(',num2str(gui.GB_YAML.GB_YAML_slipB_unstrcat_num_norm),') / [',num2str(gui.GB_YAML.GB_YAML_slipB_unstrcat_num_dir), ']'));
    clear slipA_all_vect slipB_all_vect;
    slipA_all_vect = slip_systems(gui.GB_YAML.Phase_A, 9);
    slipB_all_vect = slip_systems(gui.GB_YAML.Phase_B, 9);
    
    clear slipA_user_spec slipB_user_spec slipA_inv slipB_inv
    specific_slips_AB = plotGB_Bicrystal_slip_user_def(slipA_all_vect, slipB_all_vect);
    if specific_slips_AB(1) == 0
        commandwindow;
        warning('Wrong inputs for slip system in grain A !');
        beep;
    end
    if specific_slips_AB(2) == 0
        commandwindow;
        warning('Wrong inputs for slip system in grain A !');
        beep;
    end
    
    gui.GB.slipA_user_spec = abs(specific_slips_AB(1));
    gui.GB.slipB_user_spec = abs(specific_slips_AB(2));
    gui.GB.slipA = gui.GB.slipA_user_spec;
    gui.GB.slipB = gui.GB.slipB_user_spec;
    
    %% Setting of GB's properties
    Names = fieldnames(gui.GB_YAML);
    for fn = 1:length(Names)
        gui.GB.(Names{fn}) = gui.GB_YAML.(Names{fn});
    end
    guidata(gcf, gui);
    
    %% Setting of grains Euler angles when only misorientation and mis. axis are given
    if isfield(gui.GB, 'Misorientation_angle') && isfield(gui.GB, 'Misorientation_axis')
        gui.GB.Misorientation_axis = cell2mat(gui.GB.Misorientation_axis);
        if strcmp(gui.GB.Phase_A, 'hcp') == 1
            gui.GB.Misorientation_axis = millerbravaisdir2cart(gui.GB.Misorientation_axis, gui.GB.ca_ratio_A(1));
        end
        gui.GB.eulerA = [0 0 0];
        gui.GB.eulerA_ori = gui.GB.eulerA;
        
        gui.GB.rot_mat = axisang2g(gui.GB.Misorientation_axis, gui.GB.Misorientation_angle);
        
        gui.GB.eulerB = g2eulers(gui.GB.rot_mat);
        gui.GB.eulerB_ori = gui.GB.eulerB;
    end
    
    %% Set GUI
    guidata(gcf, gui);
    plotGB_Bicrystal_setpopupmenu;
    gui = guidata(gcf); guidata(gcf, gui);
    
    set(gui.handles.pmchoicecase, 'Value', size(get(gui.handles.pmchoicecase, 'String'), 1));
    set(gui.handles.getEulangGrA, 'String', sprintf('%.3f  %.2f  %.1f', gui.GB.eulerA));
    set(gui.handles.getEulangGrB, 'String', sprintf('%.3f  %.2f  %.1f', gui.GB.eulerB));
    set(gui.handles.getGBinclination, 'String', gui.GB.GB_Inclination);
    set(gui.handles.getGBtrace,'String', gui.GB.GB_Trace_Angle);
    guidata(gcf, gui);
    
    %% Refresh the bicrystal interface
    guidata(gcf, gui);
    plotGB_Bicrystal;
    gui = guidata(gcf); guidata(gcf, gui);
    
end
