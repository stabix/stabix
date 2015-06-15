% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function warning_commwin(string, beep_flag, varargin)
%% Function used to display a warning in the command window of Matlab
% string: String to display

if nargin < 2
    beep_flag = 0;
end

if nargin < 1
    string = 'Wrong inputs !';
end

commandwindow;
warning(string);
if beep_flag
    beep;
end

end