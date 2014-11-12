% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function config_out = configs_merge(config_out, config_to_add)

fns = fieldnames(config_to_add);
for fn_idx = 1:numel(fns)
    fn = fns{fn_idx};
    %if isfield(config_out, fn)
    % update fields with user config
    config_out.(fn) = config_to_add.(fn);
    %else
    %    warning('User config field "%s" not found\n', fn);
    %end
end

end
