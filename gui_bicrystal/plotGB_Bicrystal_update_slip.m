% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [slipA, slipB] = plotGB_Bicrystal_update_slip(no_slip)
%% Script to set slips indices based on the user selection in the popup menu
% no_slip: Set to 1 if no slip obtained from calculations... 0 if slip to
% plot inside unit cells in both grains of the bicrystal.

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

% Get value of popupmenu to plot m' value (max, min...?)
valcase = get(gui.handles.pmchoicecase, 'Value');
if no_slip
    valcase = 0;
end
flag_inversionA = 0;
flag_inversionB = 0;

slipA_all_vect = slip_systems(gui.GB.Phase_A, 9);
slipB_all_vect = slip_systems(gui.GB.Phase_B, 9);

switch(valcase)
    case {1}
        slipA = gui.GB.results.x_mp_max1;
        slipB = gui.GB.results.y_mp_max1;
    case {2}
        slipA = gui.GB.results.x_mp_max2;
        slipB = gui.GB.results.y_mp_max2;
    case {3}
        slipA = gui.GB.results.x_mp_max3;
        slipB = gui.GB.results.y_mp_max3;
    case {4}
        slipA = gui.GB.results.x_mp_min1;
        slipB = gui.GB.results.y_mp_min1;
    case {5}
        slipA = gui.GB.results.x_mp_min2;
        slipB = gui.GB.results.y_mp_min2;
    case {6}
        slipA = gui.GB.results.x_mp_min3;
        slipB = gui.GB.results.y_mp_min3;
    case {7, 14, 21, 28, 29}
        slipA = gui.GB.results.SFmax_x;
        slipB = gui.GB.results.SFmax_y;
    case {8}
        slipA = gui.GB.results.x_rbv_max1;
        slipB = gui.GB.results.y_rbv_max1;
    case {9}
        slipA = gui.GB.results.x_rbv_max2;
        slipB = gui.GB.results.y_rbv_max2;
    case {10}
        slipA = gui.GB.results.x_rbv_max3;
        slipB = gui.GB.results.y_rbv_max3;
    case {11}
        slipA = gui.GB.results.x_rbv_min1;
        slipB = gui.GB.results.y_rbv_min1;
    case {12}
        slipA = gui.GB.results.x_rbv_min2;
        slipB = gui.GB.results.y_rbv_min2;
    case {13}
        slipA = gui.GB.results.x_rbv_min3;
        slipB = gui.GB.results.y_rbv_min3;
    case {15}
        slipA = gui.GB.results.x_nfact_max1;
        slipB = gui.GB.results.y_nfact_max1;
    case {16}
        slipA = gui.GB.results.x_nfact_max2;
        slipB = gui.GB.results.y_nfact_max2;
    case {17}
        slipA = gui.GB.results.x_nfact_max3;
        slipB = gui.GB.results.y_nfact_max3;
    case {18}
        slipA = gui.GB.results.x_nfact_min1;
        slipB = gui.GB.results.y_nfact_min1;
    case {19}
        slipA = gui.GB.results.x_nfact_min2;
        slipB = gui.GB.results.y_nfact_min2;
    case {20}
        slipA = gui.GB.results.x_nfact_min3;
        slipB = gui.GB.results.y_nfact_min3;
    case {22}
        slipA = gui.GB.results.x_LRBfact_max1;
        slipB = gui.GB.results.y_LRBfact_max1;
    case {23}
        slipA = gui.GB.results.x_LRBfact_max2;
        slipB = gui.GB.results.y_LRBfact_max2;
    case {24}
        slipA = gui.GB.results.x_LRBfact_max3;
        slipB = gui.GB.results.y_LRBfact_max3;
    case {25}
        slipA = gui.GB.results.x_LRBfact_min1;
        slipB = gui.GB.results.y_LRBfact_min1;
    case {26}
        slipA = gui.GB.results.x_LRBfact_min2;
        slipB = gui.GB.results.y_LRBfact_min2;
    case {27}
        slipA = gui.GB.results.x_LRBfact_min3;
        slipB = gui.GB.results.y_LRBfact_min3;
    case {30}
        if isempty(get(gui.handles.getSlipA, 'String'))
            plotGB_Bicrystal_set_slips_indices(gui.handles.getSlipA, ...
                gui.GB.slipA_all_vect(1,:,gui.GB.slipA_user_spec), ...
                gui.GB.slipA_all_vect(2,:,gui.GB.slipA_user_spec));
        end
        
        if isempty(get(gui.handles.getSlipB, 'String'))
            plotGB_Bicrystal_set_slips_indices(gui.handles.getSlipB, ...
                gui.GB.slipB_all_vect(1,:,gui.GB.slipB_user_spec), ...
                gui.GB.slipB_all_vect(2,:,gui.GB.slipA_user_spec));
        end
        
        specific_slips_AB = ...
            plotGB_Bicrystal_slip_user_def(slipA_all_vect, slipB_all_vect);
        
        if specific_slips_AB(1) == 0
            specific_slips_AB(1) = gui.GB.slipA_user_spec;
        end
        if specific_slips_AB(2) == 0
            specific_slips_AB(2) = gui.GB.slipB_user_spec;
        end
        slipA_user_spec = specific_slips_AB(1);
        slipB_user_spec = specific_slips_AB(2);
        if slipA_user_spec < 0
            flag_inversionA = 1;
            slipA_user_spec = abs(slipA_user_spec);
        end
        if slipB_user_spec < 0
            flag_inversionB = 1;
            slipB_user_spec = abs(slipB_user_spec);
        end
        gui.GB.slipA_user_spec = slipA_user_spec;
        gui.GB.slipB_user_spec = slipB_user_spec;
        
        slipA = gui.GB.slipA_user_spec;
        slipB = gui.GB.slipB_user_spec;
        
    case {0}
        slipA = 0;
        slipB = 0;
        gui.GB.mprimemax = NaN;
end

%% Set the boxes into the GUI
if ~no_slip
    slipA_vect = slipA_all_vect(:, :, slipA);
    slipB_vect = slipB_all_vect(:, :, slipB);
    
    if flag_inversionA
        slipA_vect = -slipA_all_vect(:, :, slipA);
    end
    if flag_inversionB
        slipB_vect = -slipB_all_vect(:, :, slipB);
    end
    
    plotGB_Bicrystal_set_slips_indices(gui.handles.getSlipA, ...
        slipA_vect(1,:), slipA_vect(2,:));
    plotGB_Bicrystal_set_slips_indices(gui.handles.getSlipB, ...
        slipB_vect(1,:), slipB_vect(2,:));
    
elseif no_slip
    set(gui.handles.getSlipA, 'String', num2str(slipA));
    set(gui.handles.getSlipB, 'String', num2str(slipB));
    
end

guidata(gcf, gui);

end
