% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function eulers = eulstr2euls(eulerstr, varargin)
%% Function used to convert a string containing Euler angles to a (horizontal) matrix
% takes string or sell array of strings
% doing it by regular expressions would be quite difficult
% so we are just stripping away everything thats not a number and sscanf
% the rest;

% eulerstr: Euler angles given as a string

if nargin == 0
    clc
    eulerstr = {'0,0,0'%,
        %               '5.234,3.34,4',
        %               '[+324.3443°, -455.6°, 4,)'
        };
end

if ~iscell(eulerstr)
    eulerstr = cellstr(eulerstr);
end
idx = 0;

for es = eulerstr
    idx = idx+1;
    %match  =  regexp(eul_str, '[?s*.\
    delstr = {'[',']','(',')','°'};
    spstr = {',',';'};
    er = es{1};
    for ds = delstr
        er = strrep(er,ds{1},'');
    end
    er2 = er;
    for sstr = spstr
        er2 = strrep(er2,sstr{1},' ');
    end
    eulers(idx,:)  =  sscanf(er2,'%f %f %f',3)';
    if nargin == 0
        eulers(idx,:);
    end
    
end

