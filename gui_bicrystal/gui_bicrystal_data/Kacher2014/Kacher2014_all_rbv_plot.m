% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals given by Kacher et al. (2014): DOI ==> 10.1080/14786435.2013.868942
tabularasa;
installation_mtex = MTEX_check_install;
plot = 1;

%% Loading of YAML config. files
GB(1) = load_YAML_BX_example_config_file('Kacher2014_Gr1-Gr2_rbv4.1.yaml'); % misorientation founded with DAMASK scripts, but not with Matlab functions...
GB(2) = load_YAML_BX_example_config_file('Kacher2014_Gr3-Gr4_rbv4.2.yaml');
GB(3) = load_YAML_BX_example_config_file('Kacher2014_Gr5-Gr6_rbv1.2.yaml');
GB(4) = load_YAML_BX_example_config_file('Kacher2014_Gr7-Gr8_rbv1.1.yaml');

%% Calculations
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
    end
    rbv(ig, 1) = residual_Burgers_vector(GB(ig).slipA_ind_cs, GB(ig).slipB_ind_cs, ...
        GB(ig).eulerA, GB(ig).eulerB);
    
    rbv(ig, 2) = GB(ig).rbv; % Values from paper
    
    GB_legend(ig) = {strcat('G',num2str(GB(ig).GrainA),'/G',num2str(GB(ig).GrainB))};
    
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

if plot
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
    legend(h_bar, 'MTEX Misor', 'Calculated values', 'Claudio''s function', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end