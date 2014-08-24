% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: Kehiagas1995_all_rbv_plot_noYAML.m 1254 2014-08-20 18:46:55Z d.mercier $
%% Script used to plot all Residual Burgers Vectors calculated for bicrystals
% given by Kehiagas et al. (1995) ==> 10.1016/0956-716X(95)00351-U and Kehiagas et al. (1996) ==> 10.1007/BF00191046
tabularasa;
installation_mtex = MTEX_check_install;
plot = 1;

latt_param_Ti = latt_param('Ti', 'hcp');
e_norm = sqrt(1.5)*latt_param_Ti(3)/10;

%% Loading of GB data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kehiagas et al. (1996)
R4_1_2 = [0.97 0.17 -0.15 -0.06; -0.14 0.97 0.17 0.09; 0.17 -0.15 0.97 -0.03; 0.08 -0.08 0 0.99];

GB(1).Misorientation_angle = 17.2; % in degrees
GB(1).Misorientation_axis_uvtw = [5, 3, -8, 19];
GB(1).SlipA_dir_BM = [1, 1, -2, 0];
GB(1).SlipB_dir_BM = [1, 1, -2, 0];
GB(1).rbv = 3*(norm((1/3)*(GB(1).SlipA_dir_BM)' - R4_1_2*((1/3)*GB(1).SlipB_dir_BM)')); % RBV given in nm in the paper... ==> 0.08nm
GB(1).rbv_norm = e_norm * GB(1).rbv/3;

GB(2).Misorientation_angle = 17.2; % in degrees
GB(2).Misorientation_axis_uvtw = [5, 3, -8, 19];
GB(2).SlipA_dir_BM = [1, 1, -2, 0];
GB(2).SlipB_dir_BM = [1, -2, 1, 0];
GB(2).rbv = 3*norm(((1/3)*GB(2).SlipA_dir_BM)' - R4_1_2*((1/3)*GB(2).SlipB_dir_BM)'); % RBV given in nm in the paper... ==> 0.55nm
GB(2).rbv_norm = e_norm * GB(2).rbv/3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kehiagas et al. (1995)
R4_3_4 = [0.987 -0.065 0.078 0.127; 0.081 0.991 -0.072 -0.079; -0.068 0.074 0.994 -0.048; -0.124 0.091 0.033 0.988];

GB(3).Misorientation_angle = 11.6; % in degrees
GB(3).Misorientation_axis_uvtw = [14, 52, -66, 53];
GB(3).SlipA_dir_BM = [1, 1, -2, 0];
GB(3).SlipB_dir_BM = [1, 1, -2, 0];
GB(3).rbv = 3*norm(((1/3)*GB(3).SlipA_dir_BM)' - R4_3_4*((1/3)*GB(3).SlipB_dir_BM)'); % RBV given in nm in the paper... ==> 0.04nm
GB(3).rbv_norm = e_norm * GB(3).rbv/3;

GB(4).Misorientation_angle = 11.6; % in degrees
GB(4).Misorientation_axis_uvtw = [14, 52, -66, 53];
GB(4).SlipA_dir_BM = [1, 1, -2, 0];
GB(4).SlipB_dir_BM = [1, -2, 1, 0];
GB(4).rbv = 3*norm(((1/3)*GB(4).SlipA_dir_BM)' - R4_3_4*((1/3)*GB(4).SlipB_dir_BM)'); % RBV given in nm in the paper... ==> 0.49nm
GB(4).rbv_norm = e_norm * GB(4).rbv/3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kehiagas et al. (1995)
R4_5_6 = [0.994 0.051 -0.045 0.085; -0.041 0.995 0.047 -0.082; 0.047 -0.045 0.998 -0.002; -0.088 0.078 0.01 0.993];

GB(5).Misorientation_angle = 8.2; % in degrees
GB(5).Misorientation_axis_uvtw = [32, 40, -72, -46];
GB(5).SlipA_dir_BM = [1, 1, -2, 0];
GB(5).SlipB_dir_BM = [1, 1, -2, 0];
GB(5).rbv = 3*norm(((1/3)*GB(5).SlipA_dir_BM)' - R4_5_6*((1/3)*GB(5).SlipB_dir_BM)'); % RBV given in nm in the paper... ==> 0.03nm
GB(5).rbv_norm = e_norm * GB(5).rbv/3;

GB(6).Misorientation_angle = 8.2; % in degrees
GB(6).Misorientation_axis_uvtw = [32, 40, -72, -46];
GB(6).SlipA_dir_BM = [1, 1, -2, 0];
GB(6).SlipB_dir_BM = [1, -2, 1, 0];
GB(6).rbv = 3*norm(((1/3)*GB(6).SlipA_dir_BM)' - R4_5_6*((1/3)*GB(6).SlipB_dir_BM)'); % RBV given in nm in the paper... ==> 0.52nm
GB(6).rbv_norm = e_norm * GB(6).rbv/3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    rbv_raw(ii,1) = residual_Burgers_vector(GB(ii).slipA_vec, GB(ii).slipB_vec, ...
        [0,0,0], GB(ii).eulerB);
    
    rbv(ii,1) = e_norm * rbv_raw(ii,1)/3;
    
    rbv(ii, 2) = GB(ii).rbv_norm;
    
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
    legend(h_bar, 'MTEX Misor #1', 'MTEX Misor #2', 'Calculated values', 'Claudio''s function', 'Values from paper');
    set(gca, 'XTick', x_hist, 'xticklabel', GB_legend);
    xticklabel_rotate([],45);
    ylabel('Misorientation in °');
end
