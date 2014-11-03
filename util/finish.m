% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function finish
%% Function to quit

pushbutton = questdlg('Ready to quit?', ...
    'Exit Dialog','Yes','No','No');

switch pushbutton
    case 'Yes',
        disp('Exiting MATLAB');
        %Save variables to test.mat
        save
        close(gcf)
        clear all
        cab();
    case 'No',
        quit cancel;
end

end