% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function [ebsd, ebsdParam] = mtex_getEBSDdata
%% Import data with MTEX toolbox
% See in http://mtex-toolbox.github.io/

% authors: d.mercier@mpie.de / c.zambaldi@mpie.de

%% File to load
listEBSDFileType = listEBSDFile;

[fname,pname] = uigetfile(listEBSDFileType);
if isequal(fname,0)
    disp('User selected Cancel');
    p = 0;
else
    disp(['User selected ', fullfile(pname,fname)]);
    p = 1;
end

if p
    [filepath,fnameNoext,ext] = fileparts(fname);
    ext(1)=''; % Remove the dot for loadEBSD MTEX function

    %% Number of phases
    prompt = {'Enter the number of phase:'};
    title = 'Input';
    dims = [2 70];
    definput = {'1'};
    ebsdParam.phaseNum = inputdlg(prompt,title,dims,definput);

    %% Select CS
    warning('If your .cif file is missing, find it on the web or write it by yourself, then save it in the dedicated folder in the MTEX repository.');
    listCS = listCIFFile;
    if str2num(char(ebsdParam.phaseNum)) == 1
        [indCS,tf] = listdlg('ListString',listCS,'SelectionMode','single');
        CS = loadCIF(char(listCS(indCS)));
    elseif str2num(char(ebsdParam.phaseNum)) == 2
        [indCS1,tf1] = listdlg('ListString',listCS,'SelectionMode','single');
        [indCS2,tf2] = listdlg('ListString',listCS,'SelectionMode','single');
        CS1 = loadCIF(char(listCS(indCS1)));
        CS2 = loadCIF(char(listCS(indCS2)));
        CS = {CS1, CS2};
    else
        errordlg('Phase number should be between 1 and 2!')
    end

    %% Set grains calculation
    ebsdParam.calcgrain = questdlg('Which method to apply for grain calculation?', ...
        'MTEX grains calculation', ...
        'Misorientation angle','Unit cell','Misorientation angle');

    if strcmp(ebsdParam.calcgrain, 'Misorientation angle')
        prompt = {'Enter minimum misorientation angle value:'};
        title = 'Input to reconstruct the grain structure';
        dims = [2 70];
        definput = {'10'};
        ebsdParam.calcgrain = inputdlg(prompt,title,dims,definput);
    end

    prompt = {'Enter minimum grain size value (number of pixels per grain):'};
    title = 'Input to smooth grains';
    dims = [2 70];
    definput = {'200'};
    ebsdParam.grainSize = inputdlg(prompt,title,dims,definput);

    prompt = {'Enter minimum grain boundary length:'};
    title = 'Input to smooth grains';
    dims = [2 70];
    definput = {'20'};
    ebsdParam.grainBoundarySize = inputdlg(prompt,title,dims,definput);

    %% Set coordinate system
    list_coordsys = listCoordSys;
    [CoordSysVal,tf] = listdlg('ListString',list_coordsys,'SelectionMode','single');


    if CoordSysVal == 1
        xAxisDirection = 'east'; zAxisDirection = 'outOfPlane';
    elseif CoordSysVal == 2
        xAxisDirection = 'north'; zAxisDirection = 'outOfPlane';
    elseif CoordSysVal == 3
        xAxisDirection = 'west'; zAxisDirection = 'outOfPlane';
    elseif CoordSysVal == 4
        xAxisDirection = 'south'; zAxisDirection = 'outOfPlane';
    elseif CoordSysVal == 5
        xAxisDirection = 'east'; zAxisDirection = 'intoPlane';
    elseif CoordSysVal == 6
        xAxisDirection = 'north'; zAxisDirection = 'intoPlane';
    elseif CoordSysVal == 7
        xAxisDirection = 'west'; zAxisDirection = 'intoPlane';
    elseif CoordSysVal == 8
        xAxisDirection = 'south'; zAxisDirection = 'intoPlane';
    end

    % plotting convention
    setMTEXpref('xAxisDirection',xAxisDirection);
    setMTEXpref('zAxisDirection',zAxisDirection);

    %% Set Reference Frame
    specimenRefFrame = questdlg('Which specimen reference frame?', ...
        'Specimen reference frame - Use CRC interface flag', ...
        'convertSpatial2EulerReferenceFrame',...
        'convertEuler2SpatialReferenceFrame','convertEuler2SpatialReferenceFrame');

    %% Import the Data using MTEX wizard

    dname = [pname fname];
    try
        % create an EBSD variable containing the data
        ebsd = EBSD.load(dname,CS,'interface',ext,specimenRefFrame);
    catch
        try
            % create an EBSD variable containing the data
            ebsd = EBSD.load(dname,CS,'interface','ctf',specimenRefFrame);
        catch

        end
    end

else
    ebsd = '';

end

%% Using import wizard (alternative loading solution, but bug for .crc file)
% try
%     import_wizard('EBSD');
% catch err
%     commandwindow;
%     display(err.message);
% end
% uiwait(gcf)