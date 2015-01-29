% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function nu = coeff_poisson(C12, C44, varargin)
% C12 and C14 : compliances in TPa
% nu: Poisson's coefficient

% author: d.mercier@mpie.de

% [LEVY 2001] : "Handbook of elastic properties of solids, liquids and
% gases" by M. Levy, H.E. Bass and R.S. Stern (Vol. 2 - Elastic
% Properties of Solids: Theory, Elements, and Compounds, Novel Materials,
% Technological Materials, Alloys, Building Materials)
% Chapter 1 / p. 19
% ISBN-13: 978-0124457607  ISBN-10: 0124457606

if nargin < 2
    compliances = compliance_to_stiffnesse;
    C12 = compliances(2);
    C44 = compliances(5);
end

nu = 1/(2*(1+(C44/C12)));

end