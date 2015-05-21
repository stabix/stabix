% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function d_opengl = set_opengl(matlab_opengl, varargin)
%% Importation of data from YAML config file (Matlab settings)
% See in http://de.mathworks.com/help/matlab/ref/opengl.html.
% See also "doc opengl".

% author : d.mercier@mpie.de

if nargin < 1
    matlab_opengl = 'software';
end

%% Setting of OpenGL
if strcmp(matlab_opengl, 'software') && ~ismac  
    opengl software;
    
elseif strcmp(matlab_opengl, 'hardware')
    opengl hardware;
    
elseif strcmp(matlab_opengl, 'autoselect')
    opengl autoselect;
    
end

d_opengl = opengl('data');

end