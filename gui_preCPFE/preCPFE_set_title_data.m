% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Titlegbdata, Titlegbdatacompl] = ...
    preCPFE_set_title_data(config_map, GB)
%% Script to set the title of data and files produced for CPFEM
% config_map :Configuration from the EBSD map GUI (sample, etc...)
% GB: Grain boundary number

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

timestamp = timestamp_make;

if isempty(config_map.Material_ID) && isempty(config_map.Sample_ID)
    config_map_strcat = '';
else
    config_map_strcat = strcat(config_map.Material_ID, '_', ...
        config_map.Sample_ID, '_');
end

if strcmp(GB.active_data, 'BX') == 1
    Titlegbdata = strcat(...
        config_map_strcat, ...
        'BX', num2str(GB.GB_Number),...
        '_grain', num2str(GB.activeGrain),...
        '_', timestamp,...
        '_Incli', num2str(round(GB.GB_Inclination)));
    
elseif strcmp(GB.active_data, 'SX') == 1
    Titlegbdata = strcat(...
        config_map_strcat, ...
        'SX', num2str(GB.activeGrain),...
        '_', timestamp);
    
end

Titlegbdatacompl = strcat(Titlegbdata,'.mat');

Titlegbdata = char(Titlegbdata);
Titlegbdatacompl = char(Titlegbdatacompl);

end
