% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Kacher et al. (2012) : DOI ==> 10.1016/j.actamat.2012.08.036
tabularasa;
%installation_mtex = MTEX_check_install;
installation_mtex = 0;
plot_matlab = 1;
latt_param_Ti = latt_param('Ti', 'hcp');

%% Loading of GB data
folder_name = which('Kacher2012_1_plot');
[pathstr,name,ext] = fileparts(folder_name);
parent_directory = pathstr;

GB(1).Misorientation_angle = 36; % in degrees
GB(1).Misorientation_axis = [-11, -22,  -2];
GB(1).SlipA_dir = [1, 0, -1];
GB(1).SlipB_dir = [1, -1, -2];
GB(1).SlipB_norm = [-1,  1, -1];
GB(1).rbv = 0.72;

GB(2).Misorientation_angle = 36; % in degrees
GB(2).Misorientation_axis = [-11, -22,  -2];
GB(2).SlipA_dir = [1, 0, -1];
GB(2).SlipB_dir = [2, 1, -1];
GB(2).SlipB_norm = [-1, 1, -1];
GB(2).rbv = 0.6;

GB(3).Misorientation_angle = 36; % in degrees
GB(3).Misorientation_axis = [-11, -22,  -2];
GB(3).SlipA_dir = [1, 0, -1];
GB(3).SlipB_dir = [1, 2, 1];
GB(3).SlipB_norm = [-1, 1, -1];
GB(3).rbv = 1;

GB(4).Misorientation_angle = 36; % in degrees
GB(4).Misorientation_axis = [-11, -22,  -2];
GB(4).SlipA_dir = [1, 0, -1];
GB(4).SlipB_dir = [2, 1, 1];
GB(4).SlipB_norm = [1, -1, -1];
GB(4).rbv = 0.72;

GB(5).Misorientation_angle = 36; % in degrees
GB(5).Misorientation_axis = [-11, -22,  -2];
GB(5).SlipA_dir = [1, 0, -1];
GB(5).SlipB_dir = [1, -1, 2];
GB(5).SlipB_norm = [1, -1, -1];
GB(5).rbv = 0.92;

GB(6).Misorientation_angle = 36; % in degrees
GB(6).Misorientation_axis = [-11, -22,  -2];
GB(6).SlipA_dir = [1, 0, -1];
GB(6).SlipB_dir = [1, 2, -1];
GB(6).SlipB_norm = [1, -1, -1];
GB(6).rbv = 0.91;

GB(7).Misorientation_angle = 36; % in degrees
GB(7).Misorientation_axis = [-11, -22,  -2];
GB(7).SlipA_dir = [1, 0, -1];
GB(7).SlipB_dir = [1, -2, -1];
GB(7).SlipB_norm = [-1, -1, 1];
GB(7).rbv = 0.73;

GB(8).Misorientation_angle = 36; % in degrees
GB(8).Misorientation_axis = [-11, -22,  -2];
GB(8).SlipA_dir = [1, 0, -1];
GB(8).SlipB_dir = [2, -1, 1];
GB(8).SlipB_norm = [-1, -1, 1];
GB(8).rbv = 0.61;

GB(9).Misorientation_angle = 36; % in degrees
GB(9).Misorientation_axis = [-11, -22,  -2];
GB(9).SlipA_dir = [1, 0, -1];
GB(9).SlipB_dir = [1, 1, 2];
GB(9).SlipB_norm = [-1, -1, 1];
GB(9).rbv = 1;

GB(10).Misorientation_angle = 36; % in degrees
GB(10).Misorientation_axis = [-11, -22,  -2];
GB(10).SlipA_dir = [1, 0, -1];
GB(10).SlipB_dir = [1, 1, -2];
GB(10).SlipB_norm = [1, 1, 1];
GB(10).rbv = 0.81;

GB(11).Misorientation_angle = 36; % in degrees
GB(11).Misorientation_axis = [-11, -22,  -2];
GB(11).SlipA_dir = [1, 0, -1];
GB(11).SlipB_dir = [1, -2, 1];
GB(11).SlipB_norm = [1, 1, 1];
GB(11).rbv = 0.82;

GB(12).Misorientation_angle = 36; % in degrees
GB(12).Misorientation_axis = [-11, -22,  -2];
GB(12).SlipA_dir = [1, 0, -1];
GB(12).SlipB_dir = [2, -1, -1];
GB(12).SlipB_norm = [1, 1, 1];
GB(12).rbv = 0.45;

%% Calculations
rbv = zeros(length(GB), 5);
mis = zeros(length(GB), 3);
GB_legend = cell(length(GB),1);
for igb = 1:length(GB)
    %% Setting of grains Euler angles when only misorientation angle and mis. axis are given
    GB(igb).eulerA = [0, 0, 0];
    GB(igb).rot_mat = axisang2g(GB(igb).Misorientation_axis, ...
        GB(igb).Misorientation_angle);
    GB(igb).eulerB = g2eulers(GB(igb).rot_mat);

    rotA = eulers2g(GB(igb).eulerA);
    rotB = eulers2g(GB(igb).eulerB);
    rotated_b_in = rotA' * GB(igb).SlipA_dir';
    rotated_b_out_on = rotB * GB(igb).SlipB_dir';
    rotated_b_out_off = rotB' * GB(igb).SlipB_dir';
    
    %% Residual Burgers Vector
    rbv_pos = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out_on);
    
    rbv_neg = residual_Burgers_vector(rotated_b_in, ...
        -rotated_b_out_on);
    
    rbv_pos_rot = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out_off);
    
    rbv_neg_rot = residual_Burgers_vector(rotated_b_in, ...
        -rotated_b_out_off);
    
    rbv(igb, 1) = min([rbv_pos rbv_neg]);
    rbv(igb, 2) = max([rbv_pos rbv_neg]);
    rbv(igb, 3) = min([rbv_pos_rot rbv_neg_rot]);
    rbv(igb, 4) = max([rbv_pos_rot rbv_neg_rot]);
    rbv(igb, 5) = GB(igb).rbv; %Results from paper
    
    %% Misorientation
    if installation_mtex == 1
        oriA = MTEX_setBX_orientation('fcc', latt_param_Ti(1), ...
            GB(igb).eulerA);
        oriB = MTEX_setBX_orientation('fcc', latt_param_Ti(1), ...
            GB(igb).eulerB);
        mis(igb,1) = MTEX_getBX_misorientation(oriA, oriB);
    else
        mis(igb,1) = NaN;
    end
    mis(igb,2) = misorientation(GB(igb).eulerA, GB(igb).eulerB, 'fcc', 'fcc');
    mis(igb,3) = GB(igb).Misorientation_angle;
    
    %% Legend for plot
    GB_legend(igb) = {strcat('[',num2str(GB(igb).SlipA_dir), ...
        '] / [',num2str(GB(igb).SlipB_dir), ']')};
    
end

% Values recalculated from Kacher's script
rbv_recalc = Kacher_RBV_fcc(GB(1).Misorientation_axis, ...
    GB(1).Misorientation_angle, GB(1).SlipA_dir', 2);
rbv_recalc_pos = rbv_recalc(1:12);
rbv_recalc_neg = rbv_recalc(13:24);
rbv_recalc_min = zeros(length(GB), 1);
for igb = 1:length(GB)
    rbv_recalc_min(igb) = min([rbv_recalc_pos(igb) rbv_recalc_neg(igb)]);
end

rbv(:, 6) = rbv_recalc_min/2;

% Normalization
rbv_max = max(rbv(:,1:4));
rbv(:,1) = rbv(:,1)/rbv_max(1);
rbv(:,2) = rbv(:,2)/rbv_max(2);
rbv(:,3) = rbv(:,3)/rbv_max(3);
rbv(:,4) = rbv(:,4)/rbv_max(4);
rbv(:,6) = rbv_recalc_min/max(rbv_recalc_min);

rss = zeros(length(GB), 1);
for igb = 1:length(GB)
    stress_tensor =     [1.0157    0.2256   -1.9747;
        0.2256   -0.5642    1.1849;
        -1.9747    1.1849   -0.4515];
    rss(igb) = resolved_shear_stress(GB(igb).eulerB, ...
        GB(igb).SlipB_dir, GB(igb).SlipB_norm,  stress_tensor);
end

%% Plot
if plot_matlab
    %% Window Coordinates Configuration
    scrsize = screenSize;   % Get screen size
    WX = 0.27 * scrsize(3); % X Position (bottom)
    WY = 0.10 * scrsize(4); % Y Position (left)
    WW = 0.60 * scrsize(3); % Width
    WH = 0.40 * scrsize(4); % Height
    
    %% Plot axis setting (RBV)
    plot_RBV = figure('Name', 'RBV',...
        'NumberTitle', 'off',...
        'Position', [WX WY WW WH],...
        'ToolBar', 'figure');
    
    % Set plot using bar
    x_hist = 0.5:1:length(GB);
    h_bar = bar(x_hist, rbv(:,:));
    legend(h_bar, 'RBV min', 'RBV max', 'RBV min + RotMat transposed', ...
        'RBV max + RotMat transposed', 'Values from Kacher''s paper', ...
        'Values recalculated from Kacher''s function');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Normalized Residual Burgers Vector');
    
    %% Plot axis setting (misorientation)
    plot_misor = figure('Name', 'Misorientation',...
        'NumberTitle', 'off',...
        'Position', [WX+10 WY+10 WW WH],...
        'ToolBar', 'figure');
    
    % Set plot using bar
    x_hist = 0.5:1:length(GB);
    h_bar = bar(x_hist, mis(:,:));
    legend(h_bar, 'MTEX Misor', 'Calculated values', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end

%% Export results in a .txt file
save_txt_file(parent_directory, 'Data_Kacher2012.txt', rbv);
