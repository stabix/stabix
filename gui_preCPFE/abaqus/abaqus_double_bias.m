% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function f = abaqus_double_bias(num_elements, p, f1, f2, varargin)
%% Function used to calculate the bias for a segment (based on bias used in Abaqus)
% num_elements is the number of frequency points at which results are to be
% given within a frequency interval (discussed above) (1 to 1e4 in Abaqus);
% k is one such frequency point (k = 1,2,...n);
% f1 is the lower limit of the frequency interval;
% f2 is the upper limit of the frequency interval;
% fk is the frequency at which the kth results are given;
% p is the bias parameter value (1 to 1e6 in Abaqus); and
% f is the frequency or the logarithm of the frequency, depending on the value used for the frequency scale parameter.

% A bias parameter, p, that is greater than 1.0 provides closer spacing of
% the results points toward the ends of the frequency interval, while values
% of p that are less than 1.0 provide closer spacing toward the middle of
% the frequency interval. The default bias parameter is 3.0 for an
% eigenfrequency interval and 1.0 for a range frequency interval.

% From "Mode-based steady-state dynamic analysis" -  Section 6.3.8 of the
% Abaqus Analysis User’s Manual (Documentation for Abaqus 6.12)

% author: d.mercier@mpie.de

if nargin == 0
    commandwindow;
    clc;
    close all;
    num_elements = 10;
    p = 2;
    f1 = 0;
    f2 = 100;
    testing = 1;
else
    testing = 0;
end

y = zeros(num_elements,1);
f = zeros(num_elements,1);

for k = 1:num_elements
    y(k) = -1+2*(k-1)/(num_elements-1);
    f(k) = 0.5*(f1+f2) + (0.5*(f2-f1) * (abs(y(k))^(1/p)) * sign(y(k)));
end

if testing
    f0 = linspace(f1, f2, num_elements+1);
    display(f0');
    plot(f0, zeros(size(f0)), 'ob'); hold on;
    plot(f, zeros(size(f)), 'sr');
    shg;
end

end