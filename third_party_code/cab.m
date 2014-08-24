% $Id: cab.m 945 2014-05-15 12:49:23Z d.mercier $
function cab(varargin)
%% Function closes all figures currently open EXCEPT for
% See http://www.mathworks.com/matlabcentral/fileexchange/24420-close-all-figures-except-those-listed/content/cab.m
% those listed as arguments.  'cab' stands for 'close all but'.
% 
% Usage:
%       cab figure_handle1 figure_handle2 ...
%       cab(figure_handle1, figure_handle2, ...)
%       cab('last') % or also:  cab last
%
%   - The 'last' option closes all figures except the last one opened.
%   - Calling 'cab' with no arguments is a convenient
%     alternative to 'close all'
%
% Example:
%   figure(5)
%   figure(7)
%   figure(9)
%   figure(11)
%   cab(7, 11)  % or also:  cab 7 11


% all_figs = findall(0, 'type', 'figure');  % Uncomment this to include ALL windows, including those with hidden handles (e.g. GUIs)
all_figs = findobj(0, 'type', 'figure');
figs2keep = [];
for ii = 1:nargin
    if ischar(varargin{ii})
        if strcmp(varargin{ii}, 'last')
            figs2keep = all_figs(1);
            %figs2keep = gcf;
        else
            % In this case, function was called as follows:  cab 1 2 3
            figs2keep = [figs2keep, str2double(varargin{ii})];
        end
    else
        % In this case, function was called as follows:  cab(1, 2, 3)
        figs2keep = [figs2keep, varargin{ii}];
    end
end

delete(setdiff(all_figs, figs2keep))

