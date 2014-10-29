% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_generate_CPFE_model()
%% Function to run a specific GUI

% author: c.zambaldi@mpie.de

gui = guidata(gcf);

if strfind(gui.description, 'single crystal')
    preCPFE_generate_indentation_model_SX
end

if strfind(gui.description, 'bicrystal')
    preCPFE_generate_indentation_model_BX
end

end