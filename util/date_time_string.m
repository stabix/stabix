% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: date_time_string.m 885 2014-05-07 17:30:56Z d.mercier $
%% Script used to get date and time as a string
function timestamp = date_time_string(date, time, varargin)
% date : Current date
% time : Current time

if nargin == 0
    date = 1;
    time = 1;
end

if nargin == 1
    time = 1;
end

isodate = datestr(now, 'yyyy-mm-dd');
[y, m, d, h, mn, s] = datevec(now);

if h < 10 && mn < 10 && s < 10
    time_str = sprintf('%ih%im%is',h,mn,round(s));
elseif h<10 && s<10
    time_str = sprintf('%ih%2im%is',h,mn,round(s));
elseif mn<10 && s<10
    time_str = sprintf('%ih%2im%2is',h,mn,round(s));
elseif s<10
    time_str = sprintf('%2ih%2im%is',h,mn,round(s));
elseif h<10 && mn<10
    time_str = sprintf('%ih%im%2is',h,mn,round(s));
elseif h<10
    time_str = sprintf('%ih%2im%2is',h,mn,round(s));
elseif mn<10
    time_str = sprintf('%2ih%im%2is',h,mn,round(s));
else
    time_str = sprintf('%2ih%2im%2is',h,mn,round(s));
end

if date == 1 && time == 1
    timestamp = [isodate, '_', time_str];
    timestamp(ismember(timestamp,' ')) = [];
    
elseif date == 0 && time == 0
    timestamp = '_';
    
elseif date == 1 && time == 0
    timestamp = isodate;
    timestamp(ismember(timestamp,' ')) = [];
    
elseif date == 0 && time == 1
    timestamp = time_str;
end

end