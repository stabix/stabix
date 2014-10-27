% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function femproc_config_CPFEM_updated
%% Set GUI in function of user configuration

% author: c.zambaldi@mpie.de

gui = guidata(gcf);

% if gui.config_CPFEM.user_setting == 0
%     set(gui.handles.pb_CPFEM_model, 'BackgroundColor', [229/256 20/256 0],...
%         'String', 'No user config. file found !', ...
%         'Callback', '');
% end

if gui.config.CPFEM.python.works
    set(gui.handles.pb_CPFEM_model, 'BackgroundColor', [0.2 0.8 0],...
        'String', 'CPFE  model',...
        'Callback', 'femproc_generate_CPFE_model');
else
    warning('Python not configured correctly')
    set(gui.handles.pb_CPFEM_model, 'BackgroundColor', [229/256 20/256 0],...
        'String', 'No python found or numpy not installed !', ...
        'Callback', 'femproc_select_config_CPFEM');
end

guidata(gcf, gui);

end