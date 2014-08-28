% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_handle = A_femproc_windows_indentation_setting_SX(gui_bicrystal, activeGrain, varargin)
%% Setting of indentation inputs (tip radius, indentation depth...) + setting of the mesh for a
% single crystal indentation experiment.
% gui_bicrystal: handle of the Bicrystal GUI
%activeGrain: Number of the active grain in the Bicrystal

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Window Coordinates Configuration
scrsize = screenSize;   % Get screen size
WX = 0.4 * scrsize(3); % X Position (bottom)
WY = 0.20 * scrsize(4);  % Y Position (left)
WW = 0.60 * scrsize(3);  % Width
WH = 1.4 * WW;  % Height

%% Window setting
gui_SX.handles.gui_SX_win = figure(...
    'NumberTitle', 'off',...
    'Position', [WX WY WW WH],...
    'ToolBar', 'figure');

%% Set Matlab and CPFEM configurations
if nargin == 0  
    [gui_SX.config_Matlab] = load_YAML_config_file;
    
    gui_SX.config_map.Sample_IDs   = [];
    gui_SX.config_map.Sample_ID    = [];
    gui_SX.config_map.Material_IDs = [];
    gui_SX.config_map.Material_ID  = [];
    gui_SX.config_map.default_grain_file_type2 = 'random_GF2data.txt';
    gui_SX.config_map.default_reconstructed_boundaries_file = 'random_RBdata.txt';
    gui_SX.config_map.imported_YAML_GB_config_file = 'config_gui_BX_example.yaml';
    
    guidata(gcf, gui_SX);
    femproc_load_YAML_BX_config_file(gui_SX.config_map.imported_YAML_GB_config_file, 1);
    gui_SX = guidata(gcf); guidata(gcf, gui_SX);
    gui_SX.GB.active_data = 'SX';
    gui_SX.handles.gui_SX_title = strcat('Setting of indentation for random single crystal', ' - version 1.0');
    
else
    gui_SX.flag           = gui_bicrystal.flag;
    gui_SX.config_map     = gui_bicrystal.config_map;
    gui_SX.config_Matlab  = gui_bicrystal.config_Matlab;
    gui_SX.GB             = gui_bicrystal.GB;
    gui_SX.GB.active_data = 'SX';
    if activeGrain == 1
        gui_SX.GB.activeGrain     = gui_SX.GB.GrainA;
    elseif activeGrain == 2
        gui_SX.GB.activeGrain     = gui_SX.GB.GrainB;
    end
    gui_SX.handles.gui_SX_title = strcat('Setting of indentation for single crystal n°', num2str(gui_SX.GB.activeGrain), ' - version 1.0');
end
guidata(gcf, gui_SX);

set(gui_SX.handles.gui_SX_win, 'Name', gui_SX.handles.gui_SX_title);

%% Set path for documentation and initialization
format compact;

if ismac || isunix
    gui_SX.config_map.path_picture_SXind = '../doc/_pictures/Schemes_SlipTransmission/SX_indentation_mesh_example.png/';
else
    gui_SX.config_map.path_picture_SXind = '..\doc\_pictures\Schemes_SlipTransmission\SX_indentation_mesh_example.png';
end

gui_SX.config_map.imported_YAML_GB_config_file = 'config_gui_SX_example.yaml';

%% Customized menu
femproc_custom_menu_SX;

%% Plot the mesh axis
gui_SX.handles.hax = axes('Units', 'normalized',...
    'position', [0.5 0.05 0.49 0.9],...
    'Visible', 'off');

%% Initialization of variables
gui_SX.variables.coneAngle_init       = 90; % Angle of cono-spherical indenter (in °)
gui_SX.variables.tipRadius_init       = 1; % Radius of cono-spherical indenter (in µm)
gui_SX.variables.h_indent_init        = 0.3; % Depth of indentation (in µm)
gui_SX.variables.r_center_frac_init   = 0.25;
gui_SX.variables.box_xfrac_init       = 0.3;
gui_SX.variables.box_zfrac_init       = 0.3;
gui_SX.variables.D_sample_init        = 8;
gui_SX.variables.h_sample_init        = 4;
gui_SX.variables.sample_rep_init      = 24;
gui_SX.variables.box_elm_nx_init      = 5;
gui_SX.variables.box_elm_nz_init      = 5;
gui_SX.variables.radial_divi_init     = 5;
gui_SX.variables.box_bias_x_init      = 0.1;
gui_SX.variables.box_bias_z_init      = 0.2;
gui_SX.variables.box_bias_conv_x_init = 0.4;

%% Creation of string boxes and edit boxes to set indenter and indentation properties
[gui_SX.handles.coneAngle_str, gui_SX.handles.coneAngle_val]         = femproc_set_inputs_boxes({'Full Angle of conical indenter (°)'}, [0.025 0.935 0.28 0.025],gui_SX.variables.coneAngle_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.tipRadius_str, gui_SX.handles.tipRadius_val]         = femproc_set_inputs_boxes({'Tip radius of indenter (µm)'}, [0.025 0.905 0.28 0.025],gui_SX.variables.tipRadius_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.h_indent_str,  gui_SX.handles.h_indent_val]           = femproc_set_inputs_boxes({'Indentation depth (µm)'}, [0.025 0.875 0.28 0.025],gui_SX.variables.h_indent_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.r_center_frac_str, gui_SX.handles.r_center_frac_val] = femproc_set_inputs_boxes({'r_center_frac'}, [0.025 0.845 0.28 0.025],gui_SX.variables.r_center_frac_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_xfrac_str, gui_SX.handles.box_xfrac_val]         = femproc_set_inputs_boxes({'box_xfrac'}, [0.025 0.815 0.28 0.025],gui_SX.variables.box_xfrac_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_zfrac_str, gui_SX.handles.box_zfrac_val]         = femproc_set_inputs_boxes({'box_zfrac'}, [0.025 0.785 0.28 0.025],gui_SX.variables.box_zfrac_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.D_sample_str, gui_SX.handles.D_sample_val]           = femproc_set_inputs_boxes({'D_sample (µm)'}, [0.025 0.755 0.28 0.025],gui_SX.variables.D_sample_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.h_sample_str, gui_SX.handles.h_sample_val]           = femproc_set_inputs_boxes({'h_sample (µm)'}, [0.025 0.725 0.28 0.025],gui_SX.variables.h_sample_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.sample_rep_str, gui_SX.handles.sample_rep_val]       = femproc_set_inputs_boxes({'sample_rep (8,16,24,32,48)'}, [0.025 0.695 0.28 0.025],gui_SX.variables.sample_rep_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_elm_nx_str, gui_SX.handles.box_elm_nx_val]       = femproc_set_inputs_boxes({'box_elm_nx'}, [0.025 0.665 0.28 0.025],gui_SX.variables.box_elm_nx_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_elm_nz_str, gui_SX.handles.box_elm_nz_val]       = femproc_set_inputs_boxes({'box_elm_nz'}, [0.025 0.635 0.28 0.025],gui_SX.variables.box_elm_nz_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.radial_divi_str, gui_SX.handles.radial_divi_val]     = femproc_set_inputs_boxes({'radial_divi'}, [0.025 0.605 0.28 0.025],gui_SX.variables.radial_divi_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_bias_x_str, gui_SX.handles.box_bias_x_val]       = femproc_set_inputs_boxes({'box_bias_x (-0.5 to 0.5)'}, [0.025 0.575 0.28 0.025],gui_SX.variables.box_bias_x_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_bias_z_str, gui_SX.handles.box_bias_z_val]       = femproc_set_inputs_boxes({'box_bias_z (-0.5 to 0.5)'}, [0.025 0.545 0.28 0.025],gui_SX.variables.box_bias_z_init, 'femproc_indentation_setting_SX');
[gui_SX.handles.box_bias_conv_x_str, gui_SX.handles.box_bias_conv_x_val] = femproc_set_inputs_boxes({'box_bias_conv_x (-0.5 to 0.5)'}, [0.025 0.515 0.28 0.025],gui_SX.variables.box_bias_conv_x_init, 'femproc_indentation_setting_SX');

%% Pop-up menu to set the mesh quality
gui_SX.handles.pm_mesh_quality = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [0.025 0.44 0.18 0.05],...
    'Style', 'popup',...
    'String', {'Free mesh'; 'Coarse mesh'; 'Fine mesh'; 'Very fine mesh'; 'Ultra fine mesh'},...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Value', 3,...
    'Callback', 'femproc_indentation_setting_SX');

%% Pop-up menu to set FEM software
gui_SX.handles.pm_FEM_interface = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [0.21 0.44 0.2 0.05],...
    'Style', 'popup',...
    'String', {'Mentat_2008'; 'Mentat_2010'; 'Mentat_2012'; 'Mentat_2013'; 'Mentat_2013.1'},...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center');

%% Button to give picture of the mesh with names of dimensions use to describe the sample and the mesh
gui_SX.handles.pb_mesh_example = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units','normalized',...
    'Position', [0.1 0.38 0.18 0.05],...
    'Style', 'pushbutton',...
    'String', 'Mesh example',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'gui_SX = guidata(gcf); open_file_web(gui_SX.config_map.path_picture_SXind);');

%% Creation of string boxes and edit boxes for the calculation of the number of elements
gui_SX.handles.num_elem = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [0.05 0.32 0.28 0.04],...
    'Style', 'text',...
    'String', '',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold',...
    'FontSize', 14);

%% Creation of string boxes and edit boxes for the calculation of the number of elements
gui_SX.handles.trans_depth = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [0.05 0.25 0.28 0.04],...
    'Style', 'text',...
    'String', '',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'FontWeight', 'bold');

%% Button to validate the mesh and for the creation of procedure and material files
gui_SX.handles.pb_CPFEM_model = uicontrol('Parent', gui_SX.handles.gui_SX_win,...
    'Units', 'normalized',...
    'Position', [0.05 0.16 0.28 0.05],...
    'Style', 'pushbutton',...
    'String', 'CPFE  model',...
    'BackgroundColor', [0.2 0.8 0],...
    'FontWeight', 'bold',...
    'FontSize', 10,...
    'HorizontalAlignment', 'center',...
    'Callback', 'femproc_indentation_setting_SX');

%% Set the GUI with a YAML file
guidata(gcf, gui_SX);
config_CPFEM_YAML_file = sprintf('config_CPFEM_%s.yaml', gui_SX.config_Matlab.username);
femproc_load_YAML_CPFEM_config_file(config_CPFEM_YAML_file, 1);
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

if isfield(gui_SX.config_CPFEM, 'fem_software')
    femproc_set_cpfem_interface_pm(gui_SX.handles.pm_FEM_interface, gui_SX.config_CPFEM.fem_software);
else
    femproc_set_cpfem_interface_pm(gui_SX.handles.pm_FEM_interface);
end

%% Set GUI handle encapsulation
guidata(gcf, gui_SX);

%% Run the plot of the meshing
femproc_indentation_setting_SX;
gui_SX = guidata(gcf); guidata(gcf, gui_SX);

gui_handle = gui_SX.handles.gui_SX_win;

end
