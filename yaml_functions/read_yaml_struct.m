function data = read_yaml_struct(filename)
%READ_YAML_STRUCT Read a YAML mapping, retaining nested MATLAB structures.
if exist(filename, 'file') ~= 2
    error('STABiX:YamlFileNotFound', 'YAML file not found: %s.', filename);
end
data = ReadYaml(filename, 1, 1);
if ~isstruct(data) || ~isscalar(data)
    error('STABiX:InvalidYamlRoot', 'The YAML document must contain a single mapping.');
end
end
