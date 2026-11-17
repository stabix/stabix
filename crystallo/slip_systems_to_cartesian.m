function ss_cart = slip_systems_to_cartesian(slip_syst, phase, c_over_a)
%SLIP_SYSTEMS_TO_CARTESIAN Convert plane/direction indices with the lattice metric.
%   Vectors use a = 1, consistently with the existing HCP conversions.
%   Missing slip systems represented by NaNs are preserved.

if strcmp(phase, 'hcp') || strcmp(phase, 'bct') || strcmp(phase, 'fct')
    validateattributes(c_over_a, {'numeric'}, {'real', 'finite', 'scalar', 'positive'});
end

if strcmp(phase, 'hcp')
    ss_cart = zeros(2, 3, size(slip_syst, 3));
    for index = 1:size(slip_syst, 3)
        ss_cart(1,:,index) = millerbravaisplane2cart(...
            slip_syst(1,:,index), c_over_a)';
        ss_cart(2,:,index) = millerbravaisdir2cart(...
            slip_syst(2,:,index), c_over_a)';
    end
else
    ss_cart = slip_syst;
    if strcmp(phase, 'bct') || strcmp(phase, 'fct')
        % Plane normals use the reciprocal lattice; directions use the direct lattice.
        ss_cart(1,3,:) = slip_syst(1,3,:) ./ c_over_a;
        ss_cart(2,3,:) = slip_syst(2,3,:) .* c_over_a;
    end
end
end
