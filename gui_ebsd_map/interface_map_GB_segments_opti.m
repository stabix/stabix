% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function interface_map_GB_segments_opti
%% Function to reduce the number of GB segments (using angle between segments)
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

gui = guidata(gcf);

RB     = gui.RB_struct.data;
GF2    = gui.GF2_struct.data;
grains = gui.grains;
idx_length      = gui.RB_struct.col_idx.LENGTH;
idx_trace_ang   = gui.RB_struct.col_idx.TRACE_ANGLE;
%                                        TSLv6
RB_p1x = gui.RB_struct.col_idx.GB_XY(1); %  9
RB_p1y = gui.RB_struct.col_idx.GB_XY(2); % 10
RB_p2x = gui.RB_struct.col_idx.GB_XY(3); % 11
RB_p2y = gui.RB_struct.col_idx.GB_XY(4); % 12
RB_grain_id1 = gui.RB_struct.col_idx.GRAIN_ID(1); % 13
RB_grain_id2 = gui.RB_struct.col_idx.GRAIN_ID(2); % 14

gui.tol.Tol_angle = get(gui.handles.scale_gb_segments_bar, 'value');

for gb_segment_numb = 1:1:10
    RB_new = RB;
    RB_new(:,15) = 1;
    sRB = size(RB_new);
    
    for gbnum = 1:1:sRB(1,1)
        vec_gb(:,:,:,gbnum) = [(RB(gbnum,RB_p2x) - RB(gbnum,RB_p1x)); (-RB(gbnum,RB_p2y) + RB(gbnum,RB_p1y)); 0];
        vec_gb_norm(:,:,:,gbnum) = vec_gb(:,:,:,gbnum)/norm(vec_gb(:,:,:,gbnum));
    end
    
    for gbnum = 1:1:sRB(1,1)-1
        cos_segments = dot(vec_gb_norm(:,:,:,gbnum),vec_gb_norm(:,:,:,gbnum+1));
        ang_degree = acos(cos_segments)*180/pi;
        
        if ~isnan(RB_new(gbnum,15))
            if ang_degree < gui.tol.Tol_angle && (RB(gbnum,RB_grain_id1) == RB(gbnum+1,RB_grain_id1)) && (RB(gbnum,RB_grain_id2) == RB(gbnum+1,RB_grain_id2))
                RB_new(gbnum,RB_p2x) = RB(gbnum+1,RB_p2x);
                RB_new(gbnum,RB_p2y) = RB(gbnum+1,RB_p2y);
                RB_new(gbnum+1,15) = NaN;
            elseif ang_degree < gui.tol.Tol_angle && (RB(gbnum, RB_grain_id1) == RB(gbnum+1, RB_grain_id2)) && (RB(gbnum, RB_grain_id2) == RB(gbnum+1, RB_grain_id2))
                RB_new(gbnum,RB_p2x) = RB(gbnum+1,RB_p2x);
                RB_new(gbnum,RB_p2y) = RB(gbnum+1,RB_p2y);
                RB_new(gbnum+1,15) = NaN;
            end
        end
    end
    
    RB_new(any(isnan(RB_new),2),:) = [];
    RB = RB_new;
end

%% Save RB dataset as a structure variable in order to save later this new EBSD map in a OIM reconstructed boundaries file
% Remove empty lines (no grains defined... Error of numbering from TSL software)
grains_cleaned = grains;
empty_elems = arrayfun(@(s) isempty(s.eulers), grains_cleaned);
grains_cleaned(empty_elems) = [];

dataGF2_smoothed = struct();
dataGF2_smoothed.number_of_grains = size(GF2,1);
dataGF2_smoothed.title = strcat('smoothed_GF2_data_from_', ...
    gui.config_map.default_grain_file_type2);

for ng = 1:dataGF2_smoothed.number_of_grains %length(grains)
    dataGF2_smoothed.eul_ang(ng,:)        = [grains_cleaned(ng).eulers];
    dataGF2_smoothed.x_positions(ng,:)    = [grains_cleaned(ng).pos_x];
    dataGF2_smoothed.y_positions(ng,:)    = -[grains_cleaned(ng).pos_y];
    if isfield(grains_cleaned, 'edge_gr')
        dataGF2_smoothed.edge_grain(ng,:)     = [grains_cleaned(ng).edge_gr];
    end
    if isfield(grains_cleaned, 'diameter')
        dataGF2_smoothed.grain_diameter(ng,:) = [grains_cleaned(ng).diameter];
    end
    
    if grains_cleaned(ng).phase_num == 1
        dataGF2_smoothed.phase(ng,:)      = 0;
    else
        dataGF2_smoothed.phase(ng,:)      = [grains_cleaned(ng).phase];
    end
    
end

dataRB_smoothed = struct();
dataRB_smoothed.number_of_grain_boundaries = sRB(1);
dataRB_smoothed.title = strcat('smoothed_RB_data_from_', ...
    gui.config_map.default_reconstructed_boundaries_file);
for ng = 1:max(GF2(:,1))
    if ~isempty(grains(ng).eulers)
        dataRB_smoothed.eul_ang(ng,:) = grains(ng).eulers;
    else
        dataRB_smoothed.eul_ang(ng,:) = [0 0 0];
    end
end
dataRB_smoothed.grain_diameter = 10*ones(sRB(1),1);
dataRB_smoothed.gb_length      = RB(:, idx_length);
dataRB_smoothed.gb_trace_angle = RB(:, idx_trace_ang);
dataRB_smoothed.GBvx(1,:)      = RB(:,RB_p1x);
dataRB_smoothed.GBvy(1,:)      = -RB(:,RB_p1y);
dataRB_smoothed.GBvx(2,:)      = RB(:,RB_p2x);
dataRB_smoothed.GBvy(2,:)      = -RB(:,RB_p2y);
dataRB_smoothed.GB2cells(1,:)  = RB(:,RB_grain_id1);
dataRB_smoothed.GB2cells(2,:)  = RB(:,RB_grain_id2);
dataRB_smoothed.gb_length      = dataRB_smoothed.gb_length';
dataRB_smoothed.gb_trace_angle = dataRB_smoothed.gb_trace_angle';
dataRB_smoothed.GBvx           = dataRB_smoothed.GBvx';
dataRB_smoothed.GBvy           = dataRB_smoothed.GBvy';
dataRB_smoothed.GB2cells       = dataRB_smoothed.GB2cells';

gui.GF2_struct.data_smoothed  = GF2;
gui.RB_struct.data_smoothed   = RB;
gui.GF2_smoothed_struct       = dataGF2_smoothed;
gui.RB_smoothed_struct        = dataRB_smoothed;

guidata(gcf, gui);

end
