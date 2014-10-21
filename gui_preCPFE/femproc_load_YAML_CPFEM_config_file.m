% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_load_YAML_CPFEM_config_file(YAML_CPFEM_config_file_2_import, varargin)%, interface)
%% Function to import YAML CPFEM config. file file
% YAML_CPFEM_config_file_2_import : Name of YAML CPFEM config. to import
% interface: type of interface (1 for SX or 2 for BX meshing interface)
% See in http://code.google.com/p/yamlmatlab/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

if ~ isfield(gui, 'config_CPFEM_file')
    gui.config_CPFEM_file = '';
end

if nargin > 0
    if exist(YAML_CPFEM_config_file_2_import, 'file')
        gui.config_CPFEM_file = YAML_CPFEM_config_file_2_import;
    end
else
    gui.config_CPFEM_file = gui.defaults.config_CPFEM_full;
end

%% Loading YAML file
try
    gui.config_CPFEM = ReadYaml(gui.config_CPFEM_file);
    gui.config_CPFEM.user_setting = 1;
    gui.config_CPFEM.python_exe_path = 'python';
catch
    gui.config_CPFEM = struct();
    gui.config_CPFEM.user_setting = 0;
end

gui.config_CPFEM.filename = gui.config_CPFEM_file;

%% Setting of CPFEM code by default
if ~isfield(gui.config_CPFEM, 'simulation_code')
    warning('Missing CPFEM code definition in your CPFEM YAML config. file...');
    gui.config_CPFEM.simulation_code = 'DAMASK';
end

%% Setting of list of FEM solvers
if ~isfield(gui.config_CPFEM, 'fem_solvers')
    warning('Missing FEM solvers list in your CPFEM YAML config. file...');
    gui.config_CPFEM.fem_solvers = 'Mentat_2013.1';
end

%% Setting of FEM solvers used
if ~isfield(gui.config_CPFEM, 'fem_solver_used')
    warning('Missing FEM solver used in your CPFEM YAML config. file...');
    gui.config_CPFEM.fem_solver_used = 'Mentat_2013.1';
end

%% Setting of procedure path by default
if ~isfield(gui.config_CPFEM, 'proc_file_path')
    warning('Missing path to store proc. file in your CPFEM YAML config. file...');
    gui.config_CPFEM.proc_file_path = getenv('SLIP_TRANSFER_TBX_ROOT');
end

%% Setting of python folder for FEM path by default
if ~isfield(gui.config_CPFEM, 'python4fem_module_path')
    %warning('Missing path for MSC package in your CPFEM YAML config. file...');
    python4fem_module_path = fullfile(getenv('SLIP_TRANSFER_TBX_ROOT'), ...
        'third_party_code','python','');
    gui.config_CPFEM.python4fem_module_path = strrep(python4fem_module_path,'\','/');
    %display(['Using ', gui.config_CPFEM.python4fem_module_path])
end

%% Setting of Python executable path by default
if ~isfield(gui.config_CPFEM, 'python_executables')
    warning('Missing path for Python executable in your CPFEM YAML config. file...');
    gui.config_CPFEM.python_executable = 'python';
% else
%     gui.config_CPFEM.python_exe_path = gui.config_CPFEM.python_executable;
end

gui.config_CPFEM.python = femproc_python_check(gui.config_CPFEM.python_executable);

%% Set popup menu for the FEM interface (software version)
femproc_set_cpfem_interface_pm(gui.handles.pm_FEM_interface,...
    gui.config_CPFEM.fem_solvers, gui.config_CPFEM.fem_solver_used);

guidata(gcf, gui)

end