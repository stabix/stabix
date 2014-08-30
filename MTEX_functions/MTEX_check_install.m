% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function installation_mtex = MTEX_check_install
%% Check if MTEX is installed
% See in http://code.google.com/p/mtex/
% author: d.mercier@mpie.de

try
    check_mtex;
    installation_mtex = 1;
catch
    %warndlg('MTEX not installed or check_mtex not found/failing!');
    warning('MTEX not installed or check_mtex not found/failing!')
    disp('Proceeding without MTEX functionalities...');
    installation_mtex = 0;
end

end