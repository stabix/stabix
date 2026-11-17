function preCPFE_export_ansys_geometry
%% Export a geometry-only SpaceClaim script from the current GUI settings.
gui = guidata(gcf);

if ~gui.config.CPFEM.python.exists
    error('STABiX:PythonUnavailable', ...
        ['ANSYS script export requires an external Python 3 executable. ' ...
        'Mesh previews and YAML mesh settings do not require Python.']);
end

if ~isempty(strfind(gui.description, 'Scratch'))
    error('ANSYS geometry export does not support scratch tests.');
end
if get(gui.handles.indenter.pm_indenter, 'Value') ~= 1
    error('ANSYS geometry export supports only the cono-spherical indenter.');
end

if ~isempty(strfind(gui.description, 'single crystal'))
    data.kind = 'SX';
elseif ~isempty(strfind(gui.description, 'bicrystal'))
    data.kind = 'BX';
else
    error('ANSYS geometry export requires an SX or BX indentation GUI.');
end

data.indenter_type = 'conical';
data.tipRadius = str2double(get(gui.handles.indenter.tipRadius_val, 'String'));
data.coneAngle = str2double(get(gui.handles.indenter.coneAngle_val, 'String'));
data.h_sample = str2double(get(gui.handles.mesh.h_sample_val, 'String'));
if strcmp(data.kind, 'SX')
    data.D_sample = str2double(get(gui.handles.mesh.D_sample_val, 'String'));
    data.r_center_frac = str2double(get(gui.handles.mesh.r_center_frac_val, 'String'));
    data.box_xfrac = str2double(get(gui.handles.mesh.box_xfrac_val, 'String'));
    data.box_zfrac = str2double(get(gui.handles.mesh.box_zfrac_val, 'String'));
else
    data.len_sample = str2double(get(gui.handles.mesh.len_sample_val, 'String'));
    data.w_sample = str2double(get(gui.handles.mesh.w_sample_val, 'String'));
    data.ind_dist = str2double(get(gui.handles.mesh.ind_dist_val, 'String'));
    data.inclination = str2double(get(gui.handles.mesh.inclination_val, 'String'));
    data.trace_angle = gui.GB.GB_Trace_Angle;
end

[filename, directory] = uiputfile('*.py', 'Export ANSYS geometry script');
if isequal(filename, 0)
    return
end
script = fullfile(directory, filename);
generator = fullfile(get_stabix_root, 'gui_preCPFE', 'ansys', 'generate_geometry.py');
parameters = [tempname, '.json'];
fid = fopen(parameters, 'w');
if fid == -1
    error('Cannot create temporary ANSYS parameters file: %s', parameters);
end
cleanup = onCleanup(@() delete(parameters));
count = fprintf(fid, '%s', jsonencode(data));
status = fclose(fid);
if count == 0 || status ~= 0
    error('Cannot write ANSYS parameters file: %s', parameters);
end

cmd = sprintf('"%s" "%s" "%s" "%s"', ...
    gui.config.CPFEM.python_executable, generator, parameters, script);
if ispc
    if ~isempty(strfind(cmd, '%'))
        error('ANSYS export paths must not contain percent characters on Windows.');
    end
end
[status, output] = system(cmd);
if status ~= 0
    error('ANSYS geometry export failed:\n%s', output);
end
msgbox(sprintf(['Geometry script exported to:\n%s\n\n' ...
    'Run it in a new empty SpaceClaim document. Configure mesh, contact, ' ...
    'boundary conditions and crystal-plasticity materials in Mechanical.'], script), ...
    'ANSYS geometry export');
end
