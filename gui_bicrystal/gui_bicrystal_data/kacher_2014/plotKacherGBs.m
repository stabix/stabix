% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotKacherGBs(GB, installation_mtex)

rbv = zeros(length(GB),5);
mis = zeros(length(GB), 4);
GB_legend = cell(length(GB),1);
for igb = 1:1:length(GB)
    %% Conversion from Bravais-Miller indices to Cartesian notation
    GB(igb).slipA_ind_cs = millerbravaisdir2cart(GB(igb).slipA_ind(2,:), ...
        GB(igb).ca_ratio_A(1));
    GB(igb).slipB_ind_cs = millerbravaisdir2cart(GB(igb).slipB_ind(2,:), ...
        GB(igb).ca_ratio_B(1));
    
    %% Setting of grains Euler angles when only misorientation and mis. axis are given
    if isfield(GB, 'Misorientation_angle') ...
            && isfield(GB, 'Misorientation_axis')
        GB(igb).Misorientation_axis_uvtw = ...
            cell2mat(GB(igb).Misorientation_axis);
        GB(igb).eulerA = [0 0 0];
        GB(igb).Misorientation_cartesian_vect = ...
            millerbravaisdir2cart(GB(igb).Misorientation_axis_uvtw, ...
            GB(igb).ca_ratio_A(1));
        GB(igb).rot_mat = axisang2g(GB(igb).Misorientation_cartesian_vect, ...
            GB(igb).Misorientation_angle);
        GB(igb).eulerB = g2eulers(GB(igb).rot_mat);
        GB(igb).eulerB_rot = g2eulers(GB(igb).rot_mat');
    end
    
    rotA = eulers2g(GB(igb).eulerA);
    rotB = eulers2g(GB(igb).eulerB);
    rotB_rot = eulers2g(GB(igb).eulerB_rot);
    rotated_b_in = rotA' * GB(igb).slipA_ind_cs;
    rotated_b_in_neg = rotA' * (-GB(igb).slipA_ind_cs);
    rotated_b_out_on = rotB' * GB(igb).slipB_ind_cs;
    rotated_b_out_off = rotB_rot' * GB(igb).slipB_ind_cs;
    
    rbv_pos = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out_on);
    
    rbv_neg = residual_Burgers_vector(rotated_b_in_neg, ...
        rotated_b_out_on);
    
    rbv_min = min([rbv_pos rbv_neg]);
    rbv_max = max([rbv_pos rbv_neg]);
    
    rbv_pos_rot = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out_on);
    
    rbv_neg_rot = residual_Burgers_vector(rotated_b_in_neg, ...
        rotated_b_out_off);
    
    rbv_min_rot = min([rbv_pos_rot rbv_neg_rot]);
    rbv_max_rot = max([rbv_pos_rot rbv_neg_rot]);
    
    rbv(igb, 1) = rbv_min;
    rbv(igb, 2) = rbv_max;
    rbv(igb, 3) = rbv_min_rot;
    rbv(igb, 4) = rbv_max_rot;
    rbv(igb, 5) = GB(igb).rbv; % Values from paper
    
    GB_legend(igb) = {['[',num2str(GB(igb).slipA_ind(2,:)), ...
        '] / [',num2str(GB(igb).slipB_ind(2,:)), ']']};
    
    %% Misorientation
    if installation_mtex == 1
        oriA = mtex_setOrientation(GB(igb).Phase_A, ...
            GB(igb).ca_ratio_A(1), GB(igb).eulerA);
        oriB = mtex_setOrientation(GB(igb).Phase_B, ...
            GB(igb).ca_ratio_A(1), GB(igb).eulerB);
        mis(igb,1) = mtex_getBX_misorientation(oriA, oriB); % MTEX function
    else
        mis(igb,1) = NaN;
    end
    mis(igb,2) = misorientation(GB(igb).eulerA, GB(igb).eulerB, ...
        GB(igb).Phase_A, GB(igb).Phase_B);
    mis_ax_ang = misori_hex(GB(igb).eulerA, GB(igb).eulerB, 24); % Claudio's function
    mis(igb,3) = mis_ax_ang(4);
    mis(igb,4) = GB(igb).Misorientation_angle;
    
end

% Values recalculated from Kacher's script
% rbv_recalc = Kacher_RBV_hcp(GB(1).Misorientation_axis_uvtw, ...
%     GB(1).Misorientation_angle, GB(1).slipA_ind(2,:));
% rbv_recalc_pos = rbv_recalc(1:10);
% rbv_recalc_neg = rbv_recalc(11:20);
% rbv_recalc_min = zeros(length(GB),1);
% for ii = 1:length(GB)
%     rbv_recalc_min(ii) = min([rbv_recalc_pos(ii) rbv_recalc_neg(ii)]);
% end

% rbv(:, 6) = rbv_recalc_min;

%% Window Coordinates Configuration
scrsize = screenSize;   % Get screen size
WX = 0.27 * scrsize(3); % X Position (bottom)
WY = 0.10 * scrsize(4); % Y Position (left)
WW = 0.60 * scrsize(3); % Width
WH = 0.40 * scrsize(4); % Height

%% Plot axis setting
figure('Name', 'RBV minimized',...
    'NumberTitle', 'off',...
    'Position', [WX WY WW WH],...
    'ToolBar', 'figure');

% Set plot using bar
x_hist = 0.5:1:length(GB);
h_bar = bar(x_hist, rbv(:,:), 1);
legend(h_bar, 'RBV min', 'RBV max', 'RBV min + RotMat transposed', ...
    'RBV max + RotMat transposed', 'Values from Kacher''s paper', ...
    'Values recalculated from Kacher''s function');
set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
ylabel('Residual Burgers Vector');
xticklabel_rotate([],45);

%% Plot axis setting (misorientation)
figure('Name', 'Misorientation',...
    'NumberTitle', 'off',...
    'Position', [WX+10 WY+10 WW WH],...
    'ToolBar', 'figure');

% Set plot using bar
x_hist = 0.5:1:length(GB);
h_bar = bar(x_hist, mis(:,:), 1);
legend(h_bar, 'MTEX Misor', 'Calculated values', ...
    'Claudio''s function', 'Values from paper');
set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
ylabel('Misorientation in °');
xticklabel_rotate([],45);

end