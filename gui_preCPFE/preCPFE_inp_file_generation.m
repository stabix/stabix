% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_inp_file_generation(proc_path, Titlegbdata, ...
    indenter_type, handle_indenter)
%% Function used to generate .inp file for CPFE model
% proc_path: Path where to store the proc. file for CPFE model
% Titlegbdata: Title of the model
% indenter_type: Type of indenter (conical, Berkovich...) 
% fvc: face, vertex, and color of a patch

% author: d.mercier@mpie.de

proc_path_inp = fullfile(proc_path, strcat(Titlegbdata, '.inp'));

if strcmp(indenter_type, 'conical') ~= 1 && ...
        strcmp(indenter_type, 'flatPunch') ~= 1
    patch2inp(handle_indenter, proc_path_inp);
end

end