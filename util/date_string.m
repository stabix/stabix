% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function date_str = date_string(the_time)
%% Function used to get date and time as a string
% the_time: time to display

if nargin == 0;
    the_time = now;
end

date_str = datestr(the_time, 'yyyy-mm-dd');

end