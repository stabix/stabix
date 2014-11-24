% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config_CPFEM = preCPFE_config_CPFEM_check(config_CPFEM)
%% Generation of procedure file and material file for CPFE modelling of BX indentation (with GENMAT or DAMASK)
% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

warning('TODO: check valid fields of CPFEM user config settings');

%if ~isfield(gui.config.CPFEM, 'proc_file_path')
%    gui.config.CPFEM.proc_file_path = get_stabix_root();
%end

if ~isfield(config_CPFEM, 'proc_file_path')
    config_CPFEM.proc_file_path = '';
end

if ~isdir(config_CPFEM.proc_file_path)
    %config_CPFEM.proc_file_path = getenv('HOME');
    config_CPFEM.proc_file_path = cd();
    warning_commwin(['Please modify proc_file_path field in ' ...
        'config_CPFEM YAML file !']);
end

end