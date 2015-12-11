% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Cui et al. (2014) : DOI ==> 10.1016/j.actamat.2013.11.033

% author: d.mercier@mpie.de

%% Initialization
tabularasa;
installation_mtex = mtex_checkInstall;
plot_matlab = 1;
latt_param_Ti = latt_param('Ti', 'hcp');

%% Loading of GB data
folder_name = which('cui_2014_1_plot');
[pathstr,name,ext] = fileparts(folder_name);
parent_directory = pathstr;

% Misor = 60°
GB(1).Misorientation_angle = 60; % in degrees
GB(1).Misorientation_axis = -[1, 1, -1];
GB(1).SlipA_dir = [1, 1, 0];
GB(1).SlipB_dir = [1, 0, -1];
GB(1).rbv = 0.41;

GB(2).Misorientation_angle = 60; % in degrees
GB(2).Misorientation_axis = -[1, 1, -1];
GB(2).SlipA_dir = [1, 1, 0];
GB(2).SlipB_dir = [1, 1, 0];
GB(2).rbv = 0.41;

GB(3).Misorientation_angle = 60; % in degrees
GB(3).Misorientation_axis = -[1, 1, -1];
GB(3).SlipA_dir = [1, 1, 0];
GB(3).SlipB_dir = [0, 1, 1];
GB(3).rbv = 1;

GB(4).Misorientation_angle = 60; % in degrees
GB(4).Misorientation_axis = -[1, 1, -1];
GB(4).SlipA_dir = [1, 1, 0];
GB(4).SlipB_dir = [0, 1, -1];
GB(4).rbv = 0.81;

% Misor = 40°
GB(5).Misorientation_angle = 40; % in degrees
GB(5).Misorientation_axis = -[1, 0, 1];
GB(5).SlipA_dir = [0, 1, 1];
GB(5).SlipB_dir = [1, -1, 0];
GB(5).rbv = 1.15;

GB(6).Misorientation_angle = 40; % in degrees
GB(6).Misorientation_axis = -[1, 0, 1];
GB(6).SlipA_dir = [0, 1, 1];
GB(6).SlipB_dir = [1, 0, 1];
GB(6).rbv = 0.71;

GB(7).Misorientation_angle = 40; % in degrees
GB(7).Misorientation_axis = [1, 0, 1];
GB(7).SlipA_dir = [0, 1, 1];
GB(7).SlipB_dir = [0, 1, 1];
GB(7).rbv = 0.428;

GB(8).Misorientation_angle = 40; % in degrees
GB(8).Misorientation_axis = -[1, 0, 1];
GB(8).SlipA_dir = [0, 1, 1];
GB(8).SlipB_dir = [1, 0,-1];
GB(8).rbv = 1.35;

%% Calculations
rbv = zeros(length(GB), 2);
mis = zeros(length(GB), 3);
GB_legend = cell(length(GB),1);
for igb = 1:length(GB)
    %% Setting of grains Euler angles when only misorientation angle and mis. axis are given
    GB(igb).eulerA  = [0, 0, 0];
    GB(igb).rot_mat = axisang2g(GB(igb).Misorientation_axis, ...
        GB(igb).Misorientation_angle);
    GB(igb).eulerB  = g2eulers(GB(igb).rot_mat);
    
    %% Residual Burgers Vector
    rotA = eulers2g(GB(igb).eulerA);
    rotB = eulers2g(GB(igb).eulerB);
    rotated_b_in = rotA' * GB(igb).SlipA_dir';
    rotated_b_out = rotB' * GB(igb).SlipB_dir';
    rbv(igb,1) = residual_Burgers_vector(rotated_b_in, ...
        rotated_b_out)/2;
    
    rbv(igb, 2) = GB(igb).rbv;
    
    %% Misorientation
    if installation_mtex == 1
        oriA = mtex_setOrientation('fcc', latt_param_Ti(1), ...
            GB(igb).eulerA);
        oriB = mtex_setOrientation('fcc', latt_param_Ti(1), ...
            GB(igb).eulerB);
        mis(igb,1) = mtex_getBX_misorientation(oriA, oriB);
    else
        mis(igb,1) = NaN;
    end
    mis(igb,2) = misorientation(GB(igb).eulerA, ...
        GB(igb).eulerB, 'fcc', 'fcc');
    mis(igb,3) = GB(igb).Misorientation_angle;
    
    %% Legend for plot
    GB_legend(igb) = {strcat('GB', num2str(igb))};
    
end

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
    xticklabel_rotate([],45);
    ylabel('Residual Burgers Vector');
    
    %% Plot axis setting (misorientation)
    plot_misor = figure('Name', 'Misorientation',...
        'NumberTitle', 'off',...
        'Position', [WX+10 WY+10 WW WH],...
        'ToolBar', 'figure');
    
    % Set plot using bar
    x_hist = 0.5:1:length(GB);
    h_bar = bar(x_hist, mis(:,:));
    legend(h_bar, 'MTEX Misor', 'Calculated values', ...
        'Claudio''s function', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end

%% Export results in a .txt file
save_txt_file(parent_directory, 'Data_cui_2014.txt', rbv);
