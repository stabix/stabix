function write_yaml_struct(filename, data)
%WRITE_YAML_STRUCT Serialize a nested mapping and stage output before replacing a file.
if ~isstruct(data) || ~isscalar(data)
    error('STABiX:InvalidYamlRoot', 'YAML data must be a scalar MATLAB structure.');
end
folder = fileparts(filename);
if isempty(folder)
    folder = pwd;
end
if isempty(filename) || exist(folder, 'dir') ~= 7 || exist(filename, 'dir') == 7
    error('STABiX:InvalidYamlPath', 'Choose a YAML filename in an existing folder.');
end

% Serialize before opening any output; the bundled writer does not check fopen.
text = char(WriteYaml('', data));
temporary = tempname(folder);
[file, message] = fopen(temporary, 'w');
if file == -1
    error('STABiX:YamlWriteFailed', 'Cannot write YAML: %s', message);
end
cleanup = onCleanup(@() remove_temporary(file, temporary));
fprintf(file, '%s', text);
[message, number] = ferror(file);
if number ~= 0
    error('STABiX:YamlWriteFailed', 'Cannot write YAML: %s', message);
end
if fclose(file) ~= 0
    error('STABiX:YamlWriteFailed', 'Cannot finish writing YAML: %s.', filename);
end
[success, message] = movefile(temporary, filename, 'f');
if ~success
    error('STABiX:YamlWriteFailed', 'Cannot save YAML: %s', message);
end
clear cleanup;
end

function remove_temporary(file, filename)
if any(fopen('all') == file)
    fclose(file);
end
if exist(filename, 'file') == 2
    delete(filename);
end
end
