% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function ts = timestamp_make(the_time)
%% Function used to get date and time as a string
% the_time: time to display

% See also function 'datetime.m' in Matlab R2014b

if nargin == 0;
    the_time = now;
end

ts = [date_string(the_time), '_', time_string(the_time)];

end