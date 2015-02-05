% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_write_YAML_BX_config_file(YAMLpathname, YAMLfilename)
%% Function to write YAML Bicrystal config. file
% YAMLpathname: Pathname 
% YAMLfilename : Name of YAML GB config. to write

% See in http://code.google.com/p/yamlmatlab/

% author: d.mercier@mpie.de

gui = guidata(gcf);

GB_to_export.filenameGF2_BC = gui.GB.filenameGF2_BC;
GB_to_export.filenameRB_BC = gui.GB.filenameRB_BC;

GB_to_export.GB_Number = gui.GB.GB_Number;
GB_to_export.GB_Trace_Angle = gui.GB.GB_Trace_Angle;
GB_to_export.GB_Inclination = gui.GB.GB_Inclination;

GB_to_export.GrainA = gui.GB.GrainA;
GB_to_export.GrainB = gui.GB.GrainB;
GB_to_export.activeGrain = gui.GB.activeGrain;
GB_to_export.Material_A = gui.GB.Material_A;
GB_to_export.Phase_A = gui.GB.Phase_A;
GB_to_export.Material_B = gui.GB.Material_B;
GB_to_export.Phase_B = gui.GB.Phase_B;
GB_to_export.eulerA = gui.GB.eulerA;
GB_to_export.eulerB = gui.GB.eulerB;

%% Writing YAML file
YAML_GB_config_file = strcat(YAMLpathname, '\', YAMLfilename);
WriteYaml(char(YAML_GB_config_file), GB_to_export);

end