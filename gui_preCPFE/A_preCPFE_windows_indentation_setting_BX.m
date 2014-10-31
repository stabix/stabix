% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_handle = A_preCPFE_windows_indentation_setting_BX(gui_bicrystal, varargin)
%% Setting of indentation inputs (tip radius, indentation depth...) + setting of the mesh for a
% bicrystal indentation experiment.
% gui_bicrystal: Handle of the Bicrystal GUI

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
gui_BX = preCPFE_init;

x0 = 0.025;
hu = 0.05; % height unit
wu = 0.1; % width unit

%% Window setting
gui_BX.handles.gui_BX_win = figure(...
    'NumberTitle', 'off',...
    'Position', figure_position([.58, .30, .9, 1]), ... %[left, bottom, width, height/width],...
    'ToolBar', 'figure');
guidata(gcf, gui_BX);

gui_BX.description = 'Indentation of a bicrystal - ';

%% Set Matlab and CPFEM configurations
if nargin == 0
    %[gui_BX.config] = load_YAML_config_file;
    
    gui_BX.config_map.Sample_IDs   = [];
    gui_BX.config_map.Sample_ID    = [];
    gui_BX.config_map.Material_IDs = [];
    gui_BX.config_map.Material_ID  = [];
    gui_BX.config_map.default_grain_file_type2 = 'random_GF2data.txt';
    gui_BX.config_map.default_reconstructed_boundaries_file = 'random_RBdata.txt';
    gui_BX.config_map.imported_YAML_GB_config_file = 'config_gui_BX_defaults.yaml';
    
    guidata(gcf, gui_BX);
    preCPFE_load_YAML_BX_config_file(gui_BX.config_map.imported_YAML_GB_config_file, 2);
    gui_BX = guidata(gcf); guidata(gcf, gui_BX);
    gui_BX.GB.active_data = 'BX';
    gui_BX.GB.activeGrain = gui_BX.GB.GrainA;
    gui_BX.title_str = set_gui_title(gui_BX, '');
else
    gui_BX.flag           = gui_bicrystal.flag;
    gui_BX.config_map     = gui_bicrystal.config_map;
    gui_BX.config         = gui_bicrystal.config;
    gui_BX.GB             = gui_bicrystal.GB;
    gui_BX.GB.active_data = 'BX';
    gui_BX.title_str = set_gui_title(gui_BX, ['Bicrystal n°', num2str(gui_BX.GB.GB_Number)]);
end
gui_BX.config.username = get_username;
guidata(gcf, gui_BX);

%% Customized menu
gui_BX.custom_menu = preCPFE_custom_menu([gui_BX.module_name,'-BX']);
preCPFE_custom_menu_BX(gui_BX.custom_menu);

%% Plot the mesh axis
gui_BX.handles.hax = axes('Units', 'normalized',...
    'position', [0.5 0.05 0.45 0.9],...
    'Visible', 'off');

%% Initialization of variables
gui_BX.defaults.variables = ReadYaml('config_mesh_BX_defaults.yaml');
if nargin > 0
    gui_BX.defaults.variables.inclination = gui_BX.GB.GB_Inclination;
end

%% Creation of string boxes and edit boxes to set indenter and indentation properties
gui_BX.handles.mesh = preCPFE_mesh_parameters_BX(gui_BX.defaults, x0, hu, wu);

%% Pop-up menu to select Python executable
gui_BX.handles.pm_Python = preCPFE_python_popup([2*x0 hu*2.6 wu*3 hu]);

%% Creation of popup menu and slider for loaded AFM indenter topography
gui_BX.handles.indenter_topo = preCPFE_buttons_AFM_indenter_topo(x0, hu, wu);
    
%% Creation of buttons/popup menus... (mesh quality, layout, Python, CPFEM...)
gui_BX.handles.other_setting = preCPFE_buttons_gui(x0, hu, wu);

%% Set GUI handle encapsulation
guidata(gcf, gui_BX);
gui_BX.config.CPFEM.python_executable = preCPFE_python_select;
guidata(gcf, gui_BX);

%% Run the plot of the meshing
gui_BX.indenter_type = 'conical'; guidata(gcf, gui_BX);
preCPFE_indentation_setting_BX;
view(-65,20);
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

gui_handle = gui_BX.handles.gui_BX_win;

end