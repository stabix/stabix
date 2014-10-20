% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
clear all
clear classes % not included in clear all
close all
commandwindow
clc
delete(findobj(allchild(0), '-regexp', 'Tag', '^Msgbox_'))
