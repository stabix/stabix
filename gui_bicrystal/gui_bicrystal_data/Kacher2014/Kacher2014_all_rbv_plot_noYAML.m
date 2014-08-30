% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals given by Kacher et al. (2014): DOI ==> 10.1080/14786435.2013.868942
tabularasa;
installation_mtex = MTEX_check_install;
plot = 1;

%% Loading of GB data
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
for ii = 1:length(GB)
    %% Setting of grains Euler angles when only misorientation angle and mis. axis are given
    GB(ii).eulerA                        = [0, 0, 0];
    GB(ii).Misorientation_axis_uvtw_norm = GB(ii).Misorientation_axis_uvtw/norm(GB(ii).Misorientation_axis_uvtw);
    GB(ii).Misorientation_cartesian_vect = millerbravaisdir2cart(GB(ii).Misorientation_axis_uvtw, 1.5875);
    GB(ii).Misorientation_cart_vect_norm = GB(ii).Misorientation_cartesian_vect/norm(GB(ii).Misorientation_cartesian_vect);
    GB(ii).rot_mat                       = axisang2g(GB(ii).Misorientation_cartesian_vect, GB(ii).Misorientation_angle);
    GB(ii).eulerB                        = g2eulers(GB(ii).rot_mat);
    if installation_mtex == 1
        cs = symmetry('hexagonal');
        axMB = GB(ii).Misorientation_axis_uvtw_norm;
        quatMTEX2(ii) = axis2quat(vector3d(Miller(GB(ii).Misorientation_axis_uvtw(1), GB(ii).Misorientation_axis_uvtw(2), GB(ii).Misorientation_axis_uvtw(4))), GB(ii).Misorientation_angle*degree);
        GB(ii).eulerB2 = (Euler(quatMTEX2(ii), 'Bunge'))*180/pi;
    end
    
    %% Conversion from Bravais-Miller indices to Cartesian notation
    GB(ii).slipA_vec = millerbravaisdir2cart(GB(ii).SlipA_dir_BM, 1.5875)';
    GB(ii).slipB_vec = millerbravaisdir2cart(GB(ii).SlipB_dir_BM, 1.5875)';
    
    %% Residual Burgers Vector
    rbv(ii,1) = residual_Burgers_vector(GB(ii).slipA_vec, GB(ii).slipB_vec, ...
        [0,0,0], GB(ii).eulerB);
    
    rbv(ii, 2) = GB(ii).rbv;
    
    %% Misorientation
    if installation_mtex == 1
        oriA = MTEX_setBX_orientation('hcp', 1.5875, GB(ii).eulerA);
        oriB = MTEX_setBX_orientation('hcp', 1.5875, GB(ii).eulerB);
        oriB2 = MTEX_setBX_orientation('hcp', 1.5875, GB(ii).eulerB2);
        mis(ii,1) = MTEX_getBX_misorientation(oriA, oriB); % MTEX function
        mis(ii,2) = MTEX_getBX_misorientation(oriA, oriB2); % MTEX function
        axisMTEX(ii) = axis(oriA, oriB);
    else
        mis(ii, 1) = NaN;
    end
    mis(ii,3) = misorientation(GB(ii).eulerA, GB(ii).eulerB, 'hcp', 'hcp');
    mis_ax_ang(1:4,ii) = misori_hex(GB(ii).eulerA, GB(ii).eulerB, 24);  % Claudio's function
    mis(ii,4) = mis_ax_ang(4,ii);
    mis(ii,5) = GB(ii).Misorientation_angle;
    
    %% Legend for plot
    GB_legend(ii) = {strcat('GB', num2str(ii))};
    
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
    legend(h_bar, 'MTEX Misor #1', 'MTEX Misor #2', 'Calculated values', 'Claudio''s function', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end
