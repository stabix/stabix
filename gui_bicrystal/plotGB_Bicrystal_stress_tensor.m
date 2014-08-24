% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: plotGB_Bicrystal_stress_tensor.m 1201 2014-08-05 12:39:38Z d.mercier $
function plotGB_Bicrystal_stress_tensor
%% Script to set the stress tensor for Schmid factor calculation
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

% Setting of components of stress if empty
if isempty(get(gui.handles.BC_ST_s11, 'String'))
    set(gui.handles.BC_ST_s11, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s12, 'String'))
    set(gui.handles.BC_ST_s12, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s13, 'String'))
    set(gui.handles.BC_ST_s13, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s21, 'String'))
    set(gui.handles.BC_ST_s21, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s22, 'String'))
    set(gui.handles.BC_ST_s22, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s23, 'String'))
    set(gui.handles.BC_ST_s23, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s31, 'String'))
    set(gui.handles.BC_ST_s31, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s32, 'String'))
    set(gui.handles.BC_ST_s32, 'String', '0')
end
if isempty(get(gui.handles.BC_ST_s33, 'String'))
    set(gui.handles.BC_ST_s33, 'String', '1')
end

% Get components of stress
bc_stress11 = str2double(get(gui.handles.BC_ST_s11, 'string'));
bc_stress12 = str2double(get(gui.handles.BC_ST_s12, 'string'));
bc_stress13 = str2double(get(gui.handles.BC_ST_s13, 'string'));
bc_stress21 = str2double(get(gui.handles.BC_ST_s21, 'string'));
bc_stress22 = str2double(get(gui.handles.BC_ST_s22, 'string'));
bc_stress23 = str2double(get(gui.handles.BC_ST_s23, 'string'));
bc_stress31 = str2double(get(gui.handles.BC_ST_s31, 'string'));
bc_stress32 = str2double(get(gui.handles.BC_ST_s32, 'string'));
bc_stress33 = str2double(get(gui.handles.BC_ST_s33, 'string'));

% Stress tensor is defined using TSL convensions with x down !!!
gui.stress_tensor.bc_sigma = [bc_stress11, bc_stress12, bc_stress13;...
    bc_stress21, bc_stress22, bc_stress23;...
    bc_stress31, bc_stress32, bc_stress33];                                

% Frobenius norm - unitized stress tensor to get generalized schmid factor
gui.stress_tensor.bc_sigma_n = gui.stress_tensor.bc_sigma/norm(gui.stress_tensor.bc_sigma, 'fro');             
gui.stress_tensor.bc_sigma_v = [gui.stress_tensor.bc_sigma(1,1) gui.stress_tensor.bc_sigma(2,2) gui.stress_tensor.bc_sigma(3,3)]';

guidata(gcf, gui);

end
