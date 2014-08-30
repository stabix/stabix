% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [vx vy ridx flag] = neighbooring_edge_of_2cells(x, y, varargin)
%% Function used to give the 2 adjacents cells of an edge in a Voronoi tesselation
% From http://www.mathworks.es/matlabcentral/newsreader/view_thread/323766
% x : x coordinates of cells (vector as a row)
% y : y coordinates of cells (vector as a row)

if nargin == 0
    x=rand(1,20);
    y=rand(1,20);
    flag = true;
else
    flag = false;
end

dt = DelaunayTri([x(:) y(:)]);
[v, reg] = voronoiDiagram(dt);
if length(reg) ~= size(dt.X,1)
    % My 2012B might end up here, which I think is a bug (due to numerical errors)
    disp('voronoiDiagram fails (bug)');
    random_2D_microstructure_data;
end
K = dt.convexHull;

m = length(reg);
efun = @(r) [r; r([2:end 1])]';
rlocfun = @(loc) loc+zeros(size(reg{loc}))';
e = cellfun(efun, reg, 'unif', 0);
e = cat(1,e{:});
r = arrayfun(rlocfun, 1:m, 'unif', 0);
r = cat(1,r{:});
[edges, I, J] = unique(sort(e,2),'rows');
vx = reshape(v(edges,1),size(edges))';
vy = reshape(v(edges,2),size(edges))';
ridx = accumarray(J,r,[],@(x) {x});
bad = cellfun('length',ridx) ~= 2;
if any(bad)
    rbad = ridx{find(bad,1,'first')};
    fprintf('The regions %s share the same edge\n', mat2str(rbad));
    %disp(cellfun(@mat2str,reg(rbad),'unif',0));
    flag = true;
else
    ridx = cat(2,ridx{:}); % indexes of 2 regions separated by each edge
    
    % Deal with infinity vertexes
    X0 = [mean(x); mean(y)];
    X = [x(K); y(K)];
    radius = sqrt(sum(bsxfun(@minus,[vx(:) vy(:)]',X0).^2));
    r2max = max(radius(isfinite(radius)));
    r2 = (2*r2max)^2;
    XM = (X(:,2:end)+X(:,1:end-1)) / 2;
    DX = [+X(2,2:end)-X(2,1:end-1);
        -X(1,2:end)+X(1,1:end-1)];
    XM0 = bsxfun(@minus,XM,X0);
    b = sum(DX.*XM0);
    a = sum(DX.^2);
    c = sum(XM0.^2)-r2;
    tInf = (-b + sqrt(b.^2-a.*c)) ./ a;
    XInf = XM + bsxfun(@times,tInf,DX);
    
    % which edge is infinity
    edgeinf = edges(:,1)==1;
    [~, locinf]=ismember(sort(ridx(:,edgeinf))',sort([K(1:end-1) K(2:end)],2),'rows');
    vx(1,edgeinf) = XInf(1,locinf);
    vy(1,edgeinf) = XInf(2,locinf);
    
    xr = x(ridx);
    yr = y(ridx);
    
    if flag
        figure(1)
        clf
        plot(x,y,'r+',vx,vy,'b-o',xr,yr,'g')
        axis equal
        axis([-0.5 1.5 -0.5 1.5]);
        disp (ridx)
    end
end