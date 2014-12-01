% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_handle = A_gui_plotGB_Bicrystal(gui_map, gui_cpfe, varargin)
%% Function to create the bicrystal interface
% gui_map: handle of the gui of EBSD map

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
if isempty(getenv('SLIP_TRANSFER_TBX_ROOT')) == 1
    errordlg('Run the path_management.m script !', 'File Error');
    return
end

%% Set GUI
gui = plotGB_Bicrystal_init;

%% Check if MTEX is installed
if ishandle(1)
    gui_main = guidata(1);
    if isfield(gui_main, 'flag')
        if isfield(gui_main.flag, 'installation_mtex')
            if gui_main.flag.installation_mtex == 1
                gui_main_flag = 1;
                gui.flag.installation_mtex = 1;
            else
                gui_main_flag = 0;
            end
        else
            gui_main_flag = 0;
        end
    else
        gui_main_flag = 0;
    end
else
    gui_main_flag = 0;
end

if ~gui_main_flag
    gui.flag.installation_mtex = MTEX_check_install;
end

%% Window Coordinates Configuration
scrsize = screenSize;   % Get screen size
WX = 0.17 * scrsize(3); % X Position (bottom)
WY = 0.10 * scrsize(4); % Y Position (left)
WW = 0.40 * scrsize(3); % Width
WH = 0.80 * scrsize(4); % Height

%% Plot axis setting
gui.handles.Bicrystal_interface = figure('NumberTitle', 'off',...
    'Color', [0.9 0.9 0.9],...
    'toolBar', 'figure',...
    'Position', [WX WY WW WH]);

gui.title_str = set_gui_title(gui, '');

%% Setting of Euler angles
str_euler = '==> Euler Angles (Bunge - Phi1,PHI2,Phi3) (°)';

[gui.handles.txtEulAngGrA, gui.handles.getEulangGrA] = ...
    set_inputs_boxes(['Gr.A ', str_euler], ...
    [0.1 0.97 0.85 0.02], '', 'plotGB_Bicrystal', 0.6);

[gui.handles.txtEulAngGrB, gui.handles.getEulangGrB] = ...
    set_inputs_boxes(['Gr.B ', str_euler], ...
    [0.1 0.95 0.85 0.02], '', 'plotGB_Bicrystal', 0.6);

%% Set of plot (value of m' + type of plot)
gui.handles.pmchoiceplot = uicontrol(...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.04 0.84 0.17 0.1],...
    'String', {'Plot unit cell' ; 'Plot circle' ; ...
    'Plot unit cell + circle' ; 'Plot Burgers vectors'},...
    'Callback', 'plotGB_Bicrystal');

gui.handles.pmchoicecase = uicontrol(...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.22 0.84 0.17 0.1],...
    'String', {'1st m'' Max' ; '2nd m'' Max' ; '3rd m'' Max' ; ...
    '1st m'' Min' ; '2nd m'' Min' ; '3rd m'' Min' ; 'm'' (highest GSF)' ; ...
    '1st RBV Max' ; '2nd RBV Max' ; '3rd RBV Max' ; ...
    '1st RBV Min' ; '2nd RBV Min' ; '3rd RBV Min' ; 'RBV (highest GSF)' ;
    '1st N-factor Max' ; '2nd N-factor Max' ; '3rd N-factor Max' ; ...
    '1st N-factor Min' ; '2nd N-factor Min' ; '3rd N-factor Min' ; ...
    'N-factor (highest GSF)' ;
    '1st LRB Max' ; '2nd LRB Max' ; '3rd LRB Max' ; ...
    '1st LRB Min' ; '2nd LRB Min' ; '3rd LRB Min' ; 'LRB (highest GSF)' ; ...
    'GB Schmid Factor' ; 'Manual / Imported inputs'},...
    'Callback', 'plotGB_Bicrystal');

%% Setting of GB inclination
[gui.handles.txtGBinclination, gui.handles.getGBinclination] = ...
    set_inputs_boxes('GB Inclination (°)', [0.04 0.88 0.32 0.025], ...
    '', 'plotGB_Bicrystal', 0.75);

%% Setting of GB trace
[gui.handles.txtGBtrace, gui.handles.getGBtrace] = ...
    set_inputs_boxes('GB Trace Ang. (°)', [0.04 0.85 0.32 0.025], ...
    '', 'plotGB_Bicrystal', 0.75);

%% Indices of slip in grain A and slip in grain B (normal and direction)
[gui.handles.txtSlipA, gui.handles.getSlipA] = ...
    set_inputs_boxes('Slip_A', [0.04 0.77 0.32 0.025], ...
    '', 'plotGB_Bicrystal', 0.2);
[gui.handles.txtSlipB, gui.handles.getSlipB] =  ...
    set_inputs_boxes('Slip_B', [0.04 0.74 0.32 0.025], ...
    '', 'plotGB_Bicrystal', 0.2);

%% Setting of Grains A and B (material, structure, slip systems...)
h = uibuttongroup('visible','on', 'Position',[0.4 0.74 0.35 0.2]);

[gui.handles.MatA, gui.handles.pmMatA, gui.handles.StructA,  ...
    gui.handles.pmStructA, gui.handles.listslipsA,  ...
    gui.handles.pmlistslipsA] = interface_map_material('#A', ...
    [0.025 0.88 0.45 0.1], 'plotGB_Bicrystal_window_list_slips',  ...
    'plotGB_Bicrystal', h);

[gui.handles.MatB, gui.handles.pmMatB, gui.handles.StructB,  ...
    gui.handles.pmStructB, gui.handles.listslipsB,  ...
    gui.handles.pmlistslipsB] = interface_map_material('#B', ...
    [0.525 0.88 0.45 0.1], 'plotGB_Bicrystal_window_list_slips',  ...
    'plotGB_Bicrystal', h);

%% Legend of a bicrystal (colors used for slips plotted inside unit cells for each grain)
gui.handles.cblegend = set_checkbox('Legend', ...
    [0.76 0.92 0.2 0.02], 0, 'plotGB_Bicrystal');

gui.handles.pmlegend_location = uicontrol( ...
    'Units', 'normalized',...
    'Style', 'popup',...
    'Position', [0.76 0.90 0.2 0.02],...
    'String', listLocation,...
    'Visible', 'off',...
    'Value', 1,...
    'Callback', 'plotGB_Bicrystal');

%% Plot of the slip traces
gui.handles.cbsliptraces = set_checkbox('Plot of slip traces', ...
    [0.76 0.87 0.2 0.02], 1, 'plotGB_Bicrystal');

%% Creation of menus and menu items on figure window
guidata(gcf, gui);
gui.handles.menuBX = plotGB_Bicrystal_custom_menu;
guidata(gcf, gui);

%% IPF plot
gui.handles.pbIPFplotAB = set_pushbutton('IPF Gr.A and Gr. B', ...
    [0.04 0.805 0.16 0.04], ['gui = guidata(gcf);', ...
    'if gui.flag.installation_mtex == 1;', ...
    'MTEX_plotIPF([gui.GB.orientation_grA; gui.GB.orientation_grB]);', ...
    'else warning_commwin(''MTEX not installed!'');', ...
    'end']);

%% Stress Tensor
gui.handles.StressTensorStr = uicontrol( ...
    'Units', 'normalized',...
    'HorizontalAlignment', 'center',...
    'Style', 'text',...
    'Position', [0.8 0.81 0.12 0.02],...
    'String', 'Stress tensor :');

gui.handles.stress_tensor = set_stress_tensor( ...
    0.8, 0.79, 0.03, 0.02, 'plotGB_Bicrystal');

if nargin == 1
    set(gui.handles.stress_tensor.ST_s11, ...
        'String', num2str(gui_map.stress_tensor.sigma(1,1)));
    set(gui.handles.stress_tensor.ST_s12, ...
        'String', num2str(gui_map.stress_tensor.sigma(1,2)));
    set(gui.handles.stress_tensor.ST_s13, ...
        'String', num2str(gui_map.stress_tensor.sigma(1,3)));
    set(gui.handles.stress_tensor.ST_s21, ...
        'String', num2str(gui_map.stress_tensor.sigma(2,1)));
    set(gui.handles.stress_tensor.ST_s22, ...
        'String', num2str(gui_map.stress_tensor.sigma(2,2)));
    set(gui.handles.stress_tensor.ST_s23, ...
        'String', num2str(gui_map.stress_tensor.sigma(2,3)));
    set(gui.handles.stress_tensor.ST_s31, ...
        'String', num2str(gui_map.stress_tensor.sigma(3,1)));
    set(gui.handles.stress_tensor.ST_s32, ...
        'String', num2str(gui_map.stress_tensor.sigma(3,2)));
    set(gui.handles.stress_tensor.ST_s33, ...
        'String', num2str(gui_map.stress_tensor.sigma(3,3)));
end

%% Save picture of the bicrystal
gui.handles.pbsavefigure = set_pushbutton('SAVE FIGURE', ...
    [0.76 0.835 0.2 0.03], ['gui = guidata(gcf); save_figure;' ...
    'set(gui.handles.Bicrystal_interface, ''Color'', [1 1 1]*.9);']);

%% Plot mprime and residual Burgers vector maps for all slip families
gui.handles.cb_all_values_map = set_pushbutton('All values', ...
    [0.03 0.02 0.12 0.03], ['gui = guidata(gcf);' ...
    'plotGB_Bicrystal_all_param_map_plot(gui.GB.param2plot, ' ...
    '[''All '', gui.GB.param2plot_title,'' values / GB_#'','...
    'num2str(gui.GB.GB_Number)]);']);

%% Plot
gui.handles.h_gbax = subplot(4, 2, [3 6]);
guidata(gcf, gui);

%% Set GUI if random bicrystal or bicrystal from EBSD map
if nargin < 1
    guidata(gcf, gui);
    plotGB_Bicrystal_random_bicrystal;
    gui = guidata(gcf);
    
elseif nargin == 1
    gui.GB.YAMLfilename    = 0;
    gui.GB.active_GB       = ...
        str2double(get(gui_map.handles.numGB2plot, 'string'));
    gui.GB.filenameGF2_BC  = gui_map.config_map.filename_grain_file_type2;
    gui.GB.filenameRB_BC   = ...
        gui_map.config_map.filename_reconstructed_boundaries_file;
    gui.GB.pathnameGF2_BC  = gui_map.config_map.pathname_grain_file_type2;
    gui.GB.pathnameRB_BC   = ...
        gui_map.config_map.pathname_reconstructed_boundaries_file;
    gui.GB.GrainA          = gui_map.GBs(gui.GB.active_GB).grainA;
    gui.GB.GrainB          = gui_map.GBs(gui.GB.active_GB).grainB;
    gui.GB.eulerA          = gui_map.grains(gui.GB.GrainA).eulers;
    gui.GB.eulerB          = gui_map.grains(gui.GB.GrainB).eulers;
    gui.GB.eulerA_ori      = gui_map.grains(gui.GB.GrainA).eulers;
    gui.GB.eulerB_ori      = gui_map.grains(gui.GB.GrainB).eulers;
    gui.GB.Phase_A         = gui_map.grains(gui.GB.GrainA).structure;
    gui.GB.Phase_B         = gui_map.grains(gui.GB.GrainB).structure;
    gui.GB.number_phase    = gui_map.grains(gui.GB.GrainA).phase_num;
    gui.GB.GB_Inclination  = 90;
    gui.GB.GB_Trace_Angle  = gui_map.GBs(gui.GB.active_GB).trace_angle;
    gui.GB.GB_Number       = gui_map.GBs(gui.GB.active_GB).ID;
    gui.GB.Material_A      = gui_map.grains(gui.GB.GrainA).material;
    gui.GB.ca_ratio_A      = latt_param(gui.GB.Material_A, gui.GB.Phase_A);
    gui.GB.Material_B      = gui_map.grains(gui.GB.GrainB).material;
    gui.GB.ca_ratio_B      = latt_param(gui.GB.Material_B, gui.GB.Phase_B);
    gui.GB.activeGrain     = gui.GB.GrainA;
    gui.config_map         = gui_map.config_map;
    gui.config             = gui_map.config;
    gui.GB.slipA           = 1;
    gui.GB.slipB           = 1;
    gui.GB.slipA_user_spec = gui.GB.slipA;
    gui.GB.slipB_user_spec = gui.GB.slipB;
    gui.description        = ['From: ', ...
        gui_map.config_map.filename_grain_file_type2];
    gui.title_str          = set_gui_title(gui, '');
    guidata(gcf, gui);
    
    %% Popup menus
    guidata(gcf, gui);
    plotGB_Bicrystal_setpopupmenu;
    gui = guidata(gcf);
    
    %% Run calculations
    guidata(gcf, gui);
    plotGB_Bicrystal;
    gui = guidata(gcf);
    
elseif nargin == 2
    gui.GB.YAMLfilename    = 0;
    gui.GB.active_GB       = gui_cpfe.GB.GB_Number;
    gui.GB.filenameGF2_BC  = gui_cpfe.GB.filenameGF2_BC;
    gui.GB.filenameRB_BC   = gui_cpfe.GB.pathnameRB_BC;
    gui.GB.pathnameGF2_BC  = gui_cpfe.GB.filenameGF2_BC;
    gui.GB.pathnameRB_BC   = gui_cpfe.GB.pathnameRB_BC;
    gui.GB.GrainA          = gui_cpfe.GB.GrainA;
    gui.GB.GrainB          = gui_cpfe.GB.GrainB;
    gui.GB.eulerA          = gui_cpfe.GB.eulerA;
    gui.GB.eulerB          = gui_cpfe.GB.eulerB;
    gui.GB.eulerA_ori      = gui_cpfe.GB.eulerA_ori;
    gui.GB.eulerB_ori      = gui_cpfe.GB.eulerB_ori;
    gui.GB.Phase_A         = gui_cpfe.GB.Phase_A;
    gui.GB.Phase_B         = gui_cpfe.GB.Phase_B;
    gui.GB.number_phase    = gui_cpfe.GB.number_phase;
    gui.GB.GB_Inclination  = gui_cpfe.GB.GB_Inclination;
    gui.GB.GB_Trace_Angle  = gui_cpfe.GB.GB_Trace_Angle;
    gui.GB.GB_Number       = gui_cpfe.GB.GB_Number;
    gui.GB.Material_A      = gui_cpfe.GB.Material_A;
    gui.GB.ca_ratio_A      = gui_cpfe.GB.ca_ratio_A;
    gui.GB.Material_B      = gui_cpfe.GB.Material_B;
    gui.GB.ca_ratio_B      = gui_cpfe.GB.ca_ratio_B;
    gui.GB.activeGrain     = gui_cpfe.GB.activeGrain;
    gui.config_map         = gui_cpfe.config_map;
    gui.config             = gui_cpfe.config;
    gui.GB.slipA           = 1;
    gui.GB.slipB           = 1;
    gui.GB.slipA_user_spec = gui.GB.slipA;
    gui.GB.slipB_user_spec = gui.GB.slipB;
    gui.description        = 'From CPFE model';
    gui.title_str          = set_gui_title(gui, '');
    guidata(gcf, gui);
    
    %% Popup menus
    guidata(gcf, gui);
    plotGB_Bicrystal_setpopupmenu;
    gui = guidata(gcf);
    
    %% Run calculations
    guidata(gcf, gui);
    plotGB_Bicrystal;
    gui = guidata(gcf);
end

guidata(gcf, gui);
gui_handle = gui.handles.Bicrystal_interface;

%% Set logo of the GUI
java_icon_gui;

end