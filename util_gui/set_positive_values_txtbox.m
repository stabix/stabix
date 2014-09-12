% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function set_positive_values_txtbox (ui_txtbox, def_str)
%% Function used to set positive values in case of missing parameters
% uitxtbox : name of the handle of the edit text box
% def_str : default string for the corresponding variable

if nargin < 2
    def_str = '1';
end

if sign(str2num(get(ui_txtbox, 'String'))) == -1 || sign(str2num(get(ui_txtbox, 'String'))) == 0 || isempty(get(ui_txtbox, 'String')) == 1
    set(ui_txtbox, 'String', def_str);
end

end
