% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals given by Guo et al. (2014): DOI ==> 10.1016/j.actamat.2014.05.015
tabularasa;
%installation_mtex = MTEX_check_install;

GB(1) = load_YAML_BX_example_config_file('Guo2014_Table3Case1.yaml');
GB(2) = load_YAML_BX_example_config_file('Guo2014_Table3Case2.yaml');
GB(3) = load_YAML_BX_example_config_file('Guo2014_Table3Case3.yaml');
GB(4) = load_YAML_BX_example_config_file('Guo2014_Table3Case4.yaml');
GB(5) = load_YAML_BX_example_config_file('Guo2014_Table3Case5.yaml');
GB(6) = load_YAML_BX_example_config_file('Guo2014_Table3Case6.yaml');
GB(7) = load_YAML_BX_example_config_file('Guo2014_Table3Case7.yaml');

slip_ind(:,:,:) = slip_systems;

for ig = 1:1:length(GB)
    clearvars slip_ind_cs_A slip_ind_cs_B mprime_all gA gB
    gA = eulers2g(GB(ig).eulerA);
    for ii = 1:1:size(slip_ind,3)
        slip_ind_cs_A(1,:,ii) = gA * millerbravaisplane2cart(slip_ind(1,:,ii), GB(1).ca_ratio_A(1));
        slip_ind_cs_A(2,:,ii) = gA * millerbravaisdir2cart(slip_ind(2,:,ii), GB(1).ca_ratio_A(1));
    end
    
    gB = eulers2g(GB(ig).eulerB);
    for ii = 1:1:size(slip_ind,3)
        slip_ind_cs_B(1,:,ii) = gB * millerbravaisplane2cart(slip_ind(1,:,ii), GB(1).ca_ratio_A(1));
        slip_ind_cs_B(2,:,ii) = gB * millerbravaisdir2cart(slip_ind(2,:,ii), GB(1).ca_ratio_A(1));
    end
    
    %% Calculation of mprime for all slip systems
    for ii = 1:1:size(slip_ind,3)
        for jj = 1:1:size(slip_ind,3)
            mprime_all(ii, jj) = mprime(slip_ind_cs_A(1,:,ii), slip_ind_cs_A(2,:,ii), slip_ind_cs_B(1,:,jj), slip_ind_cs_B(2,:,jj));
        end
    end
    
    %% Loading of Guo's data
    mprime_data(ig, 1) = max(max(mprime_all(4:6,4:6)));
    mprime_data(ig, 2) = GB(ig).mprime_pripri; % Values from paper
    mprime_data(ig, 3) = max(max(mprime_all(4:6,1:3)));
    mprime_data(ig, 4) = GB(ig).mprime_pribas; % Values from paper
    mprime_data(ig, 5) = max(max(mprime_all(4:6,10:15)));
    mprime_data(ig, 6) = GB(ig).mprime_pripyr_a; % Values from paper
    mprime_data(ig, 7) = max(max(mprime_all(4:6,16:27)));
    mprime_data(ig, 8) = GB(ig).mprime_pripyr_ac; % Values from paper
    
    GB_legend(1,:,ig) = {'Prismatic --> Prismatic'};
    GB_legend(2,:,ig) = {'Prismatic --> Basal'};
    GB_legend(3,:,ig) = {'Prismatic --> Pyr1 <a>'};
    GB_legend(4,:,ig) = {'Prismatic --> Pyr1 <c+a>'};
    
end

%% Legends setting

%GB_legend = [GB_legend_1, GB_legend_2, GB_legend_3, GB_legend_4];

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
set(gca, 'XTick', x_hist_legend-0.125, 'xticklabel', GB_legend);
ylabel('m prime');
xticklabel_rotate([],45);
