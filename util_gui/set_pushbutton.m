% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [pushbutton] = ...
    set_pushbutton(str, pos, callback, parent, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% str : string for the pushbutton
% pos : position of the pushbutton
% callback : callback function or script to assess to the pushbutton
% parent: handle of the parent

% author: d.mercier@mpie.de

if nargin < 4
    parent = gcf;
end

if nargin < 3
    callback = '';
end

if nargin < 2
    pos = [0.9 0.9 0.9];
end
   
if nargin < 1
    str = 'test';
end

pushbutton = uicontrol(...
    'Parent', parent,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', pos,...
    'String', str,...
    'Callback', callback);

end