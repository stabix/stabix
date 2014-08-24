% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: mprime_max_bicrystal.m 657 2014-01-16 10:49:43Z d.mercier $
function [p_max_min_bc] = plotGB_Bicrystal_max_min_values_from_matrix(matrix, phase_A, phase_B, max_min, varargin)
%% Function used to get maximum values of a parameter (e.g. : m' or RBV) from slip-slip matrix
% matrix : slip-slip matrix
% phase_A : phase of grain A
% phase_B : phase of grain B
% max_min: Flag to know if the user want to plot the max or the min values
% of slip transmission parameter

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin == 0
    matrix = magic(66);
    phase_A = 'hcp';
    phase_B = 'hcp';
    max_min = 'max';
end

if strcmp(max_min, 'max') == 1
    if strcmp(phase_A,'hcp') == 1 && strcmp(phase_B,'hcp') == 1
        
        p_max_min_bc(1,1) = max(max(matrix(1:3,1:3))); %Basal-Basal
        p_max_min_bc(1,2) = max(max(matrix(1:3,4:6))); %Basal-Pri1<a>
        p_max_min_bc(1,3) = max(max(matrix(1:3,7:9))); %Basal-Pri2<a>
        p_max_min_bc(1,4) = max(max(matrix(1:3,10:15))); %Basal-Pyr1<a>
        p_max_min_bc(1,5) = max(max(matrix(1:3,16:27))); %Basal-Pyr1<c+a>
        p_max_min_bc(1,6) = max(max(matrix(1:3,28:33))); %Basal-Pyr2<c+a>
        
        p_max_min_bc(2,1) = max(max(matrix(4:6,1:3))); %Pri1<a>-Basal
        p_max_min_bc(2,2) = max(max(matrix(4:6,4:6))); %Pri1<a>-Pri1<a>
        p_max_min_bc(2,3) = max(max(matrix(4:6,7:9))); %Pri1<a>-Pri2<a>
        p_max_min_bc(2,4) = max(max(matrix(4:6,10:15))); %Pri1<a>-Pyr1<a>
        p_max_min_bc(2,5) = max(max(matrix(4:6,16:27))); %Pri1<a>-Pyr1<c+a>
        p_max_min_bc(2,6) = max(max(matrix(4:6,28:33))); %Pri1<a>-Pyr2<c+a>
        
        p_max_min_bc(3,1) = max(max(matrix(7:9,1:3))); %Pri2<a>-Basal
        p_max_min_bc(3,2) = max(max(matrix(7:9,4:6))); %Pri2<a>-Pri1<a>
        p_max_min_bc(3,3) = max(max(matrix(7:9,7:9))); %Pri2<a>-Pri2<a>
        p_max_min_bc(3,4) = max(max(matrix(7:9,10:15))); %Pri2<a>-Pyr1<a>
        p_max_min_bc(3,5) = max(max(matrix(7:9,16:27))); %Pri2<a>-Pyr1<c+a>
        p_max_min_bc(3,6) = max(max(matrix(7:9,28:33))); %Pri2<a>-Pyr2<c+a>
        
        p_max_min_bc(4,1) = max(max(matrix(10:15,1:3))); %Pyr1<a>-Basal
        p_max_min_bc(4,2) = max(max(matrix(10:15,4:6))); %Pyr1<a>-Pri1<a>
        p_max_min_bc(4,3) = max(max(matrix(10:15,7:9))); %Pyr1<a>-Pri2<a>
        p_max_min_bc(4,4) = max(max(matrix(10:15,10:15))); %Pyr1<a>-Pyr1<a>
        p_max_min_bc(4,5) = max(max(matrix(10:15,16:27))); %Pyr1<a>-Pyr1<c+a>
        p_max_min_bc(4,6) = max(max(matrix(10:15,28:33))); %Pyr1<a>-Pyr2<c+a>
        
        p_max_min_bc(5,1) = max(max(matrix(16:27,1:3))); %Pyr1<c+a>-Basal
        p_max_min_bc(5,2) = max(max(matrix(16:27,4:6))); %Pyr1<c+a>-Pri1<a>
        p_max_min_bc(5,3) = max(max(matrix(16:27,7:9))); %Pyr1<c+a>-Pri2<a>
        p_max_min_bc(5,4) = max(max(matrix(16:27,10:15))); %Pyr1<c+a>-Pyr1<a>
        p_max_min_bc(5,5) = max(max(matrix(16:27,16:27))); %Pyr1<c+a>-Pyr1<c+a>
        p_max_min_bc(5,6) = max(max(matrix(16:27,28:33))); %Pyr1<c+a>-Pyr2<c+a>
        
        p_max_min_bc(6,1) = max(max(matrix(28:33,1:3))); %Pyr2<c+a>-Basal
        p_max_min_bc(6,2) = max(max(matrix(28:33,4:6))); %Pyr2<c+a>-Pri1<a>
        p_max_min_bc(6,3) = max(max(matrix(28:33,7:9))); %Pyr2<c+a>-Pri2<a>
        p_max_min_bc(6,4) = max(max(matrix(28:33,10:15))); %Pyr2<c+a>-Pyr1<a>
        p_max_min_bc(6,5) = max(max(matrix(28:33,16:27))); %Pyr2<c+a>-Pyr1<c+a>
        p_max_min_bc(6,6) = max(max(matrix(28:33,28:33))); %Pyr2<c+a>-Pyr2<c+a>
        
    elseif strcmp(phase_A, 'bcc') == 1 && strcmp(phase_B, 'bcc') == 1
        
        p_max_min_bc(1,1) = max(max(matrix(1:12,1:12)));
        p_max_min_bc(1,2) = max(max(matrix(1:12,13:24)));
        p_max_min_bc(1,3) = max(max(matrix(1:12,25:48)));
        
        p_max_min_bc(2,1) = max(max(matrix(13:24,1:12)));
        p_max_min_bc(2,2) = max(max(matrix(13:24,13:24)));
        p_max_min_bc(2,3) = max(max(matrix(13:24,25:48)));
        
        p_max_min_bc(3,1) = max(max(matrix(25:48,1:12)));
        p_max_min_bc(3,2) = max(max(matrix(25:48,13:24)));
        p_max_min_bc(3,3) = max(max(matrix(25:48,25:48)));
        
    elseif strcmp(phase_A, 'fcc') == 1 && strcmp(phase_B, 'fcc') == 1
        
        p_max_min_bc(1,1) = max(max(matrix(1:12,1:12)));
        
    else
        
        p_max_min_bc(1,1) = NaN;
        
    end
    
elseif strcmp(max_min, 'min') == 1
    if strcmp(phase_A,'hcp') == 1 && strcmp(phase_B,'hcp') == 1
        
        p_max_min_bc(1,1) = min(min(matrix(1:3,1:3))); %Basal-Basal
        p_max_min_bc(1,2) = min(min(matrix(1:3,4:6))); %Basal-Pri1<a>
        p_max_min_bc(1,3) = min(min(matrix(1:3,7:9))); %Basal-Pri2<a>
        p_max_min_bc(1,4) = min(min(matrix(1:3,10:15))); %Basal-Pyr1<a>
        p_max_min_bc(1,5) = min(min(matrix(1:3,16:27))); %Basal-Pyr1<c+a>
        p_max_min_bc(1,6) = min(min(matrix(1:3,28:33))); %Basal-Pyr2<c+a>
        
        p_max_min_bc(2,1) = min(min(matrix(4:6,1:3))); %Pri1<a>-Basal
        p_max_min_bc(2,2) = min(min(matrix(4:6,4:6))); %Pri1<a>-Pri1<a>
        p_max_min_bc(2,3) = min(min(matrix(4:6,7:9))); %Pri1<a>-Pri2<a>
        p_max_min_bc(2,4) = min(min(matrix(4:6,10:15))); %Pri1<a>-Pyr1<a>
        p_max_min_bc(2,5) = min(min(matrix(4:6,16:27))); %Pri1<a>-Pyr1<c+a>
        p_max_min_bc(2,6) = min(min(matrix(4:6,28:33))); %Pri1<a>-Pyr2<c+a>
        
        p_max_min_bc(3,1) = min(min(matrix(7:9,1:3))); %Pri2<a>-Basal
        p_max_min_bc(3,2) = min(min(matrix(7:9,4:6))); %Pri2<a>-Pri1<a>
        p_max_min_bc(3,3) = min(min(matrix(7:9,7:9))); %Pri2<a>-Pri2<a>
        p_max_min_bc(3,4) = min(min(matrix(7:9,10:15))); %Pri2<a>-Pyr1<a>
        p_max_min_bc(3,5) = min(min(matrix(7:9,16:27))); %Pri2<a>-Pyr1<c+a>
        p_max_min_bc(3,6) = min(min(matrix(7:9,28:33))); %Pri2<a>-Pyr2<c+a>
        
        p_max_min_bc(4,1) = min(min(matrix(10:15,1:3))); %Pyr1<a>-Basal
        p_max_min_bc(4,2) = min(min(matrix(10:15,4:6))); %Pyr1<a>-Pri1<a>
        p_max_min_bc(4,3) = min(min(matrix(10:15,7:9))); %Pyr1<a>-Pri2<a>
        p_max_min_bc(4,4) = min(min(matrix(10:15,10:15))); %Pyr1<a>-Pyr1<a>
        p_max_min_bc(4,5) = min(min(matrix(10:15,16:27))); %Pyr1<a>-Pyr1<c+a>
        p_max_min_bc(4,6) = min(min(matrix(10:15,28:33))); %Pyr1<a>-Pyr2<c+a>
        
        p_max_min_bc(5,1) = min(min(matrix(16:27,1:3))); %Pyr1<c+a>-Basal
        p_max_min_bc(5,2) = min(min(matrix(16:27,4:6))); %Pyr1<c+a>-Pri1<a>
        p_max_min_bc(5,3) = min(min(matrix(16:27,7:9))); %Pyr1<c+a>-Pri2<a>
        p_max_min_bc(5,4) = min(min(matrix(16:27,10:15))); %Pyr1<c+a>-Pyr1<a>
        p_max_min_bc(5,5) = min(min(matrix(16:27,16:27))); %Pyr1<c+a>-Pyr1<c+a>
        p_max_min_bc(5,6) = min(min(matrix(16:27,28:33))); %Pyr1<c+a>-Pyr2<c+a>
        
        p_max_min_bc(6,1) = min(min(matrix(28:33,1:3))); %Pyr2<c+a>-Basal
        p_max_min_bc(6,2) = min(min(matrix(28:33,4:6))); %Pyr2<c+a>-Pri1<a>
        p_max_min_bc(6,3) = min(min(matrix(28:33,7:9))); %Pyr2<c+a>-Pri2<a>
        p_max_min_bc(6,4) = min(min(matrix(28:33,10:15))); %Pyr2<c+a>-Pyr1<a>
        p_max_min_bc(6,5) = min(min(matrix(28:33,16:27))); %Pyr2<c+a>-Pyr1<c+a>
        p_max_min_bc(6,6) = min(min(matrix(28:33,28:33))); %Pyr2<c+a>-Pyr2<c+a>
        
    elseif strcmp(phase_A, 'bcc') == 1 && strcmp(phase_B, 'bcc') == 1
        
        p_max_min_bc(1,1) = min(min(matrix(1:12,1:12)));
        p_max_min_bc(1,2) = min(min(matrix(1:12,13:24)));
        p_max_min_bc(1,3) = min(min(matrix(1:12,25:48)));
        
        p_max_min_bc(2,1) = min(min(matrix(13:24,1:12)));
        p_max_min_bc(2,2) = min(min(matrix(13:24,13:24)));
        p_max_min_bc(2,3) = min(min(matrix(13:24,25:48)));
        
        p_max_min_bc(3,1) = min(min(matrix(25:48,1:12)));
        p_max_min_bc(3,2) = min(min(matrix(25:48,13:24)));
        p_max_min_bc(3,3) = min(min(matrix(25:48,25:48)));
        
    elseif strcmp(phase_A, 'fcc') == 1 && strcmp(phase_B, 'fcc') == 1
        
        p_max_min_bc(1,1) = min(min(matrix(1:12,1:12)));
        
    else
        
        p_max_min_bc(1,1) = NaN;
        
    end
    
end