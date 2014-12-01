% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [string, edit_box] = ...
    set_inputs_boxes(str, pos, val, callback, ratio, parent, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% str : string for the txt box
% pos : position of the txt box
% val : value of the variable to edit in corresponding editable txt box
% callback : callback function or script to assess to the editable txt box
% ratio: ratio betweem string box and edit box
% parent: handle of the parent

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 6
    parent = gcf;
end

if nargin < 5 
    ratio = 0.75;
end

if nargin < 4
    callback = '';
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

string = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'Position', [pos(1) pos(2) pos(3)*ratio pos(4)],...
    'String', [str, ' '],...
    'HorizontalAlignment','right', ...
    'Style', 'text');

edit_box = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'Position', [pos(1)+1.01*(pos(3)*ratio) ...
    pos(2) pos(3)*(1-ratio) pos(4)],...
    'String', val,...
    'Style', 'edit',...
    'Callback', callback);

end