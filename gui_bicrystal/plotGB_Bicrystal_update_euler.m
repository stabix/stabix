% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [Euler_new] = plotGB_Bicrystal_update_euler(Euler_old, theHandle, ...
    pmEulerUnit_str)
%% Function to update values of Euler angles
% Euler_old = Old Euler angles values (in degree)
% theHandle : handle of the tht box where Euler angles are given in the GUI
% pmEulerUnit_str : unit of Euler angles

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if strcmp(pmEulerUnit_str, 'Degree')
    moduloVal1 = 360;
    moduloVal2 = 180;
    moduloVal3 = 360;
elseif strcmp(pmEulerUnit_str, 'Radian')
    moduloVal1 = 2*pi;
    moduloVal2 = pi;
    moduloVal3 = 2*pi;
end

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
        mod(Euler_new(1),moduloVal1) ...
        mod(Euler_new(2),moduloVal2) ...
        mod(Euler_new(3),moduloVal3)];
    
    set(theHandle, 'String', sprintf('%.3f  %.2f  %.1f', Euler_new));
else
    warning_commwin('Wrong handle...');
end

end