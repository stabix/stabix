function topo = read_gwyddion_ascii(filefullpath, varargin)
%% Read topography data as exported by Gwyddion.net software
% Export with header lines !!!

% author: c.zambaldi@mpie.de

if nargin < 1
    TESTING = 1;
    [fname, pname] = uigetfile({'*.txt;*_tip.mat'},'Choose a file');
    cd(pname)
    filefullpath = fullfile(pname, fname);
else
    TESTING = 0;
end

fid = fopen(filefullpath,'rt');
if fid == -1
    error(sprintf('Couldn''t open file at %s',filefullpath));
end

iL = 0; % line number
iY = 0;
topo = struct();

while feof(fid)~=1 % read until end of file
    ln = fgetl(fid);
    iL = iL+1;
    if iL < 5
        if ln(1) == '#'
            if strfind(ln,'# Channel:')
                cln = ln;
                channel = sscanf(cln,'# Channel: %s');
                topo.channel = channel;
            elseif strfind(ln,'Width:')
                wln = ln;
                width = sscanf(wln,'# Width: %f unit');
                topo.width = width;
            elseif strfind(ln,'Height:')
                hln = ln;
                height = sscanf(hln,'# Height: %f unit');
                topo.height = height;
            end
        else
            error(' No header lines found');
        end
    else
        iY = iY + 1;
        data(iY,:) = sscanf(ln,'%e');
    end
    
end
fclose(fid);

if any(strfind(topo.channel,'FEM'))
    topo.FEM_mode = 1;
    %data = flipud(data);
else
    topo.FEM_mode = 0;
end

data = flipud(data);  %  Gwyddion writes data flipped in the Matlab sense
topo.data = data;
topo.nX = size(data,2);
topo.nY = size(data,1);
topo.resX = width/topo.nX;
topo.resY = height/topo.nY;
topo.linX = linspace(-width/2, width/2, topo.nX);
topo.linY = linspace(-height/2, height/2, topo.nY);

%% Datarange
topo.max = max(max(topo.data));
topo.min = min(min(topo.data));
topo.data_range = topo.max - topo.min;

[X,Y] = meshgrid(topo.linX,topo.linY);
topo.X = X;
topo.Y = Y;
topo.X_ori = topo.X;
topo.Y_ori = topo.Y;

if TESTING
    figure;
    topo_plot(topo)
    set(gcf,'name','original data');
end
return
