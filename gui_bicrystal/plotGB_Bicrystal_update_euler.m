% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Euler_new] = plotGB_Bicrystal_update_euler(Euler_old, theHandle)
%% Function to update values of Euler angles
% Euler_old = Old Euler angles values (in degree)
% theHandle : handle of the tht box where Euler angles are given in the GUI

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if ishandle(theHandle)
    theString = get(theHandle, 'string');
    
    if strcmp(theString,'') ...
            || isempty(theString) ...
            || numel(eulstr2euls(theString)) ~= 3
        Euler_new = Euler_old; % Euler angles of grain from grain file type 2
    else % Euler angles in degrees from the interface (input manually)
        Euler_new = eulstr2euls(theString);
    end
    
    Euler_new = [...
        mod(Euler_new(1),360) ...
        mod(Euler_new(2),180) ...
        mod(Euler_new(3),360)];
    
    set(theHandle, 'String', sprintf('%.3f  %.2f  %.1f', Euler_new));
else
    warning_commwin('Wrong handle...');
end

end