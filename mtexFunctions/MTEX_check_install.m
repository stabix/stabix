% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function installation_mtex = MTEX_check_install
%% Check if MTEX is installed
% See in http://mtex-toolbox.github.io/

% author: d.mercier@mpie.de

try
    startup_mtex;
    installation_mtex = 1;
catch
    warning_commwin('MTEX not installed or check_mtex not found/failing!');
    disp('Proceeding without MTEX functionalities...');
    disp('Download MTEX here: http://mtex-toolbox.github.io/');
    installation_mtex = 0;
end

end