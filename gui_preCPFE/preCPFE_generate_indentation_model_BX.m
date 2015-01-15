% Copyright 2013 Max-Planck-Institut f�r Eisenforschung GmbH
function preCPFE_generate_indentation_model_BX
%% Generation of procedure file and material file for CPFE modelling of BX indentation (with GENMAT or DAMASK)
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui_BX = guidata(gcf);

%% Initialization = Set bicrystal and get active GB
if str2num(get(gui_BX.handles.mesh.ind_dist_val, 'String')) >= 0
    gui_BX.GB.activeGrain = gui_BX.GB.GrainA;
else
    gui_BX.GB.activeGrain = gui_BX.GB.GrainB;
end
[gui_BX.GB.Titlegbdata, gui_BX.GB.Titlegbdatacompl] = ...
    preCPFE_set_title_data(gui_BX.config_map, gui_BX.GB);

guidata(gcf, gui_BX);
preCPFE_indentation_setting_BX;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

preCPFE_save_data;
gui_BX = guidata(gcf); guidata(gcf, gui_BX);

%% Definition of .proc path
proc_path = fullfile(gui_BX.config.CPFEM.proc_file_path, gui_BX.GB.Titlegbdata, '');
proc_path = strrep(proc_path, '\', '\\'); % to escape \r as a carriage return

%% Definition of indenter
if strcmp(gui_BX.indenter_type, 'conical')
    gui_BX.indenter_type_model = 'conical';
elseif strcmp(gui_BX.indenter_type, 'flatPunch')
    gui_BX.indenter_type_model = 'flatPunch';
else
    gui_BX.indenter_type_model = 'customized';
end

%% Creation of the python file run in the command line window to generate procedure file for the bicrystal
scriptname_bicrystal = ...
    sprintf('%s_FEM_model_parameters.py', gui_BX.GB.Titlegbdatacompl);

python4fem_module_path = ...
    strrep(gui_BX.config.CPFEM.python4fem_module_path, '\', '\\');
python4fem_module_path_abaqus = fullfile(python4fem_module_path, 'abaqus');
python4fem_module_path_msc = fullfile(python4fem_module_path, 'msc');
python4fem_module_path_abaqus = ...
    strrep(python4fem_module_path_abaqus, '\', '\\');
python4fem_module_path_msc = strrep(python4fem_module_path_msc, '\', '\\');

gui_BX.config.CPFEM = preCPFE_config_CPFEM_check(gui_BX.config.CPFEM);

py = {''};
py{1} = sprintf('# Generated by %s (%s) %s, %s.m', ...
    gui_BX.config.toolbox_name, ...
    gui_BX.config.toolbox_version_str, ...
    gui_BX.module_name, mfilename);
py{end+1} = 'import sys';
py{end+1} = sprintf('p=''%s''', python4fem_module_path);
py{end+1} = sprintf('if p not in sys.path: sys.path.insert(0,p) \n');
py{end+1} = sprintf('import tools');
if strfind(gui_BX.config.CPFEM.fem_solver_used, 'Abaqus') == 1
    py{end+1} = sprintf('p=''%s''', python4fem_module_path_abaqus);
else
    py{end+1} = sprintf('p=''%s''', python4fem_module_path_msc);
end
py{end+1} = sprintf('if p not in sys.path: sys.path.insert(0,p) \n');
py{end+1} = sprintf('import proc');
py{end+1} = sprintf('from proc.bicrystal import BicrystalIndent');
py{end+1} = sprintf('Titlegbdata = ''%s''', gui_BX.GB.Titlegbdata);
py{end+1} = sprintf('BicrystalIndent.title = ''%s (STABiX)''', gui_BX.GB.Titlegbdata);
py{end+1} = sprintf('BicrystalIndent.CODE = ''%s''', ...
    gui_BX.config.CPFEM.simulation_code);
py{end+1} = sprintf('BicrystalIndent.FEMSOFTWAREVERSION = %.1f', ...
    gui_BX.config.CPFEM.fem_solver_version);
py{end+1} = sprintf('BicrystalIndent.FEMSOFTWARE = ''%s''', ...
    strtok(gui_BX.config.CPFEM.fem_solver_used, '_'));
py{end+1} = sprintf('BicrystalIndent.description = ''%s %s''', ...
    gui_BX.description, gui_BX.GB.Titlegbdata);
py{end+1} = 'indent = BicrystalIndent(';
py{end+1} = sprintf('modelname = ''%s'',', gui_BX.GB.Titlegbdata);
py{end+1} = sprintf('trace_ang = %.3f,', gui_BX.GB.GB_Trace_Angle);
py{end+1} = sprintf('inclination = %.2f,', gui_BX.GB.GB_Inclination);
py{end+1} = sprintf('len_trace = 1.,');
py{end+1} = sprintf('d = %e,', gui_BX.variables.ind_dist);
py{end+1} = sprintf('ind_size = 1.,');
py{end+1} = sprintf('h_indent = %.5f,', gui_BX.variables.h_indent);
py{end+1} = sprintf('tipRadius = %.5f,', gui_BX.variables.tipRadius);
py{end+1} = sprintf('coneAngle = %.5f,', gui_BX.variables.coneAngle);
py{end+1} = sprintf('friction = %.5f,', gui_BX.variables.frictionCoeff);
py{end+1} = sprintf('geo = ''%s'',', gui_BX.indenter_type_model);
py{end+1} = sprintf('free_mesh_inp = ''%s'',', ...
    strcat(gui_BX.GB.Titlegbdata, '.inp'));
py{end+1} = sprintf('wid = %.5f,', gui_BX.variables.w_sample);
py{end+1} = sprintf('hei = %.5f,', gui_BX.variables.h_sample);
py{end+1} = sprintf('len = %.5f,', gui_BX.variables.len_sample);
py{end+1} = sprintf('box_elm_nx = %i,', gui_BX.variables.box_elm_nx);
py{end+1} = sprintf('box_elm_nz = %i,', gui_BX.variables.box_elm_nz);
py{end+1} = sprintf('box_elm_ny1 = %i,', gui_BX.variables.box_elm_ny1);
py{end+1} = sprintf('box_elm_ny2_fac = %.2f,', ...
    gui_BX.variables.box_elm_ny2_fac);
py{end+1} = sprintf('box_elm_ny3 = %i,', gui_BX.variables.box_elm_ny3);
py{end+1} = sprintf('box_bias_x = %.3f,', gui_BX.variables.box_bias_x);
py{end+1} = sprintf('box_bias_z = %.3f,', gui_BX.variables.box_bias_z);
py{end+1} = sprintf('box_bias_y1 = %.3f,', gui_BX.variables.box_bias_y1);
py{end+1} = sprintf('box_bias_y2 = %.3f,', gui_BX.variables.box_bias_y2);
py{end+1} = sprintf('box_bias_y3 = %.3f,', gui_BX.variables.box_bias_y3);
py{end+1} = sprintf('smv = %e,', gui_BX.variables.smv);
%py{end+1} = sprintf('lvl = %i', gui_BX.variables.mesh_quality_lvl);
% Don't export the 'lvl' variable because numbers of elements along x, y and z axis
% are already function of the mesh quality level !
py{end+1} = ')';
py{end+1} = sprintf('proc_path = ''%s'' ', proc_path);
py{end+1} = sprintf('tools.mkdir_p(proc_path)');
if strcmp(strtok(gui_BX.config.CPFEM.fem_solver_used, '_'), 'Abaqus') == 1
    py{end+1} = sprintf(['indent.to_file(dst_path=proc_path, ' ...
        'dst_name=Titlegbdata + ''.py'')']);
else
    py{end+1} = sprintf(['indent.to_file(dst_path=proc_path, ' ...
        'dst_name=Titlegbdata + ''.proc'')']);
end
%cellfun(@display, py)

fid = fopen([scriptname_bicrystal], 'w+');
for iln = 1:numel(py)
    fprintf(fid, '%s\n', py{iln});
end
fclose(fid);

%% Execute the python code that we just generated
cmd = sprintf('%s %s', gui_BX.config.CPFEM.python_executable, ...
    fullfile(pwd, scriptname_bicrystal));
commandwindow;
% if ~ isempty(gui_BX.config.CPFEM.pythonpath)
%     setenv('PYTHONPATH', gui_BX.config.CPFEM.pythonpath);
% end
system(cmd);

%% Definition of path config file
gui_BX.path_config_file = ...
    strrep(fullfile(proc_path), '\\\\', '\\');
guidata(gcf, gui_BX);

%% Move files to keep the directory cleaned and organized
% Move YAML file
gui_BX.GB.Titlegbdatacompl_YAML = strcat(gui_BX.GB.Titlegbdatacompl, ...
    '.yaml');

% Move Python file
try
    movefile(scriptname_bicrystal, gui_BX.path_config_file);
catch err
    warning_commwin(err.message);
end
guidata(gcf, gui_BX);

preCPFE_generate_material_files(gui_BX.config.CPFEM.simulation_code, 2);

% Move .mat file
try
    movefile(gui_BX.GB.Titlegbdatacompl, gui_BX.path_config_file);
catch err
    warning_commwin(err.message);
end

%% Generation of .inp file
preCPFE_inp_file_generation(proc_path, gui_BX.GB.Titlegbdata, ...
    gui_BX.indenter_type_model, gui_BX.handle_indenter);

guidata(gcf, gui_BX);

end
