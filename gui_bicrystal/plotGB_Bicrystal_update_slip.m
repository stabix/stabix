% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [slipA, slipB] = plotGB_Bicrystal_update_slip(no_slip)
%% Script to set slips indices based on the user selection in the popup menu
% no_slip: Set to 1 if no slip obtained from calculations... 0 if slip to
% plot inside unit cells in both grains of the bicrystal.

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

valcase = get(gui.handles.pmchoicecase, 'Value'); % Get value of popupmenu to plot m' value (max, min...?)

slipA_all_vect = slip_systems (gui.GB.Phase_A, 9);
slipB_all_vect = slip_systems (gui.GB.Phase_B, 9);

if valcase == 1
    slipA = gui.GB.results.slipA_mp_max1;
    slipB = gui.GB.results.slipB_mp_max1;
    
elseif valcase == 2
    slipA = gui.GB.results.slipA_mp_max2;
    slipB = gui.GB.results.slipB_mp_max2;
    
elseif valcase == 3
    slipA = gui.GB.results.slipA_mp_max3;
    slipB = gui.GB.results.slipB_mp_max3;
    
elseif valcase == 4
    slipA = gui.GB.results.slipA_mp_min1;
    slipB = gui.GB.results.slipB_mp_min1;
    
elseif valcase == 5
    slipA = gui.GB.results.slipA_mp_min2;
    slipB = gui.GB.results.slipB_mp_min2;
    
elseif valcase == 6
    slipA = gui.GB.results.slipA_mp_min3;
    slipB = gui.GB.results.slipB_mp_min3;
    
elseif valcase == 7 || valcase == 14 || valcase == 21 || valcase == 28 ||  valcase == 29
    slipA = gui.GB.results.slipASFmax;
    slipB = gui.GB.results.slipBSFmax;
    
elseif valcase == 8
    slipA = gui.GB.results.slipA_rbv_max1;
    slipB = gui.GB.results.slipB_rbv_max1;
    
elseif valcase == 9
    slipA = gui.GB.results.slipA_rbv_max2;
    slipB = gui.GB.results.slipB_rbv_max2;
    
elseif valcase == 10
    slipA = gui.GB.results.slipA_rbv_max3;
    slipB = gui.GB.results.slipB_rbv_max3;
    
elseif valcase == 11
    slipA = gui.GB.results.slipA_rbv_min1;
    slipB = gui.GB.results.slipB_rbv_min1;
    
elseif valcase == 12
    slipA = gui.GB.results.slipA_rbv_min2;
    slipB = gui.GB.results.slipB_rbv_min2;
    
elseif valcase == 13
    slipA = gui.GB.results.slipA_rbv_min3;
    slipB = gui.GB.results.slipB_rbv_min3;
    
elseif valcase == 15
    slipA = gui.GB.results.slipA_nfact_max1;
    slipB = gui.GB.results.slipB_nfact_max1;
    
elseif valcase == 16
    slipA = gui.GB.results.slipA_nfact_max2;
    slipB = gui.GB.results.slipB_nfact_max2;
    
elseif valcase == 17
    slipA = gui.GB.results.slipA_nfact_max3;
    slipB = gui.GB.results.slipB_nfact_max3;
    
elseif valcase == 18
    slipA = gui.GB.results.slipA_nfact_min1;
    slipB = gui.GB.results.slipB_nfact_min1;
    
elseif valcase == 19
    slipA = gui.GB.results.slipA_nfact_min2;
    slipB = gui.GB.results.slipB_nfact_min2;
    
elseif valcase == 20
    slipA = gui.GB.results.slipA_nfact_min3;
    slipB = gui.GB.results.slipB_nfact_min3;
    
elseif valcase == 22
    slipA = gui.GB.results.slipA_LRBfact_max1;
    slipB = gui.GB.results.slipB_LRBfact_max1;
    
elseif valcase == 23
    slipA = gui.GB.results.slipA_LRBfact_max2;
    slipB = gui.GB.results.slipB_LRBfact_max2;
    
elseif valcase == 24
    slipA = gui.GB.results.slipA_LRBfact_max3;
    slipB = gui.GB.results.slipB_LRBfact_max3;
    
elseif valcase == 25
    slipA = gui.GB.results.slipA_LRBfact_min1;
    slipB = gui.GB.results.slipB_LRBfact_min1;
    
elseif valcase == 26
    slipA = gui.GB.results.slipA_LRBfact_min2;
    slipB = gui.GB.results.slipB_LRBfact_min2;
    
elseif valcase == 27
    slipA = gui.GB.results.slipA_LRBfact_min3;
    slipB = gui.GB.results.slipB_LRBfact_min3;
    
elseif valcase == 30
    if isempty(get(gui.handles.getSlipA, 'String')) || gui.GB.slipA_user_spec ~= gui.GB.slipA
        set(gui.handles.getSlipA, 'String', strcat('(',num2str(slipA_all_vect(1,:,gui.GB.slipA_user_spec)),') / [',num2str(slipA_all_vect(2,:,gui.GB.slipA_user_spec)), ']'));
    end
    
    if isempty(get(gui.handles.getSlipB, 'String')) || gui.GB.slipB_user_spec ~= gui.GB.slipB
        set(gui.handles.getSlipB, 'String', strcat('(',num2str(slipB_all_vect(1,:,gui.GB.slipB_user_spec)),') / [',num2str(slipB_all_vect(2,:,gui.GB.slipB_user_spec)), ']'));
    end
    
    specific_slips_AB = plotGB_Bicrystal_slip_user_def(slipA_all_vect, slipB_all_vect);
    if specific_slips_AB(1) == 0
        specific_slips_AB(1) = slipA_user_spec;
    end
    if specific_slips_AB(2) == 0
        specific_slips_AB(2) = slipB_user_spec;
    end
    slipA_user_spec = specific_slips_AB(1);
    slipB_user_spec = specific_slips_AB(2);
    if slipA_user_spec < 0
        slipA_inv = slipA_user_spec;
        slipA_user_spec = abs(slipA_user_spec);
    end
    if slipB_user_spec < 0
        slipB_inv = slipB_user_spec;
        slipB_user_spec = abs(slipB_user_spec);
    end
    gui.GB.slipA_user_spec = slipA_user_spec;
    gui.GB.slipB_user_spec = slipB_user_spec;
    
    slipA = gui.GB.slipA_user_spec;
    slipB = gui.GB.slipB_user_spec;
    
elseif no_slip
    slipA = 0;
    slipB = 0;
    gui.GB.mprimemax = NaN;
    
end

%% Set the boxes into the GUI
if ~no_slip
    slipA_vect = slipA_all_vect(:, :, slipA);
    slipB_vect = slipB_all_vect(:, :, slipB);
    
    if exist('slipA_inv', 'var') == 1
        slipA_vect = -slipA_all_vect(:, :, slipA);
    end
    if exist('slipB_inv', 'var') == 1
        slipB_vect = -slipB_all_vect(:, :, slipB);
    end
    
    set(gui.handles.getSlipA, 'String', strcat('(',num2str(slipA_vect(1,:,1)),') / [',num2str(slipA_vect(2,:,1)), ']'));
    set(gui.handles.getSlipB, 'String', strcat('(',num2str(slipB_vect(1,:,1)),') / [',num2str(slipB_vect(2,:,1)), ']'));
    
elseif no_slip
    set(gui.handles.getSlipA, 'String', num2str(slipA));
    set(gui.handles.getSlipB, 'String', num2str(slipB));
    
end

guidata(gcf, gui);

end
