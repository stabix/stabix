% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function t_star_true = mentat_bias(x0, xN, N, bias, varargin)
%% Function used to calculate the bias for a segment (based on bias used in Marc Mentat)
% x0 : First point
% xn : End point
% N : Number of intervals
% bias : bias
% authors: c.zambaldi@mpie.de / d.mercier@mpie.de

if nargin == 0
    commandwindow
    clc
    close all
    x0 = 0.075;
    xN = .3;
    N = 5;
    bias = -0.1; % bias in Mentat from -0.5 to 0.5 !
    %The sign of the bias is for the direction
    testing = 1;
else
    testing = 0;
end

% Coordinates of seed points for linearly spaced elements in the range of -1 to 1
t = linspace(-1,1,N+1);

% Coordinates of seed points for linearly spaced elements in the real range of values
t_true = linspace(x0,xN,N+1);

% Calculation of coordinates of seed points for biased elements in the range of -1 to 1
for ii = 1:N+1
    t_star(ii) = t(ii) + bias*(1-(t(ii))^2);
end

% Calculation of coordinates of seed points for biased elements in the real range of values
t_star_true(1) = t_true(1);
for j =1:N
    ratio(j) = (t_star(j+1)-t_star(j))/(t(j+1)-t(j));
    t_star_true(j+1) = ratio(j) * (t_true(j+1)-t_true(j)) + t_star_true(j);
end

if testing
    t_star_true
    t_ref = [0.075,.1128,.1542,.1992,.2478,0.3]
    plot(t_star_true,zeros(size(t_star_true)),'o'); hold on;
    plot(t_ref,zeros(size(t_ref)),'sr');
end