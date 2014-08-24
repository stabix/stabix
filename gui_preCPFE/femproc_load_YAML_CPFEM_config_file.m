% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: femproc_load_YAML_CPFEM_config_file.m 1230 2014-08-14 11:37:09Z d.mercier $
function femproc_load_YAML_CPFEM_config_file(YAML_CPFEM_config_file_2_import, interface)
%% Function to import YAML CPFEM config. file file
% YAML_CPFEM_config_file_2_import : Name of YAML CPFEM config. to import
% interface: type of interface (1 for SX or 2 for BX meshing interface)
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if YAML_CPFEM_config_file_2_import == 0
    [YAML_CPFEM_config_file_2_import, YAML_CPFEM_config_file_2_import_path] = uigetfile('*.yaml', 'Get YAML config. file');
    
    % Handle canceled file selection
    if YAML_CPFEM_config_file_2_import == 0
        YAML_CPFEM_config_file_2_import = '';
    end
    
    if isequal(YAML_CPFEM_config_file_2_import, 0) || strcmp(YAML_CPFEM_config_file_2_import, '') == 1
        disp('User selected Cancel');
        YAML_CPFEM_config_file_2_import = sprintf('config_CPFEM_%s.yaml', gui.config_Matlab.username);
    else
        disp(['User selected :', fullfile(YAML_CPFEM_config_file_2_import)]);
    end
    
    flag_from_menu = 1;
else
    flag_from_menu = 0;
end

%% Loading YAML file
try
    gui.config_CPFEM = ReadYaml(YAML_CPFEM_config_file_2_import);
    gui.config_CPFEM.user_setting = 1;
    gui.config_CPFEM.python_exe_path = 1;
catch
    gui.config_CPFEM = struct();
    gui.config_CPFEM.user_setting = 0;
end

gui.config_CPFEM.filename = YAML_CPFEM_config_file_2_import;

%% Setting of CPFEM code by default
if ~isfield(gui.config_CPFEM, 'simulation_code')
    warning('Missing CPFEM code definition in your CPFEM YAML config. file...');
    gui.config_CPFEM.simulation_code = 'DAMASK';
end

%% Setting of FEM software
if ~isfield(gui.config_CPFEM, 'fem_software')
    warning('Missing FEM software definition in your CPFEM YAML config. file...');
    gui.config_CPFEM.fem_software = 'Mentat_2013.1';
end

%% Setting of procedure path by default
if ~isfield(gui.config_CPFEM, 'proc_file_path')
    warning('Missing path to store proc. file in your CPFEM YAML config. file...');
    gui.config_CPFEM.proc_file_path = pwd;
end

%% Setting of msc folder path by default
if ~isfield(gui.config_CPFEM, 'msc_module_path')
    warning('Missing path for MSC package in your CPFEM YAML config. file...');
    msc_module_path = fullfile(getenv('SLIP_TRANSFER_TBX_ROOT'), ...
        'third_party_code','python','');
    gui.config_CPFEM.msc_module_path = strrep(msc_module_path,'\','/');
    display(['Using ', gui.config_CPFEM.msc_module_path])
end

%% Setting of Python executable path by default
if ~isfield(gui.config_CPFEM, 'python_executable')
    warning('Missing path for Python executable in your CPFEM YAML config. file...');
    gui.config_CPFEM.python_exe_path = 0;
end

%% Setting the PYTHONPATH environment variable
if ~isfield(gui.config_CPFEM, 'pythonpath')
    warning('Missing PYTHONPATH environment variable in your CPFEM YAML config. file...');
    gui.config_CPFEM.pythonpath = [];
end

%% Set popup menu for the FEM interface (software version)
femproc_set_cpfem_interface_pm(gui.handles.pm_FEM_interface, gui.config_CPFEM.fem_software);

if interface == 1
    gui_SX = gui;
    guidata(gcf, gui_SX);
elseif interface == 2
    gui_BX = gui;
    guidata(gcf, gui_BX);
end

if flag_from_menu
    if interface == 1
        femproc_indentation_setting_SX;
    elseif interface == 2
        femproc_indentation_setting_BX;
    end
end

end
