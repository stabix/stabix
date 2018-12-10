% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function biased_elem = abaqus_bias(x0, xN, num_elements, bias, varargin)
%% Function used to calculate the bias for a segment (based on bias used in Abaqus)
% num_elements: is the number of frequency points at which results are to
% be given within a frequency interval (discussed above) (1 to 1e4 in Abaqus)
% x0: First point
% xn: End point
% p: Bias parameter value (1 to 1e6 in Abaqus)
% biased_elem: Seed points for biased elements

% A bias parameter, p, that is greater than 1.0 provides closer spacing of
% the results points toward the ends of the frequency interval, while values
% of p that are comprised between 0 and 1.0 (or less than -1) provide closer spacing
% toward the beginning of the frequency interval. The default bias parameter is 3.0 for an
% eigenfrequency interval and 1.0 for a range frequency interval.

% FIXME: The direction of the bias is not trivial to implement for Abaqus in a Python
% script... Only positive values are used for SX indentation model.

% author: d.mercier@mpie.de

if nargin == 0
    commandwindow;
    clc;
    close all;
    num_elements = 10;
    bias = 2; % or p = -2 to inverse sens of bias
    x0 = 0;
    xN = 10;
    testing = 1;
else
    testing = 0;
end

length = xN - x0;
p = bias; % Abaqus uses "p" for the bias.

% No bias elements created if p is equal to 0 !
if p == 0
    warning_commwin(['Wrong input for the bias value. ' ...
        'Bias value can not be equal to 0.']);
end

ratio = abs(p)^(1/(num_elements-1));

sum_k = zeros(num_elements-2,1);
for ind = 1:num_elements-2
    sum_k(ind) = (1/ratio^ind);
end
sum_k_total = sum(sum_k);

dist = zeros(num_elements,1);
dist(1) = length/((1/abs(p))+1+sum_k_total);
for ii = 2:num_elements
    dist(ii) = dist(ii-1) / ratio;
end

if p < 0
    dist = flipud(dist);
end

biased_elem = zeros(num_elements,1);
biased_elem(1) = x0;
for ii = 2:num_elements
    biased_elem(ii) = biased_elem(ii-1) + dist(ii-1);
end
biased_elem(end+1) = xN;

if testing
    % for p = 2, num_elem = 10 and length = 10
    dist0 = [1.380, 1.278, 1.183, 1.095, 1.014, ...
        0.94, 0.87, 0.81, 0.75, 0.69];
    if p == -2 || p == 0.5
        dist0 = fliplr(dist0);
    end
    f0_bias = zeros(num_elements,1);
    f0_bias(1) = 0;
    for ii = 2:num_elements
        f0_bias(ii) = f0_bias(ii-1) + dist0(ii-1);
    end
    f0_bias(end+1) = xN;
    disp(f0_bias);
    plot(f0_bias, zeros(size(f0_bias)), 'ob'); hold on;
    plot(biased_elem, zeros(size(biased_elem)), 'sr');
    shg;
end

end