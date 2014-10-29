% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [string, edit_box] = preCPFE_set_inputs_boxes(str, pos, val, callback, varargin)
%% Function used to create automatically a serir of txt boxes + editable txt boxes in the GUI
% str : string for the txt box
% pos : position of the txt box
% val : value of the variable to edit in corresponding editable txt box
% callback : callback function or script to assess to the editable txt box

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

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

parent = gcf;

string = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'center',...
    'Position', pos,...
    'String', [str, ' '],...
    'HorizontalAlignment','right', ...
    'Style', 'text');

edit_box = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'BackgroundColor', [0.9 0.9 0.9],...
    'Position', [pos(1)+1.01*pos(3) pos(2) .25*pos(3) pos(4)],...
    'String', val,...
    'Style', 'edit',...
    'Callback', callback);

end