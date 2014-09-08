% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_init_microstructure
%% Function to extract data from TSL files
%% Details about TSL files
% Grain File Type 2
% # Column 1: Integer identifying grain
% # Column 2-4: Average orientation (phi1, PHI, phi2) in degrees
% # Column 5-6: Average Position (x, y) in microns
% # Column 7: Average Image Quality (IQ)
% # Column 8: Average Confidence Index (CI)
% # Column 9: Average Fit (degrees)
% # Column 10: An integer identifying the phase ==> 0 -  Titanium (Alpha)
% # Column 11: Edge grain (1) or interior grain (0)
% # Column 12: Diameter of grain in microns

% Reconstructed Boundary file /!\ Careful, changes with TSL versions! below for 6.2                                                                x axis or TD Direction (Transverse)
% # Column 1-3:    right hand average orientation (Bunge = phi1, PHI, phi2 in radians)       ---->
% # Column 4-6:    left hand average orientation (Bunge = phi1, PHI, phi2 in radians)      y |
% # Column 7:      length (in microns)                                                 or RD |
% # Column 8:      trace angle (in degrees)                                        Reference v
% In column 8, e.g. 0° = GB horizontal(// to x-axis) & 90° = GB vertical (// to y-axis)
% # Column 9-12:   x,y coordinates of endpoints (in microns)
% # Column 13-14:  IDs of right hand and left hand grains (!!! No always true !!!!)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Initialization
colorbar('off');
% Get data from encapsulation
gui = guidata(gcf);

%% Read data from GF2 and RB files
guidata(gcf, gui);
if gui.flag.initialization
    interface_map_read_TSL_data;
end
% Get data from encapsulation
gui = guidata(gcf);

% Set interface when first run of interface or for new data imported
guidata(gcf, gui);
interface_map_setmap_TSL_data;
% Get data from encapsulation
gui = guidata(gcf);
guidata(gcf, gui);

% Read data from map interface
guidata(gcf, gui);
interface_map_mprime_calculator_map_set;
% Get data from encapsulation
gui = guidata(gcf);

%% Fill gui.grains
% Process data from Grain File Type 2 (and also from interface)
GF2 = gui.GF2_struct.data;
sGF2 = size(GF2);
gui.grains = struct();

% Loop to set grains properties (identity, Euler angles, position)
gui.grcen  = NaN(sGF2(1), 6);
materials  = cellstr(num2str((NaN(1,sGF2(1))')));%{['']}%nan(sGF2(1),1);
structures = materials;
slip_defs  = {zeros(1,sGF2(1))};

for ng = 1:sGF2(1)
    ig = GF2(ng,1);      % Identity of the grain
    %if ng ~= ig
    %    warning(sprintf('Grain %i is not at index %i in GF2',ig,ng))
    %end
    
    % gui.grcen = [phase (C1) / grain center (X,Y) (C2-C3) / Euler angles(C4-C6)]
    gui.grcen(ig,1:6) = [GF2(ng,gui.GF2_struct.col_idx.PHASE) ...
        GF2(ng,gui.GF2_struct.col_idx.AVG_POS_XY(1):gui.GF2_struct.col_idx.AVG_POS_XY(2)) ...
        GF2(ng,gui.GF2_struct.col_idx.AVG_ORI(1):gui.GF2_struct.col_idx.AVG_ORI(3))];
    gui.grcen(ig,3)   = -gui.grcen(ig,3);
    
    if isnan(gui.grcen(ng,1)) == 1
        gui.grcen(ng,:) = 0;
    end
    
    % If only 1 phase, index = 0. If 2 phases, indexes are 1 and 2. So, this line of code is to have always for phase 1, index = 1 !
    if gui.grcen(ig,1) == 0
        gui.grcen(ig,1) = 1;
        set(gui.handles.NumPh, 'String', 1);
        gui.grains(ig).phase_num = 1;
    else
        set(gui.handles.NumPh, 'String', 2);
        gui.grains(ig).phase_num = 2;
    end
    
    % Selection of the material and the structure in function of the phase
    if gui.grcen(ig,1) == 1
        ph = 1; materials{ng} = gui.config_data.material1; structures{ng} = gui.config_data.struct1; slip_defs{ng} = gui.config_data.slips_1;
    elseif gui.grcen(ig,1) == 2
        ph = 2; materials{ng} = gui.config_data.material2; structures{ng} = gui.config_data.struct2; slip_defs{ng} = gui.config_data.slips_2;
    end
    
    gui.grains(ig).ID        = ig;
    gui.grains(ig).phase     = ph;
    gui.grains(ig).material  = materials{ng};
    gui.grains(ig).structure = structures{ng};
    gui.grains(ig).eulers    = GF2(ng,gui.GF2_struct.col_idx.AVG_ORI(1):gui.GF2_struct.col_idx.AVG_ORI(3));
    gui.grains(ig).pos_x     = +GF2(ng,gui.GF2_struct.col_idx.AVG_POS_XY(1));
    gui.grains(ig).pos_y     = -GF2(ng,gui.GF2_struct.col_idx.AVG_POS_XY(2));
    if isfield(gui.GF2_struct.col_idx,'EDGE')
        gui.grains(ig).edge_gr   = GF2(ng,gui.GF2_struct.col_idx.EDGE);
    end
    if isfield(gui.GF2_struct.col_idx,'DIAM')
        gui.grains(ig).diameter  = GF2(ng,gui.GF2_struct.col_idx.DIAM);
    end
end

%% Process data from Reconstructed Boundaries File
if isfield(gui.RB_struct, 'data_smoothed')
    RB = gui.RB_struct.data_smoothed;
else
    RB = gui.RB_struct.data;
end
old_sRB = size(RB);

%% Set GB segments (RB from interface_map_init_microstructure)
guidata(gcf, gui);
interface_map_GB_segments_opti;
gui = guidata(gcf); guidata(gcf, gui);

RB = gui.RB_struct.data_smoothed;
sRB = size(RB);

if old_sRB(1) == sRB(1)
    gui.flag.GB_smoothing = 0;
else
    gui.flag.GB_smoothing = 1;
end

%% Set grains and GBs numbers in edit boxes on the GUI
set(gui.handles.GB_totalnumber_value, 'String', num2str(sRB(1)));
set(gui.handles.Grain_totalnumber_value, 'String', num2str(size(GF2,1))); %Different of max(GF2(:,1))

%% Fill gui.GBs
grsA       = NaN(sRB(1),1);
grsB       = NaN(sRB(1),1);
grAphs     = NaN(sRB(1),1);
grBphs     = NaN(sRB(1),1);

ind_9_12   = gui.RB_struct.col_idx.GB_XY;
ind_13_14  = gui.RB_struct.col_idx.GRAIN_ID;

gui.GBs = struct();

for gbnum = 1:sRB(1)
    gui.GBs(gbnum).ID = gbnum;
    grA = RB(gbnum, ind_13_14(2)); grB = RB(gbnum, ind_13_14(1));       % grA = Id. of left Grain of the GB and grB = Id. of right Grain of the GB
    grAcoord = [gui.grcen(grA,2); gui.grcen(grA,3); 0];     % !!! IDs of right hand and left hand grains are not always well respected by TSL !!!
    grBcoord = [gui.grcen(grB,2); gui.grcen(grB,3); 0];
    gbci = [RB(gbnum, ind_9_12(1)); -RB(gbnum, ind_9_12(2)); 0];         % gbci(1) = x / gbci(2) = y / gbci(3) = z : coordinates of the 1st point of GB
    gbcf = [RB(gbnum, ind_9_12(3)); -RB(gbnum, ind_9_12(4)); 0];        % gbcf(1) = x / gbcf(2) = y / gbcf(3) = z : coordinates of the endpoint of GB
    gui.GBs(gbnum).pos_x1 = +RB(gbnum, ind_9_12(1));
    gui.GBs(gbnum).pos_y1 = -RB(gbnum, ind_9_12(2));
    gui.GBs(gbnum).pos_x2 = +RB(gbnum, ind_9_12(3));
    gui.GBs(gbnum).pos_y2 = -RB(gbnum, ind_9_12(4));
    
    %% GB Trace calculation
    gb_vec = gbcf - gbci;                       % Trace of the GB
    gb_vec_norm = (gb_vec/norm(gb_vec));        % Normalization of the trace of the GB
    % Calculation of the GB trace angle
    v1 = gui.COORDSYS_eulers' * gb_vec_norm;
    v2 = [1-0;0-0];
    gb_trace_angle = -180*(atan2(det([v1(1:2),v2]),dot(v1(1:2),v2)))/pi;
    gui.GBs(gbnum).trace_angle = gb_trace_angle;
    
    %% Grains identification
    grgr_vec = grBcoord - grAcoord;
    grgr_vec_norm = grgr_vec/norm(grgr_vec);    % Normalization of the trace of Grain to Grain
    GrAGrB = cross(gb_vec_norm,grgr_vec_norm);
    %GrAGrB_norm = GrAGrB/norm(GrAGrB);
    zvec = gui.COORDSYS_eulers * [0;0;1];
    
    if sign(GrAGrB(3)) ~= sign(zvec)            % Correct : Grain A on the left and Grain B on the right
        grsA(gbnum) = RB(gbnum, ind_13_14(2));
        grsB(gbnum) = RB(gbnum, ind_13_14(1));
    else                                        % Uncorrect ! ==> Error in TSL file ==> Inversion of Grains A and B
        grsA(gbnum) = RB(gbnum, ind_13_14(1));
        grsB(gbnum) = RB(gbnum, ind_13_14(2));
    end
    
    %% Phase of each grain
    grAphs(gbnum) = gui.grcen(grsA(gbnum),1);
    grBphs(gbnum) = gui.grcen(grsB(gbnum),1);
    
    % from
    gui.GBs(gbnum).inclination  = 90;
    gui.GBs(gbnum).trace_length = NaN;
    gui.GBs(gbnum).grainA       = gui.grains(grsA(gbnum)).ID;
    gui.GBs(gbnum).grainB       = gui.grains(grsB(gbnum)).ID;
    
    gui.GF2_struct.data_smoothed  = GF2;
    gui.RB_struct.data_smoothed   = RB;
    
    guidata(gcf, gui);
end
