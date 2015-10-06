% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function xyzlabel(Xstring, Ystring, Zstring, interpreter, varargin)
%% Axis setting
% author: d.mercier@mpie.de

if nargin < 3
    %interpreter = 'none';
    interpreter = 'latex';
end
if nargin < 3
    Zstring = 'Z';
end
if nargin < 2
    Ystring = 'Y';
end
if nargin < 1
    Xstring = 'X';
end

xLabel = xlabel(Xstring);
yLabel = ylabel(Ystring);
zLabel = zlabel(Zstring);
set([xLabel, yLabel, zLabel], 'Interpreter', interpreter);

end