%Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: femproc_set_cpfem_interface_pm.m 1202 2014-08-05 12:58:13Z d.mercier $
function femproc_set_cpfem_interface_pm(handle, software_version, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% handle: Handle of the BX or SX meshing GUI
% software_version: Version of the FEM software to use

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin == 1
    software_version = 'Mentat_2013.1';
end

if strcmp(software_version, 'Mentat_2008') == 1
    set(handle, 'Value', 1);
elseif strcmp(software_version, 'Mentat_2010') == 1
    set(handle, 'Value', 2);
elseif strcmp(software_version, 'Mentat_2012') == 1
    set(handle, 'Value', 3);
elseif strcmp(software_version, 'Mentat_2013') == 1
    set(handle, 'Value', 4);
elseif strcmp(software_version, 'Mentat_2013.1') == 1
    set(handle, 'Value', 5);
end

end