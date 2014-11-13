% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function stressTensor = stress_tensor(stressTensor, varargin)
%% Function used to return Frobenius norm and trace of the stress tensor

if nargin < 1
    stressTensor.s11 = 0;
    stressTensor.s12 = 0;
    stressTensor.s13 = 0;
    stressTensor.s21 = 0;
    stressTensor.s22 = 0;
    stressTensor.s23 = 0;
    stressTensor.s31 = 0;
    stressTensor.s32 = 0;
    stressTensor.s33 = 1;    
end

%% Stress tensor is defined using TSL convensions with x down !!!
stressTensor.sigma = [...
    stressTensor.s11, stressTensor.s12, stressTensor.s13;...
    stressTensor.s21, stressTensor.s22, stressTensor.s23;...
    stressTensor.s31, stressTensor.s32, stressTensor.s33];

%% Frobenius norm - unitized stress tensor to get generalized schmid factor
stressTensor.sigma_n = ...
    stressTensor.sigma/norm(stressTensor.sigma,'fro');

%% Trace of the stress tensor
stressTensor.sigma_v = [stressTensor.sigma(1,1) ...
    stressTensor.sigma(2,2) stressTensor.sigma(3,3)]';

end