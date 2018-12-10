% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function biased_elem = mentat_bias(x0, xN, num_elements, bias, varargin)
%% Function used to calculate the bias for a segment (based on bias used in Marc Mentat)
% x0: First point
% xN: End point
% num_elements: Number of intervals
% bias: Bias
% biased_elem: Seed points for biased elements

% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0
    commandwindow;
    clc;
    close all;
    x0 = 0.075;
    xN = .3;
    num_elements = 5;
    bias = -0.1; % bias in Mentat from -0.5 to 0.5 !
    %The sign of the bias is for the direction
    testing = 1;
else
    testing = 0;
end

% Coordinates of seed points for linearly spaced elements in the range of -1 to 1
t = linspace(-1,1,num_elements+1);

% Coordinates of seed points for linearly spaced elements in the real range of values
t_true = linspace(x0,xN,num_elements+1);

% Calculation of coordinates of seed points for biased elements in the range of -1 to 1
t_star = zeros(num_elements+1,1);
for ii = 1:num_elements+1
    t_star(ii) = t(ii) + bias*(1-(t(ii))^2);
end

% Calculation of coordinates of seed points for biased elements in the real range of values
ratio = zeros(num_elements,1);
biased_elem = zeros(num_elements,1);
biased_elem(1) = t_true(1);
for jj = 1:num_elements
    ratio(jj) = (t_star(jj+1)-t_star(jj))/(t(jj+1)-t(jj));
    biased_elem(jj+1) = ratio(jj) * ...
        (t_true(jj+1)-t_true(jj)) + biased_elem(jj);
end

if testing
    % for x0 = 0.075, xN = .3 and N = 5
    t_ref = [0.075,.1128,.1542,.1992,.2478,0.3];
    disp(biased_elem);
    disp(t_ref);
    plot(biased_elem,zeros(size(biased_elem)),'ob'); hold on;
    plot(t_ref,zeros(size(t_ref)),'sr');
    shg;
end

end