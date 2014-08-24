% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
% $Id: set_default_values_txtbox.m 976 2014-05-26 12:44:02Z d.mercier $
function set_default_values_txtbox (ui_txtbox, def_str)
%% Function used to set default values in case of missing parameters
% uitxtbox : name of the handle of the edit text box
% def_str : default string for the corresponding variable

if nargin < 2
    def_str = '0';
end

if isempty(get(ui_txtbox, 'String')) == 1
    set(ui_txtbox, 'String', def_str);
end

end