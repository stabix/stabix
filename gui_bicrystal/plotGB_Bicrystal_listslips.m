% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [listslipA, listslipB, no_slip] = plotGB_Bicrystal_listslips
%% Script to update the lists of slip systems for both grains
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

% Get value of popupmenu to plot m' value (max, min...?)
size_popupmenu = size(get(gui.handles.pmchoicecase, 'String'));
if get(gui.handles.pmchoicecase, 'Value') == size_popupmenu(1); % Imported inputs
    set(gui.handles.pmlistslipsA, 'Value', 1);
    set(gui.handles.pmlistslipsB, 'Value', 1);
end

var_slipA = get_value_popupmenu(gui.handles.pmlistslipsA, ...
    listSlipSystems(gui.GB.Phase_A));
for ii = 1:1:size(var_slipA, 2)
    listslipA(ii) = slip_systems_plot(var_slipA(ii,:));
end

var_slipB = get_value_popupmenu(gui.handles.pmlistslipsB, ...
    listSlipSystems(gui.GB.Phase_B));
for ii = 1:1:size(var_slipB, 2)
    listslipB(ii) = slip_systems_plot(var_slipB(ii,:));
end

no_slip = (listslipA(1) == 0 || listslipB(1) == 0);

end