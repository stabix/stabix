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
    
    %% Select CS
    warning('If your .cif file is missing, find it on the web or write it by yourself, then save it in the dedicated folder in the MTEX repository.');
    
    listCS = listCIFFile;
    
    [indCS,tf] = listdlg('ListString',listCS,'SelectionMode','single');
    
    CS = loadCIF(char(listCS(indCS)));
    
    %% Set graind calculation  
    ebsdParam.calcgrain = questdlg('Which method to apply for grain calculation?', ...
	'MTEX grains calculation', ...
	'Misorientation angle','Unit cell','Misorientation angle');
    
    if strcmp(ebsdParam.calcgrain, 'Misorientation angle')
        prompt = {'Enter angle value:'};
        title = 'Input';
        dims = [1 35];
        definput = {'5'};
        ebsdParam.calcgrain = inputdlg(prompt,title,dims,definput);
    end
    
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
    
    % create an EBSD variable containing the data
    ebsd = loadEBSD(dname,CS,'interface',ext,specimenRefFrame);
    
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