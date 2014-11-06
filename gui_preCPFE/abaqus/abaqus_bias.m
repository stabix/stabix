% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function varargout = abaqus_bias(n, k, f1, f2, p, varargin)
%% Function used to calculate the bias for a segment (based on bias used in Abaqus)
% n is the number of frequency points at which results are to be given within a frequency interval (discussed above);
% k is one such frequency point (k = 1,2,...n);
% f1 is the lower limit of the frequency interval;
% f2 is the upper limit of the frequency interval;
% fk is the frequency at which the kth results are given;
% p is the bias parameter value; and
% f is the frequency or the logarithm of the frequency, depending on the value used for the frequency scale parameter.

% A bias parameter, p, that is greater than 1.0 provides closer spacing of
% the results points toward the ends of the frequency interval, while values
% of p that are less than 1.0 provide closer spacing toward the middle of
% the frequency interval. The default bias parameter is 3.0 for an
% eigenfrequency interval and 1.0 for a range frequency interval.

% From "Mode-based steady-state dynamic analysis" -  Section 6.3.8 of the
% Abaqus Analysis User’s Manual (Documentation for Abaqus 6.12)

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

if nargin == 0
    commandwindow;
    clc;
    close all;
    testing = 1;
else
    testing = 0;
end

% The bias formula used to calculate the frequency at which results are presented is as follows:
% y = -1+2*(k-1)/(n-1);
% 
% fk = 0.5*(f1+f2) + 0.5*(f2-f1) * (abs(y)^(1/p)) * sign(y);


end