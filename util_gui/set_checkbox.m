% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [checkbox] = set_checkbox(str, pos, val, callback, ...
parent, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% str : string for the txt box
% pos : position of the txt box
% val : value of the variable to edit in corresponding editable txt box
% callback : callback function or script to assess to the editable txt box
% parent: handle of the parent

% author: d.mercier@mpie.de

if nargin < 5
    parent = gcf;
end

if nargin < 4
    callback = '';
end

if nargin < 3
    val = 0;
end

if nargin < 2
    pos = [0.9 0.9 0.9];
end
   
if nargin < 1
    str = 'test';
end

checkbox = uicontrol(...
    'Parent', parent,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'Position', pos,...
    'String', str,...
    'Value', val,...
    'Callback', callback);

end