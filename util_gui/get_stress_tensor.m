% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function stressTensor = get_stress_tensor(handles)
%% Function used to set stress tensor in the map interface

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

set_default_values_txtbox(handles.ST_s11, '0');
set_default_values_txtbox(handles.ST_s12, '0');
set_default_values_txtbox(handles.ST_s13, '0');
set_default_values_txtbox(handles.ST_s21, '0');
set_default_values_txtbox(handles.ST_s22, '0');
set_default_values_txtbox(handles.ST_s23, '0');
set_default_values_txtbox(handles.ST_s31, '0');
set_default_values_txtbox(handles.ST_s32, '0');
set_default_values_txtbox(handles.ST_s33, '1');

% Get components of stress tensor
stressTensor.s11 = str2double(get(handles.ST_s11, 'String'));
stressTensor.s12 = str2double(get(handles.ST_s12, 'String'));
stressTensor.s13 = str2double(get(handles.ST_s13, 'String'));
stressTensor.s22 = str2double(get(handles.ST_s22, 'String'));
stressTensor.s23 = str2double(get(handles.ST_s23, 'String'));
stressTensor.s33 = str2double(get(handles.ST_s33, 'String'));

% Sym components
stressTensor.s21 = stressTensor.s12;
set(handles.ST_s21, 'String', num2str(stressTensor.s21));

stressTensor.s31 = stressTensor.s13;
set(handles.ST_s31, 'String', num2str(stressTensor.s31));

stressTensor.s32 = stressTensor.s23;
set(handles.ST_s32, 'String', num2str(stressTensor.s32));

stressTensor = stress_tensor(stressTensor);

end