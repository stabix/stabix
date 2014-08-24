% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: Kacher2014_Gr5_Gr6_all_rbv_plot.m 1254 2014-08-20 18:46:55Z d.mercier $
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals given by Kacher et al. (2014): DOI ==> 10.1080/14786435.2013.868942
tabularasa;
installation_mtex = MTEX_check_install;

GB(1) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_1_rbv1.2.yaml');
GB(2) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_2_rbv3.3.yaml');
GB(3) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_3_rbv2.8.yaml');
GB(4) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_4_rbv3.5.yaml');
GB(5) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_5_rbv4.8.yaml');
GB(6) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_6_rbv6.2.yaml');
GB(7) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_7_rbv6.0.yaml');
GB(8) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_8_rbv6.0.yaml');
GB(9) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_9_rbv4.2.yaml');
GB(10) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_10_rbv4.3.yaml');% Not working !
GB(10).slipB_ind(2,:) = [0 0 0 -3]; % Slip doesn't exist in "slip_system" and is replaced by default by basal slip...

for ig = 1:1:length(GB)
    %% Conversion from Bravais-Miller indices to Cartesian notation
    GB(ig).slipA_ind_cs = millerbravaisdir2cart(GB(ig).slipA_ind(2,:), GB(ig).ca_ratio_A(1))';
    GB(ig).slipB_ind_cs = millerbravaisdir2cart(GB(ig).slipB_ind(2,:), GB(ig).ca_ratio_B(1))';
    
    %% Setting of grains Euler angles when only misorientation and mis. axis are given
    if isfield(GB, 'Misorientation_angle') && isfield(GB, 'Misorientation_axis')
        GB(ig).Misorientation_axis_uvtw = cell2mat(GB(ig).Misorientation_axis);
        GB(ig).eulerA = [0 0 0];
        GB(ig).Misorientation_cartesian_vect = millerbravaisdir2cart(GB(ig).Misorientation_axis_uvtw, GB(ig).ca_ratio_A(1));
        GB(ig).rot_mat = axisang2g(GB(ig).Misorientation_cartesian_vect, GB(ig).Misorientation_angle);
        GB(ig).eulerB = g2eulers(GB(ig).rot_mat);
        GB(ig).eulerB_rot = g2eulers(GB(ig).rot_mat');
    end
    
    rbv_pos = residual_Burgers_vector(GB(ig).slipA_ind_cs, GB(ig).slipB_ind_cs, ...
        GB(ig).eulerA, GB(ig).eulerB);
    
    rbv_neg = residual_Burgers_vector(-GB(ig).slipA_ind_cs, GB(ig).slipB_ind_cs, ...
        GB(ig).eulerA, GB(ig).eulerB);
    
    rbv_min = min([rbv_pos rbv_neg]);
    rbv_max = max([rbv_pos rbv_neg]);
    
    if isfield(GB, 'eulerA_rot') && isfield(GB, 'eulerB_rot')
        rbv_pos_rot = residual_Burgers_vector(GB(ig).slipA_ind_cs, GB(ig).slipB_ind_cs, ...
            GB(ig).eulerA, GB(ig).eulerB_rot);
        
        rbv_neg_rot = residual_Burgers_vector(-GB(ig).slipA_ind_cs, GB(ig).slipB_ind_cs, ...
            GB(ig).eulerA, GB(ig).eulerB_rot);
        
        rbv_min_rot = min([rbv_pos_rot rbv_neg_rot]);
        rbv_max_rot = max([rbv_pos_rot rbv_neg_rot]);
    end
    
    rbv(ig, 1) = rbv_min;
    rbv(ig, 2) = rbv_max;
    if isfield(GB, 'eulerA_rot') && isfield(GB, 'eulerB_rot')
        rbv(ig, 3) = rbv_min_rot;
        rbv(ig, 4) = rbv_max_rot;
    end
    rbv(ig, 5) = GB(ig).rbv; % Values from paper
    
    GB_legend(ig) = {strcat('[',num2str(GB(ig).slipA_ind(2,:)), '] / [',num2str(GB(ig).slipB_ind(2,:)), ']')};
    
    %% Misorientation
    if installation_mtex == 1
        oriA = MTEX_setBX_orientation(GB(ig).Phase_A, GB(ig).ca_ratio_A(1), GB(ig).eulerA);
        oriB = MTEX_setBX_orientation(GB(ig).Phase_B, GB(ig).ca_ratio_A(1), GB(ig).eulerB);
        mis(ig,1) = MTEX_getBX_misorientation(oriA, oriB); % MTEX function
    else
        mis(ig,1) = NaN;
    end
    mis(ig,2) = misorientation(GB(ig).eulerA, GB(ig).eulerB, GB(ig).Phase_A, GB(ig).Phase_B);
    mis_ax_ang = misori_hex(GB(ig).eulerA, GB(ig).eulerB, 24); % Claudio's function
    mis(ig,3) = mis_ax_ang(4);
    mis(ig,4) = GB(ig).Misorientation_angle;
end

% Values recalculated from Kacher's script
if isfield(GB, 'Misorientation_angle') && isfield(GB, 'Misorientation_axis')
    rbv_recalc = Kacher_RBV_hcp(GB(1).Misorientation_axis_uvtw, GB(1).Misorientation_angle, GB(1).slipA_ind(2,:));
    rbv_recalc_pos = rbv_recalc(1:10);
    rbv_recalc_neg = rbv_recalc(11:20);
    for ii = 1:10
        rbv_recalc_min(ii) = min([rbv_recalc_pos(ii) rbv_recalc_neg(ii)]);
    end
    
    rbv(:, 6) = rbv_recalc_min;
end

%% Window Coordinates Configuration
scrsize = screenSize;   % Get screen size
WX = 0.27 * scrsize(3); % X Position (bottom)
WY = 0.10 * scrsize(4); % Y Position (left)
WW = 0.60 * scrsize(3); % Width
WH = 0.40 * scrsize(4); % Height

%% Plot axis setting
plot_interface = figure('Name', 'RBV minimized',...
    'NumberTitle', 'off',...
    'Position', [WX WY WW WH],...
    'ToolBar', 'figure');

% Set plot using bar
x_hist = 0.5:1:length(GB);
h_bar = bar(x_hist, rbv(:,:), 1);
legend(h_bar, 'RBV min', 'RBV max', 'RBV min + RotMat transposed', 'RBV max + RotMat transposed', 'Values from Kacher''s paper', 'Values recalculated from Kacher''s function');
set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
ylabel('Residual Burgers Vector');
xticklabel_rotate([],45);

%% Plot axis setting (misorientation)
plot_misor = figure('Name', 'Misorientation',...
    'NumberTitle', 'off',...
    'Position', [WX+10 WY+10 WW WH],...
    'ToolBar', 'figure');

% Set plot using bar
x_hist = 0.5:1:length(GB);
h_bar = bar(x_hist, mis(:,:), 1);
legend(h_bar, 'MTEX Misor', 'Calculated values', 'Claudio''s function', 'Values from paper');
set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
ylabel('Misorientation in °');
xticklabel_rotate([],45);
