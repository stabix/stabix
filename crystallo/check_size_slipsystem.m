% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [size_max_slip_sys, slip_systA, slip_systB] = ...
    check_size_slipsystem(slip_systA, slip_systB)
%% Function to determine/set maximum size of slip systems of 2 grains
% slip_systA: Slip system of grain A
% slip_systB: Slip system of grain B

% To have the same size for slip system matrices when phases are
% different in a given  bicrystal

% author: d.mercier@mpie.de

if size(slip_systA,3) > size(slip_systB,3)
    slip_systB(:,:,size(slip_systB,3)+1:size(slip_systA,3)) ...
        = NaN;
    size_max_slip_sys = size(slip_systA,3);
    
else
    slip_systA(:,:,size(slip_systA,3)+1:size(slip_systB,3)) ...
        = NaN;
    size_max_slip_sys = size(slip_systB,3);
end

end