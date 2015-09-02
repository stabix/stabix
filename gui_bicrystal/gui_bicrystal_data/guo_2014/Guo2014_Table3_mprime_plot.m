% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Guo et al. (2014): DOI ==> 10.1016/j.actamat.2014.05.015

% author: d.mercier@mpie.de

%% Initialization
tabularasa;
%installation_mtex = mtex_check_install;
plot_matlab = 1;

%% Loading of GB data
folder_name = which('guo_2014_Table3_mprime_plot');
[pathstr,name,ext] = fileparts(folder_name);
parent_directory = pathstr;

GB(1) = load_YAML_BX_example_config_file('guo_2014_Table3Case1.yaml');
GB(2) = load_YAML_BX_example_config_file('guo_2014_Table3Case2.yaml');
GB(3) = load_YAML_BX_example_config_file('guo_2014_Table3Case3.yaml');
GB(4) = load_YAML_BX_example_config_file('guo_2014_Table3Case4.yaml');
GB(5) = load_YAML_BX_example_config_file('guo_2014_Table3Case5.yaml');
GB(6) = load_YAML_BX_example_config_file('guo_2014_Table3Case6.yaml');
GB(7) = load_YAML_BX_example_config_file('guo_2014_Table3Case7.yaml');

slip_ind(:,:,:) = slip_systems;

%% Calculations
slip_ind_cs_A = zeros(1:2,3,size(slip_ind,3));
slip_ind_cs_B = zeros(1:2,3,size(slip_ind,3));
mprime_data = zeros(length(GB), 8);
mprime_all = zeros(size(slip_ind,3),size(slip_ind,3), length(GB));
GB_legend = cell(length(GB), 1:4);
for igb = 1:1:length(GB)
    clearvars gA gB
    gA = eulers2g(GB(igb).eulerA);
    for ii = 1:1:size(slip_ind,3)
        slip_ind_cs_A(1,:,ii) = gA.' * ...
            millerbravaisplane2cart(slip_ind(1,:,ii), GB(1).ca_ratio_A(1));
        slip_ind_cs_A(2,:,ii) = gA.' * ...
            millerbravaisdir2cart(slip_ind(2,:,ii), GB(1).ca_ratio_A(1));
    end
    
    gB = eulers2g(GB(igb).eulerB);
    for ii = 1:1:size(slip_ind,3)
        slip_ind_cs_B(1,:,ii) = gB.' * ...
            millerbravaisplane2cart(slip_ind(1,:,ii), GB(1).ca_ratio_A(1));
        slip_ind_cs_B(2,:,ii) = gB.' * ...
            millerbravaisdir2cart(slip_ind(2,:,ii), GB(1).ca_ratio_A(1));
    end
    
    %% Calculation of mprime for all slip systems
    for ii = 1:1:size(slip_ind,3)
        for jj = 1:1:size(slip_ind,3)
            mprime_all(ii, jj, igb) = ...
                mprime(slip_ind_cs_A(1,:,jj), slip_ind_cs_A(2,:,jj), ...
                slip_ind_cs_B(1,:,ii), slip_ind_cs_B(2,:,ii));
        end
    end
    
    mprime_data(igb, 1) = max(max(mprime_all(4:6,4:6, igb)));
    mprime_data(igb, 2) = GB(igb).mprime_pripri; % Values from paper
    mprime_data(igb, 3) = max(max(mprime_all(4:6,1:3, igb)));
    mprime_data(igb, 4) = GB(igb).mprime_pribas; % Values from paper
    mprime_data(igb, 5) = max(max(mprime_all(4:6,10:15, igb)));
    mprime_data(igb, 6) = GB(igb).mprime_pripyr_a; % Values from paper
    mprime_data(igb, 7) = max(max(mprime_all(4:6,16:27, igb)));
    mprime_data(igb, 8) = GB(igb).mprime_pripyr_ac; % Values from paper
    
    GB_legend(igb, 1) = {'Prismatic --> Prismatic'};
    GB_legend(igb, 2) = {'Prismatic --> Prismatic'};
    GB_legend(igb, 3) = {'Prismatic --> Pyr1 <a>'};
    GB_legend(igb, 4) = {'Prismatic --> Pyr1 <c+a>'};    
end

%% Plot
if plot_matlab
    %% Window Coordinates Configuration
    scrsize = screenSize;   % Get screen size
    WX = 0.27 * scrsize(3); % X Position (bottom)
    WY = 0.10 * scrsize(4); % Y Position (left)
    WW = 0.60 * scrsize(3); % Width
    WH = 0.40 * scrsize(4); % Height
    
    %% Plot axis setting
    plot_interface = figure('Name', 'mprime',...
        'NumberTitle', 'off',...
        'Position', [WX WY WW WH],...
        'ToolBar', 'figure');
    
    % Set plot using bar
    x_hist = 0.5:1:length(GB);
    x_hist_legend = 0.25:0.25:length(GB);
    h_bar = bar(x_hist, mprime_data(:,:), 1);
    legend(h_bar, 'mprime calculated', 'Values from Guo''s paper');
    set(gca, 'XTick', x_hist_legend-0.125, 'xticklabel', GB_legend');
    ylabel('m prime');
    xticklabel_rotate([],45);
end

%% Export results in a .txt file
save_txt_file(parent_directory, 'Data_guo_2014.txt', mprime_data);
