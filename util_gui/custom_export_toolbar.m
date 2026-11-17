function button = custom_export_toolbar(parent)
%% Add a transparent PNG export button to a GUI figure.

toolbar = findall(parent, 'Type', 'uitoolbar');
if isempty(toolbar)
    toolbar = uitoolbar(parent);
else
    toolbar = toolbar(1);
end

[x, y] = meshgrid(1:16);
checker = 0.75 + 0.25 * mod(floor((x-1)/4) + floor((y-1)/4), 2);
icon = repmat(checker, [1 1 3]);
arrow = false(16);
arrow(3:10, 7:10) = true;
for row = 9:13
    arrow(row, row-5:22-row) = true;
end
icon(:,:,1) = icon(:,:,1) .* ~arrow;
icon(:,:,2) = icon(:,:,2) .* ~arrow;
blue = icon(:,:,3);
blue(arrow) = 0.8;
icon(:,:,3) = blue;

button = uipushtool(toolbar, 'CData', icon, ...
    'Tag', 'STABiXExportTransparentPNG', ...
    'TooltipString', 'Export transparent PNG', ...
    'Separator', 'on', ...
    'ClickedCallback', @(source, event) save_figure(pwd, parent, ...
    '-transparent', '-png'));
end
