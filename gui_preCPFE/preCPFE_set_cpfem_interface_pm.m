%Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function preCPFE_set_cpfem_interface_pm(handle, solvers_list, solver_used, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% handle: Handle of the BX or SX meshing GUI
% software_version: Version of the FEM software to use

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 3
    max_solver = length(solvers_list);
    set(handle, 'Value', max_solver);
end

for ii = 1:length(solvers_list)
    if strcmp(solver_used, solvers_list(:,ii)) == 1
        set(handle, 'Value', ii);
    end
end

end