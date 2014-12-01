% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [string, popupmenu] = ...
    set_popupmenu(str, pos, val, listpm, callback, parent, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% str : string for the popupmenu
% pos : position of the popupmenu
% val : value of the variable to edit in corresponding popupmenu
% listpm : list to fill the popupmenu
% callback : callback function or script to assess to the popupmenu
% parent: handle of the parent

% authors: d.mercier@mpie.de

if nargin < 6
    parent = gcf;
end

if nargin < 5
    callback = '';
end

if nargin < 4
    listpm = '';
end

if nargin < 3
    val = '';
end

if nargin < 2
    pos = [0.9 0.9 0.9];
end

if nargin < 1
    str = 'test';
end

string = uicontrol(...
    'Parent', parent,...
    'Units', 'normalized',...
    'Style', 'text',...
    'HorizontalAlignment', 'left',...
    'Position', pos,...
    'String', str);

popupmenu = uicontrol(...
    'Parent', parent,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [pos(1) pos(2)-pos(4) pos(3) pos(4)], ...
    'BackgroundColor', [0.9 0.9 0.9],...
    'Value', val,...
    'String', listpm,...
    'Callback', callback);

end