% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function help_dlgbox(str, str_title, varargin)
%% Function to open a help dialog box
% str : string to write in the dialog box
% str_title : title of the dialog box

if nargin == 0
    str = 'Bonjour';
    str_title = 'Bonjour';
end

if nargin == 0
    str_title = 'Set the title';
end

helpdlg(str, str_title);

end

