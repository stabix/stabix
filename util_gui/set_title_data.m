% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function titlegbdata = set_title_data(data, varargin)
%% Function used to set the title of data and files produced for CPFEM
% data : data to save (GB Number)

if nargin == 0
    data = 'NaN';
end

timestamp = timestamp_make;

titlegbdata = strcat(...
        'GB_', data,...
        '_',timestamp);

end