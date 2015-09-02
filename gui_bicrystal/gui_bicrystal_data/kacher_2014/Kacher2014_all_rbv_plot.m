% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Kacher et al. (2014): DOI ==> 10.1080/14786435.2013.868942

% author: d.mercier@mpie.de

%% Initialization
tabularasa;
installation_mtex = MTEX_check_install;
plot_matlab = 1;

%% Loading of GB data
folder_name = which('Kacher2014_all_rbv_plot');
[pathstr,name,ext] = fileparts(folder_name);
parent_directory = pathstr;

GB(1) = load_YAML_BX_example_config_file('Kacher2014_Gr1-Gr2_rbv4.1.yaml'); % misorientation founded with DAMASK scripts, but not with Matlab functions...
GB(2) = load_YAML_BX_example_config_file('Kacher2014_Gr3-Gr4_rbv4.2.yaml');
GB(3) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_rbv1.2.yaml');
GB(4) = load_YAML_BX_example_config_file('Kacher2014_Gr7-Gr8_rbv1.1.yaml');

%% Calculations
rbv = zeros(length(GB),2);
mis = zeros(length(GB), 4);
GB_legend = cell(length(GB),1);
for igb = 1:1:length(GB)
    %% Conversion from Bravais-Miller indices to Cartesian notation
    GB(igb).slipA_ind_cs = millerbravaisdir2cart(GB(igb).slipA_ind(2,:), ...
        GB(igb).ca_ratio_A(1))';
    GB(igb).slipB_ind_cs = millerbravaisdir2cart(GB(igb).slipB_ind(2,:), ...
        GB(igb).ca_ratio_B(1))';
    
    %% Setting of grains Euler angles when only misorientation and mis. axis are given
    if isfield(GB, 'Misorientation_angle') ...
            && isfield(GB, 'Misorientation_axis')
        GB(igb).Misorientation_axis_uvtw = ...
            cell2mat(GB(igb).Misorientation_axis);
        GB(igb).eulerA = [0 0 0];
        GB(igb).Misorientation_cartesian_vect = ...
            millerbravaisdir2cart(GB(igb).Misorientation_axis_uvtw, ...
            GB(igb).ca_ratio_A(1));
        GB(igb).rot_mat = ...
            axisang2g(GB(igb).Misorientation_cartesian_vect, ...
            GB(igb).Misorientation_angle);
        GB(igb).eulerB = g2eulers(GB(igb).rot_mat);
    end
    
    rotA = eulers2g(GB(igb).eulerA);
    rotB = eulers2g(GB(igb).eulerB);
    rotated_b_in = rotA' * GB(igb).slipA_ind_cs';
    rotated_b_out = rotB' * GB(igb).slipB_ind_cs';
    rbv(igb, 1) = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out);
    
    rbv(igb, 2) = GB(igb).rbv; % Values from paper
    
    GB_legend(igb) = {['G',num2str(GB(igb).GrainA), ...
        '/G',num2str(GB(igb).GrainB)]};
    
    %% Misorientation
    if installation_mtex == 1
        oriA = MTEX_setOrientation(GB(igb).Phase_A, ...
            GB(igb).ca_ratio_A(1), GB(igb).eulerA);
        oriB = MTEX_setOrientation(GB(igb).Phase_B, ...
            GB(igb).ca_ratio_A(1), GB(igb).eulerB);
        mis(igb,1) = MTEX_getBX_misorientation(oriA, oriB); % MTEX function
    else
        mis(igb,1) = NaN;
    end
    mis(igb,2) = misorientation(GB(igb).eulerA, GB(igb).eulerB, ...
        GB(igb).Phase_A, GB(igb).Phase_B);
    mis_ax_ang = misori_hex(GB(igb).eulerA, GB(igb).eulerB, 24); % Claudio's function
    mis(igb,3) = mis_ax_ang(4);
    mis(igb,4) = GB(igb).Misorientation_angle;
    
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
    h_bar = bar(x_hist, rbv(:,:,:), 1);
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
    h_bar = bar(x_hist, mis(:,:,:), 1);
    legend(h_bar, 'MTEX Misor', 'Calculated values', ...
        'Claudio''s function', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end

%% Export results in a .txt file
save_txt_file(parent_directory, 'Data_Kacher2014.txt', rbv);
