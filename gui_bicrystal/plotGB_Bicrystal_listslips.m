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

listSlipsA = slip_systems_names(gui.GB.Phase_A);
listSlipsB = slip_systems_names(gui.GB.Phase_B);

slipAnum = get(gui.handles.pmlistslipsA, 'Value');
if size(slipAnum, 2) == 1
    slipAplot = listSlipsA(slipAnum, :);
    listslipA = slip_systems_plot(slipAplot);
else
    for ii = 1:1:size(slipAnum, 2)
        var_slipA    =  listSlipsA{slipAnum(ii)};
        listslipA(ii) = slip_systems_plot(var_slipA);
    end
end

slipBnum = get(gui.handles.pmlistslipsB, 'Value');
if size(slipBnum, 2) == 1
    slipBplot = listSlipsB(slipBnum, :);
    listslipB = slip_systems_plot(slipBplot);
else
    for ii = 1:1:size(slipBnum,2)
        var_slipB    =  listSlipsB{slipBnum(ii)};
        listslipB(ii) = slip_systems_plot(var_slipB);
    end
end

no_slip = (listslipA(1) == 0 || listslipB(1) == 0);

guidata(gcf, gui);

end
