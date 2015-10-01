% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function plotGB_Bicrystal_gbax_title_and_text(no_slip, ...
    shiftXYZA, shiftXYZB)
%% Function to set the title for the bicrystal plot
% no_slip: 1 if no slip to plot and 0 if slipA or slipB defined after calculations
% shiftXYZA: Shift the unit cell in the center of grain A
% shiftXYZB: Shift the unit cell in the center of grain B

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% Set the encapsulation of data
gui = guidata(gcf);

if gui.flag.LaTeX_flag
    idgb  = sprintf('GB \\#%i', gui.GB.GB_Number);
    idgra = sprintf('gr.A \\#%i', gui.GB.GrainA);
    idgrb = sprintf('gr.B \\#%i', gui.GB.GrainB);
    idmis = sprintf('mis = %.1f$^\\circ$', gui.GB.misorientation);
    idcaxis_mis = sprintf('C-mis = %.1f$^\\circ$', gui.GB.caxis_misor);
else
    idgb  = sprintf('GB #%i', gui.GB.GB_Number);
    idgra = sprintf('gr.A #%i', gui.GB.GrainA);
    idgrb = sprintf('gr.B #%i', gui.GB.GrainB);
    idmis = sprintf('mis = %.1f°', gui.GB.misorientation);
    idcaxis_mis = sprintf('C-mis = %.1f°', gui.GB.caxis_misor);
end

%% Selection of m' value
valcase = get(gui.handles.pmchoicecase, 'Value');

if no_slip == 0
    switch(valcase)
        case{1, 2, 3, 4 ,5 ,6}
            if gui.flag.LaTeX_flag
                titleRes = '$m''$ = %.2f';
            else
                titleRes = 'm'' = %.2f';
            end
        case{7}
            if gui.flag.LaTeX_flag
                titleRes = '$m''$($SF$) = %.2f';
            else
                titleRes = 'm''(SF) = %.2f';
            end
        case{8, 9, 10 ,11, 12, 13}
            if gui.flag.LaTeX_flag
                titleRes = '$RBV$ = %.2f';
            else
                titleRes = 'RBV = %.2f';
            end
        case{14}
            if gui.flag.LaTeX_flag
                titleRes = '$RBV$($SF$) = %.2f';
            else
                titleRes = 'RBV(SF) = %.2f';
            end
        case{15, 16, 17, 18, 19, 20}
            if gui.flag.LaTeX_flag
                titleRes = '$N$ = %.2f';
            else
                titleRes = 'N = %.2f';
            end
        case{21}
            if gui.flag.LaTeX_flag
                titleRes = '$N$($SF$) = %.2f';
            else
                titleRes = 'N(SF) = %.2f';
            end
        case{22, 23, 24, 25 ,26, 27}
            if gui.flag.LaTeX_flag
                titleRes = '$LRB$ = %.2f';
            else
                titleRes = 'LRB = %.2f';
            end
        case{28}
            if gui.flag.LaTeX_flag
                titleRes = '$LRB$($SF$) = %.2f';
            else
                titleRes = 'LRB(SF) = %.2f';
            end
        case{29, 30, 31, 32, 33, 34}
            if gui.flag.LaTeX_flag
                titleRes = '$\\lambda$ = %.2f';
            else
                titleRes = 'lambda = %.2f';
            end
        case{35}
            if gui.flag.LaTeX_flag
                titleRes = '$\\lambda$($SF$) = %.2f';
            else
                titleRes = 'lambda(SF) = %.2f';
            end
        case{36}
            if gui.flag.LaTeX_flag
                titleRes = '$SF$(GB) = %.2f';
            else
                titleRes = 'SF(GB) = %.2f';
            end
        case{37}
            if gui.flag.LaTeX_flag
                titleRes = ['$m''$ = %.2f | $RBV$ = %.2f | ', ...
                    '$N$ = %.2f | $LRB$ = %.2f | $\\lambda$ = %.2f'];
            else
                titleRes = ['m'' = %.2f | RBV = %.2f | ', ...
                    'N = %.2f | LRB = %.2f | lambda = %.2f'];
            end
    end
    
    switch(valcase)
        case{1}
            idm = sprintf(titleRes, gui.GB.results.mp_max1);
        case{2}
            idm = sprintf(titleRes, gui.GB.results.mp_max2);
        case{3}
            idm = sprintf(titleRes, gui.GB.results.mp_max3);
        case{4}
            idm = sprintf(titleRes, gui.GB.results.mp_min1);
        case{5}
            idm = sprintf(titleRes, gui.GB.results.mp_min2);
        case{6}
            idm = sprintf(titleRes, gui.GB.results.mp_min3);
        case{7}
            idm = sprintf(titleRes, gui.GB.results.mp_SFmax);
        case{8}
            idm = sprintf(titleRes, gui.GB.results.rbv_max1);
        case{9}
            idm = sprintf(titleRes, gui.GB.results.rbv_max2);
        case{10}
            idm = sprintf(titleRes, gui.GB.results.rbv_max3);
        case{11}
            idm = sprintf(titleRes, gui.GB.results.rbv_min1);
        case{12}
            idm = sprintf(titleRes, gui.GB.results.rbv_min2);
        case{13}
            idm = sprintf(titleRes, gui.GB.results.rbv_min3);
        case{14}
            idm = sprintf(titleRes, gui.GB.results.rbv_SFmax);
        case{15}
            idm = sprintf(titleRes, gui.GB.results.nfact_max1);
        case{16}
            idm = sprintf(titleRes, gui.GB.results.nfact_max2);
        case{17}
            idm = sprintf(titleRes, gui.GB.results.nfact_max3);
        case{18}
            idm = sprintf(titleRes, gui.GB.results.nfact_min1);
        case{19}
            idm = sprintf(titleRes, gui.GB.results.nfact_min2);
        case{20}
            idm = sprintf(titleRes, gui.GB.results.nfact_min3);
        case{21}
            idm = sprintf(titleRes, gui.GB.results.nfact_SFmax);
        case{22}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_max1);
        case{23}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_max2);
        case{24}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_max3);
        case{25}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_min1);
        case{26}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_min2);
        case{27}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_min3);
        case{28}
            idm = sprintf(titleRes, gui.GB.results.LRBfact_SFmax);
        case{29}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_max1);
        case{30}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_max2);
        case{31}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_max3);
        case{32}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_min1);
        case{33}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_min2);
        case{34}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_min3);
        case{35}
            idm = sprintf(titleRes, gui.GB.results.lambdafact_SFmax);
        case{36}
            idm = sprintf(titleRes, gui.GB.results.GB_Schmid_Factor_max);
        case{37}
            idm = sprintf(titleRes, ...
                gui.GB.mprime_specific, gui.GB.rbv_specific, ...
                gui.GB.nfact_specific, gui.GB.LRBfact_specific, ...
                gui.GB.lambdafact_specific);
    end
    
elseif no_slip == 1
    if gui.flag.LaTeX_flag
        idm = sprintf('$m''$ = %s','NaN');
    else
        idm = sprintf('m'' = %s','NaN');
    end
end

%% New title of the plot
if valcase ~= 30
    if gui.flag.LaTeX_flag
        title_String = sprintf('%s $|$ %s $|$ %s $|$ %s $|$ %s $|$ %s ', ...
            idgb, idgra, idgrb, idmis, idcaxis_mis, idm);
    else
        title_String = sprintf('%s | %s | %s | %s | %s | %s ', ...
            idgb, idgra, idgrb, idmis, idcaxis_mis, idm);
    end
else
    if gui.flag.LaTeX_flag
        title_String = sprintf('%s | %s | %s | %s ', ...
            idgb, idmis, idcaxis_mis, idm);
    else
        title_String = sprintf('%s | %s | %s | %s ', ...
            idgb, idmis, idcaxis_mis, idm);
    end
end

hTitle = title(char(title_String), 'color', [0 0 0], 'BackgroundColor', [1 1 1]);

del_if_handle({'h_lblA', 'h_lblB'})

h_txt1 = text(shiftXYZA(1)-gui.GB_geometry.gb_vec(1), ...
    shiftXYZA(2)-gui.GB_geometry.gb_vec(2), -2.5, idgra);

h_txt2 = text(shiftXYZB(1)-gui.GB_geometry.gb_vec(1), ...
    shiftXYZB(2)-gui.GB_geometry.gb_vec(2), -2.5, idgrb);

set([h_txt1, h_txt2], 'HorizontalAlignment', 'center');

if gui.flag.LaTeX_flag
    set([hTitle h_txt1 h_txt2], 'interpreter', 'latex');
else
    set([hTitle h_txt1 h_txt2], 'interpreter', 'none');
end

end