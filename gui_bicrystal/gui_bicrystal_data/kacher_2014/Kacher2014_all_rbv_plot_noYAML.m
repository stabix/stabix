% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Kacher et al. (2014): DOI ==> 10.1080/14786435.2013.868942

% author: d.mercier@mpie.de

%% Initialization
tabularasa;
installation_mtex = MTEX_check_install;
plot_matlab = 1;
latt_param_Ti = latt_param('Ti', 'hcp');

%% Loading of GB data
folder_name = which('Kacher2014_all_rbv_plot_noYAML');
[pathstr,name,ext] = fileparts(folder_name);
parent_directory = pathstr;

GB(1).Misorientation_angle = 40;  % misorientation founded with DAMASK scripts, but not with Matlab functions...
GB(1).Misorientation_axis_uvtw = [1, -2, 1, -3];
GB(1).SlipA_dir_BM = [-1, 2, -1, 3];
GB(1).SlipB_dir_BM = [1, 1, -2, 0];
GB(1).rbv = 4.1;

GB(2).Misorientation_angle = 32;
GB(2).Misorientation_axis_uvtw = [1, 5, -6, 16];
GB(2).SlipA_dir_BM = [-1, 2, -1, 0];
GB(2).SlipB_dir_BM = [-2, 1, 1, 0];
GB(2).rbv = 4.2;

GB(3).Misorientation_angle = 46;
GB(3).Misorientation_axis_uvtw = [8, -20, 12, 5];
GB(3).SlipA_dir_BM = [-1, -1, 2, 0];
GB(3).SlipB_dir_BM = [1, 1, -2, 0];
GB(3).rbv = 1.2;

GB(4).Misorientation_angle = 9;
GB(4).Misorientation_axis_uvtw = [5, 2, -7, 2];
GB(4).SlipA_dir_BM = [-2, 1, 1, 0];
GB(4).SlipB_dir_BM = [-2, 1, 1, 0];
GB(4).rbv = 1.1;

%% Calculations
rbv = zeros(length(GB), 2);
mis = zeros(length(GB), 5);
mis_ax_ang = zeros(1:4, length(GB));
GB_legend = cell(length(GB),1);
for igb = 1:length(GB)
    %% Setting of grains Euler angles when only misorientation angle and mis. axis are given
    GB(igb).eulerA                        = [0, 0, 0];
    GB(igb).Misorientation_axis_uvtw_norm = ...
        GB(igb).Misorientation_axis_uvtw ...
        / norm(GB(igb).Misorientation_axis_uvtw);
    GB(igb).Misorientation_cartesian_vect = ...
        millerbravaisdir2cart(GB(igb).Misorientation_axis_uvtw, ...
        latt_param_Ti(1));
    GB(igb).Misorientation_cart_vect_norm = ...
        GB(igb).Misorientation_cartesian_vect ...
        / norm(GB(igb).Misorientation_cartesian_vect);
    GB(igb).rot_mat                       = ...
        axisang2g(GB(igb).Misorientation_cartesian_vect, ...
        GB(igb).Misorientation_angle);
    GB(igb).eulerB                        = g2eulers(GB(igb).rot_mat);
    if installation_mtex == 1
        cs = symmetry('hexagonal');
        axMB = GB(igb).Misorientation_axis_uvtw_norm;
        quatMTEX2(igb) = axis2quat(vector3d(...
            Miller(GB(igb).Misorientation_axis_uvtw(1), ...
            GB(igb).Misorientation_axis_uvtw(2), ...
            GB(igb).Misorientation_axis_uvtw(4))), ...
            GB(igb).Misorientation_angle*degree);
        GB(igb).eulerB2 = (Euler(quatMTEX2(igb), 'Bunge'))*180/pi;
    end
    
    %% Conversion from Bravais-Miller indices to Cartesian notation
    GB(igb).slipA_vec = millerbravaisdir2cart(GB(igb).SlipA_dir_BM, ...
        latt_param_Ti(1))';
    GB(igb).slipB_vec = millerbravaisdir2cart(GB(igb).SlipB_dir_BM, ...
        latt_param_Ti(1))';
    
    %% Residual Burgers Vector
    rotA = eulers2g(GB(igb).eulerA);
    rotB = eulers2g(GB(igb).eulerB);
    rotated_b_in = rotA' * GB(igb).slipA_vec';
    rotated_b_out = rotB' * GB(igb).slipB_vec';
    rbv(igb,1) = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out);
    
    rbv(igb, 2) = GB(igb).rbv;
    
    %% Misorientation
    if installation_mtex == 1
        oriA = MTEX_setOrientation('hcp', latt_param_Ti(1), ...
            GB(igb).eulerA);
        oriB = MTEX_setOrientation('hcp', latt_param_Ti(1), ...
            GB(igb).eulerB);
        oriB2 = MTEX_setOrientation('hcp', latt_param_Ti(1), ...
            GB(igb).eulerB2);
        mis(igb,1) = MTEX_getBX_misorientation(oriA, oriB); % MTEX function
        mis(igb,2) = MTEX_getBX_misorientation(oriA, oriB2); % MTEX function
        axisMTEX(igb) = axis(oriA, oriB);
    else
        mis(igb, 1) = NaN;
    end
    mis(igb,3) = misorientation(GB(igb).eulerA, GB(igb).eulerB, ...
        'hcp', 'hcp');
    mis_ax_ang(1:4,igb) = misori_hex(GB(igb).eulerA, GB(igb).eulerB, 24);  % Claudio's function
    mis(igb,4) = mis_ax_ang(4,igb);
    mis(igb,5) = GB(igb).Misorientation_angle;
    
    %% Legend for plot
    GB_legend(igb) = {strcat('GB', num2str(igb))};
    
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
    legend(h_bar, 'Calculated values', 'Values from paper');
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
    h_bar = bar(x_hist, mis(:,:));
    legend(h_bar, 'MTEX Misor #1', 'MTEX Misor #2', ...
        'Calculated values', 'Claudio''s function', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end

%% Export results in a .txt file
save_txt_file(parent_directory, 'Data_Kacher2014_noYAML.txt', rbv);
