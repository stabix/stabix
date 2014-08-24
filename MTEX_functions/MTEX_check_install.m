% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: MTEX_check_install.m 1233 2014-08-14 12:28:10Z d.mercier $
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