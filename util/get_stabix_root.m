function stabix_root = get_stabix_root
stabix_root = getenv('SLIP_TRANSFER_TBX_ROOT');
if isempty(stabix_root)
    msg = 'Run the path_management.m script !';
    errordlg(msg, 'File Error');
    error(msg);
end
