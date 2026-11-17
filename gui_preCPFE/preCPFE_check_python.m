function python = preCPFE_check_python(executable)
%% Check optional external Python support without preventing mesh previews.
python = struct('location', executable, 'exists', false, ...
    'finds_numpy', false, 'finds_scipy', false, ...
    'numpy_version', '', 'scipy_version', '', 'version', '', 'works', false);
if isempty(executable)
    return;
end

[status, ~] = system(sprintf('"%s" -c "exit()"', executable));
if status ~= 0
    warning('STABiX:PythonUnavailable', ...
        ['External Python is unavailable. Mesh previews and YAML settings ' ...
        'remain available; Python-based generation is disabled.']);
    return;
end
python.exists = true;

helper_directory = fullfile(fileparts(mfilename('fullpath')), 'python');
if exist(fullfile(helper_directory, 'python_check.m'), 'file') ~= 2
    warning('STABiX:PythonCheckUnavailable', ...
        ['The bundled python_check.m helper is missing. Mesh previews ' ...
        'remain available, but CPFE generation cannot be enabled.']);
    return;
end
addpath(helper_directory);
python = python_check(executable);
if ~python.works
    warning('STABiX:PythonUnavailable', ...
        ['The selected Python cannot import NumPy. Mesh previews remain ' ...
        'available; Python-based CPFE generation is disabled.']);
end
end
