% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
%% Script to open an exit dialog box and to save all data as a .mat file before to close all figures
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

