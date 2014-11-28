% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [hmat, pmMat, Struct, pmStruct, listslips, pmlistslips] = ...
    interface_map_material(str, pos, callback_1, callback_2, varargin)
%% Function used to create text boxes and popup menus for material and structures in the GUI
% str : title of the popup menu
% pos : positions of the text box and popup menu
% callback_1 : Script of function to call for the popup menu created for materials
% callback_2 : Script of function to call for the popup menu created for structures

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin < 4
    callback_2 = '';
end

if nargin == 0
    str = 'test';
    pos = [0.25 0.25 0.5 0.25];
    callback_1 = '';
    callback_2 = '';
end

parent = gcf;

[hmat, pmMat] = set_popupmenu(strcat('Material', str), ...
    pos, 13, listMaterial, callback_1);

posS = pos;
posS(2) = pos(2)-0.05;

[Struct, pmStruct] = set_popupmenu(strcat('Structure', str), ...
    posS, 1, listPhase, callback_1);

listslips = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [pos(1) pos(2)-0.1 pos(3) pos(4)],...
    'String', strcat('Slips/Twins',str),...
    'HorizontalAlignment', 'left');

pmlistslips = uicontrol('Parent', parent,...
    'Units', 'normalized',...
    'Style', 'list',...
    'Position', [pos(1) pos(2)-0.18 pos(3) pos(4)+0.06],...
    'min', 1,...
    'max', 100,...
    'BackgroundColor', [0.9 0.9 0.9],...
    'Callback', callback_2);

end