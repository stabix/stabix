% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function time_str = time_string(the_time)
%% Function used to get date and time as a string
% the_time: time to display

if nargin == 0;
    the_time = now;
end

[y, m, d, h, mn, s] = datevec(the_time);
time_str = sprintf('%02ih%02im%02is',h,mn,round(s));

end