% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_handle = ...
    A_preCPFE_windows_indentation_setting_BX(gui_bicrystal, ...
    scratchTest, activeGrain, varargin)
%% Setting of indentation inputs (tip radius, indentation depth...)
% and setting of the mesh for a bicrystal indentation experiment.

% gui_bicrystal: handle of the Bicrystal GUI
% scratchTest: boolean variable (0 for indentation test and 1 for scratch test)
% activeGrain: grain where to do/to start indentation/scratch test

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 3
    activeGrain = 0;
end

if nargin < 2
    scratchTest = 0;
end

%% Initialization
gui_BX = preCPFE_init;
if ~scratchTest
    gui_BX.description = 'Indentation of a bicrystal - ';
else
    if ~activeGrain
        gui_BX.description = 'Scratch test of a bicrystal - ';
    else
        gui_BX.description = 'Scratch test of a single crystal - ';
    end
end

x0 = 0.025;
hu = 0.05; % height unit
wu = 0.1; % width unit

%% Window setting
gui_BX.handles.gui_BX_win = figure(...
    'NumberTitle', 'off',...
    'Color', [0.9 0.9 0.9],...
    'Position', figure_position([.58, .30, .9, 1]), ... %[left, bottom, width, height/width],...
    'ToolBar', 'figure');
guidata(gcf, gui_BX);

%% Set Matlab and CPFEM configurations
if nargin == 0 || isempty(gui_bicrystal)
    gui_BX.config_map.Sample_IDs   = [];
    gui_BX.config_map.Sample_ID    = [];
    gui_BX.config_map.Material_IDs = [];
    gui_BX.config_map.Material_ID  = [];
    gui_BX.config_map.default_grain_file_type2 = 'random_GF2data.txt';
    gui_BX.config_map.default_reconstructed_boundaries_file = ...
        'random_RBdata.txt';
    if exist(sprintf('config_gui_BX_%s.yaml', gui_BX.config.username))
        gui_BX.config_map.imported_YAML_GB_config_file = ...
            sprintf('config_gui_BX_%s.yaml', gui_BX.config.username);
    else
        gui_BX.config_map.imported_YAML_GB_config_file = ...
            'config_gui_BX_defaults.yaml';
    end
    guidata(gcf, gui_BX);
    preCPFE_load_YAML_BX_config_file(...
        gui_BX.config_map.imported_YAML_GB_config_file, 2);
    gui_BX = guidata(gcf); guidata(gcf, gui_BX);
    if ~activeGrain
        gui_BX.GB.active_data = 'BX';
    else
        gui_BX.GB.active_data = 'SX';
        gui_BX.GB.activeGrain = gui_BX.GB.GrainA;
        gui_BX.GB = set_BX2SX(gui_BX, gui_BX.GB.activeGrain);
    end
    gui_BX.title_str = set_gui_title(gui_BX, '');
else
    gui_BX.flag           = gui_bicrystal.flag;
    gui_BX.config_map     = gui_bicrystal.config_map;
    gui_BX.GB             = gui_bicrystal.GB;
    
    if activeGrain == 1
        gui_BX.GB.active_data = 'SX';
        gui_BX.GB.activeGrain = gui_BX.GB.GrainA;
        gui_BX.GB = set_BX2SX(gui_BX, gui_BX.GB.activeGrain);
    elseif activeGrain == 2
        gui_BX.GB.active_data = 'SX';
        gui_BX.GB.activeGrain = gui_BX.GB.GrainB;
        gui_BX.GB = set_BX2SX(gui_BX, gui_BX.GB.activeGrain);
    else
        gui_BX.GB.active_data = 'BX';
    end
    gui_BX.title_str = set_gui_title(gui_BX, ...
        ['Bicrystal n°', num2str(gui_BX.GB.GB_Number)]);
    guidata(gcf, gui_BX);
    
    YAMLfile_title = strcat('config_gui_BX_number_', ...
        num2str(gui_bicrystal.GB.GB_Number), '.yaml');
    
    preCPFE_write_YAML_BX_config_file(gui_BX.GB.pathnameGF2_BC, ...
        YAMLfile_title);
    
    gui_BX.config_map.imported_YAML_GB_config_file = YAMLfile_title;
end
gui_BX.config.username = username_get;
guidata(gcf, gui_BX);

%% Customized menu
gui_BX.custom_menu = preCPFE_custom_menu([gui_BX.module_name,'-BX']);
preCPFE_custom_menu_BX(gui_BX.custom_menu);

%% Plot the mesh axis
gui_BX.handles.hax = axes('Units', 'normalized',...
    'position', [0.5 0.05 0.45 0.7],...
    'Visible', 'off');

%% Initialization of variables
gui_BX.defaults.variables = ReadYaml('config_mesh_BX_defaults.yaml');
gui_BX.defaults.variables.inclination = gui_BX.GB.GB_Inclination;
if scratchTest == 0
    gui_BX.defaults.variables.scratchTest = 0;
else
    gui_BX.defaults.variables.scratchTest = 1;
    if activeGrain
        gui_BX.defaults.variables.inclination = 90;
        gui_BX.GB.GB_Trace_Angle = 0;
        gui_BX.GB.GB_Inclination = 90;
    end
end
guidata(gcf, gui_BX);

%% Creation of boxes to set indenter and indentation properties
gui_BX.handles.mesh = preCPFE_mesh_parameters_BX(gui_BX.defaults, ...
    2*x0, hu, wu, gui_BX.config.CPFEM.fem_solver_used);

%% Pop-up menu to select Python executable
gui_BX.handles.pm_Python = preCPFE_python_popup([2*x0 hu*2.6 wu*3 hu]);

%% Creation of popup menu and slider for loaded AFM indenter topography
[gui_BX.handles.indenter, indent_parameters] = ...
    preCPFE_buttons_indenter(x0, hu, wu, scratchTest);
gui_BX.defaults.variables.coneAngle = indent_parameters.coneAngle;
gui_BX.defaults.variables.tipRadius = indent_parameters.tipRadius;
gui_BX.defaults.variables.h_indent = indent_parameters.h_indent;
gui_BX.defaults.variables.coneAngle = indent_parameters.coneAngle;
if scratchTest
    gui_BX.defaults.variables.scratchLength = indent_parameters.scratchLength;
    gui_BX.defaults.variables.scratchDirection = indent_parameters.scratchDirection;
end

%% Creation of buttons/popup menus (mesh quality, layout, Python, CPFEM...)
gui_BX.handles.other_setting = preCPFE_buttons_gui(x0, hu, wu);
guidata(gcf, gui_BX);
preCPFE_mesh_level(0);
gui_BX = guidata(gcf);
guidata(gcf, gui_BX);

%% Set Python executable
[gui_BX.config.CPFEM.python_executable, gui_BX.config.CPFEM.python] = ...
    preCPFE_python_select(gui_BX.handles.pm_Python);
guidata(gcf, gui_BX);

%% Run the plot of the meshing
gui_BX.indenter_type = 'conical';
guidata(gcf, gui_BX);

preCPFE_set_CPFEM_solver;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

preCPFE_indentation_setting_BX;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

gui_handle = gui_BX.handles.gui_BX_win;

%% Set logo of the GUI
java_icon_gui(gui_handle);

end