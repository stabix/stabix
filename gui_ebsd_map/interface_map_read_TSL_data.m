% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function gui = interface_map_read_TSL_data
%% Function used to read TSL data (Grain File Fype 2 and Reconstructed Boundaries File)
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

config_map         = gui.config_map;
rdm_TSL_dataset    = gui.rdm_TSL_dataset;

%% Get names/paths of TSL files
if gui.flag.newDataFlag == 0
    rdm_TSL_dataset = 0;
    config_map.filename_grain_file_type2              = ...
        config_map.default_grain_file_type2;
    config_map.filename_reconstructed_boundaries_file = ...
        config_map.default_reconstructed_boundaries_file;
    config_map.pathname_grain_file_type2              = '';
    config_map.pathname_reconstructed_boundaries_file = '';
    
elseif gui.flag.newDataFlag == 1
    rdm_TSL_dataset = 0;
    
    if isempty(config_map.filename_grain_file_type2)
        helpdlg('Please, select a Grain File Type 2 file');
    end
    
    if isempty(config_map.filename_reconstructed_boundaries_file)
        helpdlg('Please, select a Reconstructed Boundaries file');
    end
    
    if ~isfield(config_map, 'pathname_grain_file_type2') || ...
            ~isfield(config_map, 'pathname_reconstructed_boundaries_file') ...
            || ~isfield(config_map, 'filename_grain_file_type2') || ...
            ~isfield(config_map, 'filename_reconstructed_boundaries_file')
        config_map.filename_grain_file_type2              = ...
            config_map.default_grain_file_type2;
        config_map.filename_reconstructed_boundaries_file = ...
            config_map.default_reconstructed_boundaries_file;
        config_map.pathname_grain_file_type2              = '';
        config_map.pathname_reconstructed_boundaries_file = '';
    end
    
elseif gui.flag.newDataFlag == 2
    if ismac || isunix
        config_map.pathname_grain_file_type2               = ...
            strcat(rdm_TSL_dataset.GF2pathname, '/');
        config_map.pathname_reconstructed_boundaries_file  = ...
            strcat(rdm_TSL_dataset.RBpathname, '/');
    else
        config_map.pathname_grain_file_type2               = ...
            strcat(rdm_TSL_dataset.GF2pathname, '\');
        config_map.pathname_reconstructed_boundaries_file  = ...
            strcat(rdm_TSL_dataset.RBpathname, '\');
    end
    config_map.filename_grain_file_type2              = ...
        rdm_TSL_dataset.GF2filename;
    config_map.filename_reconstructed_boundaries_file = ...
        rdm_TSL_dataset.RBfilename;
end

%% Read TSL data
try
    GF2_struct = read_oim_grain_file_type2(...
        config_map.filename_grain_file_type2, ...
        config_map.pathname_grain_file_type2);
    if isstruct(GF2_struct)  % if user cancelled file selection, don't overwrite data
        gui.GF2_struct = GF2_struct;
    end
catch err
    display(err.message);
    config_map.filename_grain_file_type2 = 'validation_grain_file_type2.txt';
    config_map.pathname_grain_file_type2 = '';
    GF2_struct = read_oim_grain_file_type2(...
        config_map.filename_grain_file_type2, ...
        config_map.pathname_grain_file_type2);
    if isstruct(GF2_struct)  % if user cancelled file selection, don't overwrite data
        gui.GF2_struct = GF2_struct;
    end
end

if isempty(gui.GF2_struct) %~isfield(dataRB, 'data')
    helpdlg(['Empty Reconstructed Boundaries file ! ' ...
        'Be careful to have an EBSD map based on an hexagonal grids...']);
end

%RBHeaderLines = 8;
%filenameRBcat = strcat(config_map.pathname_reconstructed_boundaries_file, filenameRB);
%dataRB = importdata(filenameRBcat, ' ', RBHeaderLines);
%importdata doesn't work on Mac platform...
try
    RB_struct = read_oim_reconstructed_boundaries_file(...
        config_map.filename_reconstructed_boundaries_file, ...
        config_map.pathname_reconstructed_boundaries_file);
    if isstruct(RB_struct)  % if user cancelled file selection, don't overwrite data
        gui.RB_struct = RB_struct;
    end
catch err
    display(err.message);
    config_map.filename_reconstructed_boundaries_file  = ...
        'validation_reconstructed_boundaries.txt';
    config_map.pathname_reconstructed_boundaries_file  = '';
    RB_struct = read_oim_reconstructed_boundaries_file(...
        config_map.filename_reconstructed_boundaries_file, ...
        config_map.pathname_reconstructed_boundaries_file);
    if isstruct(RB_struct)  % if user cancelled file selection, don't overwrite data
        gui.RB_struct = RB_struct;
    end
end

if isempty(gui.RB_struct) %~isfield(dataRB, 'data')
    helpdlg(['Empty Reconstructed Boundaries file ! ' ...
        'Be careful to have an EBSD map based on an hexagonal grids...']);
end

% Set paths in the GUI
set(gui.handles.FileGF2, 'String', ...
    fullfile(config_map.filename_grain_file_type2));
set(gui.handles.FileRB, 'String', ...
    fullfile(config_map.filename_reconstructed_boundaries_file));

% Write paths in a YAML file
config_map_TSLOIM_data_path.TSLOIM_data_path_GF2 = ...
    gui.config_map.TSLOIM_data_path_GF2;
config_map_TSLOIM_data_path.TSLOIM_data_path_RB  = ...
    gui.config_map.TSLOIM_data_path_RB;
config_YAML_TSLdata = ...
    sprintf('config_gui_EBSDmap_data_path_%s.yaml', gui.config.username);
WriteYaml(config_YAML_TSLdata, config_map_TSLOIM_data_path);

gui.config_map         = config_map;
gui.rdm_TSL_dataset    = rdm_TSL_dataset;

guidata(gcf, gui);

end

