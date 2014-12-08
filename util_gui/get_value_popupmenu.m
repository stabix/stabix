% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function string_pm = get_value_popupmenu(handle_pm, list_pm)
%% Function to get selection (as a string) from a popupmenu
% handle_pm: Handle of the popupmenu
% list_pm: List used to fill the popupmenu

% author: d.mercier@mpie.de

value_pm = get(handle_pm, 'Value');

if size(value_pm, 2) == 1
    string_pm = list_pm(value_pm, :);
else % In case of multiple selection
    for ii = 1:1:size(value_pm, 2)
        string_pm(ii,:) = list_pm(value_pm(ii));
    end
end

end