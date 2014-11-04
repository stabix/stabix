% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function patch2inp(patch_obj, inp_full_path)
%% Writes a Matlab surf or patch into Abaqus INP format
% patch_obj: graphics handle of patch or surf or patch data structure
%            with Faces and Vertices
% inp_full_path: full path (foldername + filename)
%
% author: C. Zambaldi, MPIE, 2011

if nargin < 2
    inp_full_path = fullfile(cd, 'patch2inp_test_export.inp')
end

if nargin == 0
    [X,Y] = meshgrid(-8:.5:8);
    R = sqrt(X.^2 + Y.^2) + eps;
    Z = sin(R)./R;
    figure
    mesh(X,Y,Z)
    patch_obj = surf2patch(X, Y, Z);
    patch2inp(patch_obj, inp_full_path);
    commandwindow
    return
end

if ~ ishandle(patch_obj)
    if isstruct(patch_obj)
        patch_data = struct;
        patch_data.faces = patch_obj.faces;
        patch_data.vertices = patch_obj.vertices;
    else
        error('not a graphics object handle or patch data object');
    end
    
else
    if strcmpi(get(patch_obj, 'Type'), 'Surface')
        patch_data = surf2patch(patch_obj);
    elseif ~ strcmpi(get(patch_obj, 'Type'), 'Patch')
        patch_data = struct;
        patch_data.faces = get(patch, 'Faces');
        patch_data.vertices = get(patch, 'Vertices');
    else
        error('not a patch or surf handle');
    end
end
%patch_data

[PATHSTR, fname, EXT] = fileparts(inp_full_path);
% Write Abaqus input file format for import in Mentat
% 3D Triangles
%*ELEMENT, TYPE=STRI3, ELSET=Eall
%     1,     1,     2,     3
%     2,     2,     3,     4
% see import_abaqus.pdf doc-file of Mentat
%inpname=[fname(1:length(fname)-4),'.inp'];
%fid_inp=fopen(inpname,'w');
fid_inp=fopen(inp_full_path, 'w');
fprintf(fid_inp, '** %s\n', fname);
fprintf(fid_inp, '** Converted to %s by %s\n', fname, mfilename);
%fprintf(fid_inp,'*HEADING
%fprintf(fid_inp,'Model: beam     Date: 10-Mar-1998
fprintf(fid_inp,'*NODE,NSET=NALL\n');
%for i=1:size(nv,1)
%  fprintf(fid_inp,'%5i, %9.4f, %9.4f, %9.4f\n',i,nv(i,:))
%end
for i=1:size(patch_data.vertices,1)
    fprintf(fid_inp,'%5i, %9.4f, %9.4f, %9.4f\n',i,patch_data.vertices(i,:));
end
nFaces = size(patch_data.faces,1);
if length(patch_data.faces(1,:))==4 % Rectangle, "Quadrilateral"
    %fprintf(fid_inp,'*ELEMENT, TYPE=CAX4, ELSET=Eall\n')
    fprintf(fid_inp, '*ELEMENT, TYPE=CAX4, ELSET=%s\n', fname);
    for i = 1:nFaces
        fprintf(fid_inp,'%5i, %5i, %5i, %5i, %5i\n', i, patch_data.faces(i,:));
    end
elseif length(patch_data.faces(1,:)) == 3 % Triangle
    fprintf(fid_inp, '*ELEMENT, TYPE=STRI3, ELSET=Eall\n');
    for i=1:nFaces
        fprintf(fid_inp, '%5i, %5i, %5i, %5i\n', i, patch_data.faces(i,:));
    end
end
fclose(fid_inp);

end