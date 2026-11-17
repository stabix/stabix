% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui_handle = demo(app)
%% Function to create the main window of the GUI, 
% to select map, bicrystal or meshing interfaces...

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
try
    STABiXroot = get_stabix_root; % ensure that environment is set
catch
    [startdir, dummy1, dummy2] = fileparts(mfilename('fullpath'));
    cd(startdir);
    commandwindow;
    path_management;
    STABiXroot = get_stabix_root; % ensure that environment is set
end

gui.config = get_config;
gui.config.stabix_root = STABiXroot;

gui.description = 'Slip transmission analysis in crystal plasticity';
gui.module_name = 'Demo';

%% Main Window Configuration
gui.handles.MainWindow = figure('NumberTitle', 'off',...
    'Color', [0.9 0.9 0.9],...
    'Position', ...
    figure_position([0.02 0.3 pixelwidth2normalizedwidth(300) 1.6]), ...
    'MenuBar', 'none', ...
    'ToolBar', 'none');

gui.title_str = set_gui_title(gui);

%% Title of the GUI
btm = 0.85;
hu = 0.05;
lft = 0.05;
wid = 0.9;

gui.handles.title_GUI = uicontrol(...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [lft btm wid 2.7*hu],...
    'String', {[gui.config.toolbox_name, ' ', ...
    gui.config.toolbox_version_str], gui.description},...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'HorizontalAlignment', 'center');

%% Run grain boundary inclination toolbox
btm = btm - 2.1*hu;
gui.handles.pbgbinc_interface = set_pushbutton('Grain Boundary Inclination',...
    [lft btm wid 1.8*hu], 'A_gui_gbinc');

set([gui.handles.pbgbinc_interface], 'BackgroundColor', [0.9 0.6 0.9]);

%% Run map interface to plot a map of grains with data From TSL
btm = btm - 1.8*hu;
gui.handles.pbinterfaceTSL = set_pushbutton('Analyze an EBSD map',...
    [lft btm wid 1.8*hu], 'A_gui_plotmap');

set([gui.handles.pbinterfaceTSL], 'BackgroundColor', [0.2 0.8 0]);

%% Run bicrystal interface
btm = btm - 1.8*hu;
gui.handles.pbBicrystal = set_pushbutton('Analyze a bicrystal',...
    [lft btm wid 1.8*hu], 'A_gui_plotGB_Bicrystal');

set([gui.handles.pbBicrystal], 'BackgroundColor', [0.2 0.8 1]);

%% Finite element preprocessing
btm = btm - 1.6*hu;
gui.handles.strinterfaceman = uicontrol(...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [lft btm wid 0.05],...
    'String', 'Finite element preprocessing');

top = 0.38;
hu = 0.1;
color_FE_ind = [0.7 0.7 1];
color_FE_scratch = [0.8 0.8 0.8];

% SX indentation set up
gui.handles.pbSX_meshing = set_pushbutton('Single crystal indentation',...
    [lft top+0.5*hu wid hu/2], 'A_preCPFE_windows_indentation_setting_SX');

% BX indentation set up
gui.handles.pbBX_meshing = set_pushbutton('Bicrystal indentation',...
    [lft top wid hu/2], 'A_preCPFE_windows_indentation_setting_BX');

% SX Scratch set up
gui.handles.pbSX_Scratch_meshing = set_pushbutton('Single crystal scratch',...
    [lft top-0.5*hu wid hu/2], 'A_preCPFE_windows_indentation_setting_BX('''', 1, 1)');

% BX Scratch set up
gui.handles.pbBX_Scratch_meshing = set_pushbutton('Bicrystal scratch',...
    [lft top-1*hu wid hu/2], 'A_preCPFE_windows_indentation_setting_BX('''', 1)');

% Background color setting
set([gui.handles.pbSX_meshing, gui.handles.pbBX_meshing], ...
    'BackgroundColor', color_FE_ind);

set([gui.handles.pbSX_Scratch_meshing, gui.handles.pbBX_Scratch_meshing], ...
    'BackgroundColor', color_FE_scratch);

%% Properties of buttons
set([gui.handles.pbgbinc_interface,...
    gui.handles.pbinterfaceTSL,...
    gui.handles.pbBicrystal,...
    gui.handles.strinterfaceman,...
    gui.handles.pbBX_meshing,...
    gui.handles.pbSX_meshing,...
    gui.handles.pbSX_Scratch_meshing,...
    gui.handles.pbBX_Scratch_meshing], ...
    'FontWeight','bold',...
    'HorizontalAlignment', 'center',...
    'FontSize', 10);

%% Logos of MPIE & MSU
gui.handles.plotlogoMPIE_axes = axes('Position', [0.2 0.03 0.55 0.36]);

[logo]  = imread('logo_MPIE_MSU.bmp');
image(logo); % doesn't need image toolbox
axis off;
axis image; % Set aspect ratio to obtain square pixels

%% Clear all & Save & Quit & Help
btm = 0.03;
gui.handles.pb_help = set_pushbutton('Documentation',...
    [0.05 btm 0.35 hu], ['gui = guidata(gcf); ' ...
    'webbrowser(gui.config.doc_path_root)']);

gui.handles.pb_sourcecode = set_pushbutton('Source code',...
    [0.4 btm 0.3 hu], ['gui = guidata(gcf); ' ...
    'webbrowser(gui.config.repository_url)']);

gui.handles.pb_contact = set_pushbutton('Contact',...
    [0.7 btm 0.25 hu], ['commandwindow; ' ...
    'fprintf(''### STABiX contact ###\nE-mail '...
    'to mail@claudio.zambaldi.de or david9684@gmail.com\n'')']);

set([gui.handles.pb_help, ...
    gui.handles.pb_sourcecode, ...
    gui.handles.pb_contact], ...
    'FontWeight','bold', ...
    'HorizontalAlignment', 'center', ...
    'FontSize', 8);
    
guidata(gcf, gui);

gui_handle = gcf;

if nargin > 0
    if strcmpi(app, 'map')
        A_gui_plotmap;
    elseif strcmpi(app, 'indsx')
        A_preCPFE_windows_indentation_setting_SX;
    elseif strcmpi(app, 'indbx')
        A_preCPFE_windows_indentation_setting_BX;
    end
end

%% Set logo of the GUI
java_icon_gui(gui.handles.MainWindow);

end
