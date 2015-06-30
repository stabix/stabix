% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function align_crop_3DEBSD_dataset(fname_prefix, fpath, maxDataFiles, varargin)
%% Function to load several TSL-OIM .Ang files from 3D EBSD experiment
% and to center/crop dataset

% author: d.mercier@mpie.de

if nargin < 3
    maxDataFiles = 9;
end

if nargin < 2
    fpath = 'D:\Samples\11-TiAl5Sn2.5\2015-06-19_3DEBSD\';
end

if nargin < 1
    fname_prefix = 'b12_scan0';
end

%% Initialization
close all;

%% Loading data
fdata(maxDataFiles) = struct('file', [], 'data', [], 'header', []);
for ii = 1:maxDataFiles
    fname = [fname_prefix, num2str(ii), '.ang'];
    try
        fdata(ii) = read_oim_ang_file(fname, fpath);
    catch
        fdata(ii) = struct('file', [], 'data', [], 'header', []);
    end
    
end

outputRes(maxDataFiles) = struct('euler', [], 'x', [], 'y', [], 'z', [], ...
    'imageQuality', [], 'confidenceIndex', [], 'phaseNumber', [], ...
    'intensity', [], 'fit', []);
for ii = 1:maxDataFiles
    if ~isempty(fdata(ii).data)
        outputRes(ii).euler = fdata(ii).data(:,1:3);
        outputRes(ii).x = fdata(ii).data(:,4);
        outputRes(ii).y = fdata(ii).data(:,5);
        outputRes(ii).imageQuality = fdata(ii).data(:,6);
        outputRes(ii).confidenceIndex = fdata(ii).data(:,7);
        outputRes(ii).phaseNumber = fdata(ii).data(:,8);
        outputRes(ii).intensity = fdata(ii).data(:,9);
        outputRes(ii).fit = fdata(ii).data(:,10);
    end
end

% Check of Euler angles of non-indexed pixel
for ii = 1:maxDataFiles
    for jj = 1:length(outputRes(ii).confidenceIndex)
        if outputRes(ii).confidenceIndex(jj) < 0
            outputRes(ii).euler(jj, :) = [0 ; 0 ; 0];
            outputRes(ii).fit(jj) = 0;
        end
    end
end

%% Get step size and number of columns/rows
for ii = 1:maxDataFiles
    if ~isempty(fdata(ii).header)
        for jj = 1:size(fdata(2).header,2)
            [token_1(:,ii,jj), remain_1(:,ii,jj)] = strtok(fdata(ii).header(jj),':');
            [token_2(:,ii,jj), remain_2(:,ii,jj)] = strtok(remain_1(:,ii,jj), ':');
            if cell2mat(strfind(token_1(:,ii,jj), 'XSTEP'))
                step_x(ii) = str2num(cell2mat(token_2(:,ii,jj)));
            end
            if cell2mat(strfind(token_1(:,ii,jj), 'YSTEP'))
                step_y(ii) = str2num(cell2mat(token_2(:,ii,jj)));
            end
            if cell2mat(strfind(token_1(:,ii,jj), 'NCOLS_ODD'))
                nColOdd(ii) = str2num(cell2mat(token_2(:,ii,jj)));
            end
            if cell2mat(strfind(token_1(:,ii,jj), 'NCOLS_EVEN'))
                nColEven(ii) = str2num(cell2mat(token_2(:,ii,jj)));
            end
            if cell2mat(strfind(token_1(:,ii,jj), 'NROWS'))
                nRows(ii) = str2num(cell2mat(token_2(:,ii,jj)));
            end
        end
    else
        step_x(ii) = NaN;
        step_y(ii) = NaN;
        nColOdd(ii) = NaN;
        nColEven(ii) = NaN;
        nRows(ii) = NaN;
    end
end

%% Check of the step size and number of columns/rows
for ii = 1:maxDataFiles
    if ~isnan(nColOdd(ii)) && ~isnan(nColEven(ii))
        if nColOdd(ii) ~= nColEven(ii)
            commandwindow;
            error('Numbers of odd and even columns are different !');
        end
    end
end

% Remove NaN for mean calculations...
step_x(isnan(step_x))=[];
step_y(isnan(step_y))=[];
nColOdd(isnan(nColOdd))=[];
nColEven(isnan(nColEven))=[];
nRows(isnan(nRows))=[];

tol = eps;
X_step = mean(step_x);
Y_step = mean(step_y);
ColOdd_number = round(mean(nColOdd));
ColEven_number = round(mean(nColEven));
Col_Number = round((ColOdd_number+ColEven_number)/2);
Rows_Number = round(mean(nRows)) - 1;

for ii = 1:size(X_step, 2)
    if ~any(abs(X_step - step_x(ii)) <= tol)
        error('X step size is not constant !');
    end
    if ~any(abs(Y_step - step_y(ii)) <= tol)
        error('Y step size is not constant !');
    end
    if ~any(abs(Col_Number - nColOdd(ii)) <= tol)
        error('Number of odd columns is not constant !');
    end
    if ~any(abs(Col_Number - nColEven(ii)) <= tol)
        error('Number of even columns is not constant !');
    end
    if ~any(abs(Rows_Number - nRows(ii) + 1) <= tol)
        error('Number of rows is not constant !');
    end
end

%% Definition of variable to plot along z-axis
% Misorientation calculation
% initOri = [0;0;0];
% EulerAngles = outputRes(ii).euler(:,:);
%
% for ii = 1:maxDataFiles
%     if ~isempty(fdata(ii).data)
%         for jj = 1:size(EulerAngles,1)
%             outputRes(ii).misor(jj) = misorientation(initOri, outputRes(ii).euler(jj,:));
%         end
%     end
% end

XMax = ((Col_Number*X_step)-X_step);
YMax = ((Rows_Number*Y_step)-Y_step);

x_init = 0:X_step:XMax;
y_init = 0:Y_step:YMax;

% Just for the shift and the plot
for ii = 1:maxDataFiles
    outputRes(ii).z = outputRes(ii).confidenceIndex;
end

for ii = 1:maxDataFiles
    if ~isempty(outputRes(ii).z)
        z_init(:,:,ii) = vec2mat(outputRes(ii).z, Col_Number);
        eul1_init(:,:,ii) = vec2mat(outputRes(ii).euler(:,1), Col_Number);
        eul2_init(:,:,ii) = vec2mat(outputRes(ii).euler(:,2), Col_Number);
        eul3_init(:,:,ii) = vec2mat(outputRes(ii).euler(:,3), Col_Number);
        imageQ_init(:,:,ii) = vec2mat(outputRes(ii).imageQuality, Col_Number);
        confIndex_init(:,:,ii) = vec2mat(outputRes(ii).confidenceIndex, Col_Number);
        phaseNum_init(:,:,ii) = vec2mat(outputRes(ii).phaseNumber, Col_Number);
        intensity_init(:,:,ii) = vec2mat(outputRes(ii).intensity, Col_Number);
        fit_init(:,:,ii) = vec2mat(outputRes(ii).fit, Col_Number);
    else
        z_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        eul1_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        eul2_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        eul3_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        imageQ_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        confIndex_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        phaseNum_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        intensity_init(:,:,ii) = NaN(Rows_Number, Col_Number);
        fit_init(:,:,ii) = NaN(Rows_Number, Col_Number);
    end
end

%% Plot and centering
x_indent = zeros(1,maxDataFiles);
y_indent = zeros(1,maxDataFiles);

% Plot raw maps
for ii = 1:maxDataFiles
    if ~isnan(z_init(:,:,ii))
        f = figure(ii);
        surf(x_init,y_init,z_init(:,:,ii),...
            'FaceColor','interp',...
            'EdgeColor','none')
        view(0,90);
        xlim([0 ; XMax]);
        ylim([0 ; YMax]);
        [x_indent(ii), y_indent(ii)] = ginput(1);
        close;
    else
        x_indent(ii) = NaN;
        y_indent(ii) = NaN;
    end
end

%% Shifting
if ~isnan(z_init(:,:,1))
    delta_x(1) = 0;
    delta_y(1) = 0;
else
    delta_x(1) = NaN;
    delta_y(1) = NaN;
end

% Rounding shift in function of the step size
for ii = 2:maxDataFiles
    x_indent(ii) = X_step*round(x_indent(ii)/X_step);
    y_indent(ii) = Y_step*round(y_indent(ii)/Y_step);
end

for ii = 2:maxDataFiles
    if ~isnan(x_indent(ii-1))
        %comparison slice by slice
        %delta_x(ii) = x_indent(ii) - x_indent(ii-1);
        %delta_y(ii) = y_indent(ii) - y_indent(ii-1);
        %comparison always with original slice
        delta_x(ii) = x_indent(ii) - x_indent(2);
        delta_y(ii) = y_indent(ii) - y_indent(2);
    else
        delta_x(ii) = 0;
        delta_y(ii) = 0;
    end
end

if ~isnan(z_init(:,:,1))
    x_init_mod(1,:) = x_init;
    y_init_mod(1,:) = y_init;
else
    x_init_mod(1,:) = NaN(1,length(x_init(1,:)));
    y_init_mod(1,:) = NaN(1,length(y_init(1,:)));
end

for ii = 2:maxDataFiles
    if ~isnan(delta_x(ii-1))
        x_init_mod(ii,:) = x_init - delta_x(ii);
        y_init_mod(ii,:) = y_init - delta_y(ii);
    else
        x_init_mod(ii,:) = x_init;
        y_init_mod(ii,:) = y_init;
    end
end

% Rounding is important because of residuals obtained after substraction
% of the delta in the step before...
for ii = 2:maxDataFiles
    x_init_mod(ii,:) = X_step*round(x_init_mod(ii,:)/X_step);
    y_init_mod(ii,:) = Y_step*round(y_init_mod(ii,:)/Y_step);
end

% Plot shifted maps
% for ii = 1:maxDataFiles
%     if ~isempty(outputRes(ii).z)
%         f = figure(ii);
%         surf(x_init_mod(ii,:),y_init_mod(ii,:),z_init(:,:,ii),...
%             'FaceColor','interp',...
%             'EdgeColor','none')
%         view(0,90);
%         xlim([0 ; XMax]);
%         ylim([0 ; YMax]);
%     end
% end

%% New center and cropped area
newCenter = [x_indent(2), y_indent(2)];

DX1 = max(delta_x(:));
DY1 = max(delta_y(:));
DX2 = abs(min(delta_x(:)));
DY2 = abs(min(delta_y(:)));

newX = DX2:X_step:max(x_init) - DX1;
newY = DY2:Y_step:max(y_init) - DY1;

newX_min = min(newX);
newX_max = max(newX);
newY_min = min(newY);
newY_max = max(newY);

for ii = 2:maxDataFiles
    clear Llim_x_max Ulim_x_min Llim_y_max Ulim_y_min
    lim_x_min = find(x_init_mod(ii,:) < newX_min);
    lim_x_max = find(x_init_mod(ii,:) > newX_max);
    lim_y_min = find(y_init_mod(ii,:) < newY_min);
    lim_y_max = find(y_init_mod(ii,:) > newY_max);
    
    if isempty(lim_x_min)
        lim_x_min = 0;
    end
    if isempty(lim_x_max)
        lim_x_max = size(x_init_mod(ii,:),2)+1;
    end
    if isempty(lim_y_min)
        lim_y_min = 0;
    end
    if isempty(lim_y_max)
        lim_y_max = size(y_init_mod(ii,:),2)+1;
    end
    
    Llim_x(ii) = max(lim_x_min)+1;
    Ulim_x(ii) = min(lim_x_max)-1;
    Llim_y(ii) = max(lim_y_min)+1;
    Ulim_y(ii) = min(lim_y_max)-1;
    
    z_init_cropped(:,:,ii) = ...
        z_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    
    eul1_init_cropped(:,:,ii) = ...
        eul1_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    eul2_init_cropped(:,:,ii) = ...
        eul2_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    eul3_init_cropped(:,:,ii) = ...
        eul3_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    
    imageQ_init_cropped(:,:,ii) = ...
        imageQ_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    
    confIndex_init_cropped(:,:,ii) = ...
        confIndex_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    
    phaseNum_init_cropped(:,:,ii) = ...
        phaseNum_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    
    intensity_init_cropped(:,:,ii) = ...
        intensity_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
    
    fit_init_cropped(:,:,ii) = ...
        fit_init(Llim_y(ii):Ulim_y(ii),Llim_x(ii):Ulim_x(ii),ii);
end

newX_shifted = newX - newX_min;
newY_shifted = newY - newY_min;
newX_shifted(length(newX_shifted)) = [];
%newY_shifted(length(newY_shifted)) = [];

% Plot cropped maps
% for ii = 2:maxDataFiles
%     if ~isnan(z_init(:,:,ii))
%         f = figure(ii);
%         surf(newX_shifted,newY_shifted,z_init_cropped(:,:,ii),...
%             'FaceColor','interp',...
%             'EdgeColor','none')
%         view(0,90);
%         xlim([0 ; max(newX_shifted)]);
%         ylim([0 ; max(newY_shifted)]);
%     end
% end

for ii = 1:size(z_init_cropped,1)
    newX_matrix(:,ii) = newX_shifted;
end
for ii = 1:size(z_init_cropped,2)
    newY_matrix(:,ii) = newY_shifted;
end

newY_matrix_inv = newY_matrix';

% Matrix to vector conversion
for ii = 1:maxDataFiles
    shiftedCroppedRes(ii).title = 'Shifted and cropped dataset';
    shiftedCroppedRes(ii).user = 'D.Mercier';
    shiftedCroppedRes(ii).x_step = X_step;
    shiftedCroppedRes(ii).y_step = Y_step;
    shiftedCroppedRes(ii).n_col_odd = size(z_init_cropped,2);
    shiftedCroppedRes(ii).n_col_even = size(z_init_cropped,2);
    shiftedCroppedRes(ii).n_rows = size(z_init_cropped,1);
    shiftedCroppedRes(ii).eul_ang(:,1) = reshape(eul1_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).eul_ang(:,2) = reshape(eul2_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).eul_ang(:,3) = reshape(eul3_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).x_pixel_pos = reshape(newX_matrix(:),[],1);
    shiftedCroppedRes(ii).y_pixel_pos = reshape(newY_matrix_inv(:),[],1);
    shiftedCroppedRes(ii).image_quality = reshape(imageQ_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).confidence_index = reshape(confIndex_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).phase_ang = reshape(phaseNum_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).detector_intensity = reshape(intensity_init_cropped(:,:,ii)',[],1);
    shiftedCroppedRes(ii).fit = reshape(fit_init_cropped(:,:,ii)',[],1);
end

%% Generation of TSL-OIM .Ang files
for ii = 1:maxDataFiles
    fname = ['b12_scan0', num2str(ii), '.ang'];
    fname_modified = [fname, '_cropped.ang'];
    fpath_output = fullfile(fpath, 'AlignedCroppedData_DavidRoutine');
    
    write_oim_ang_file(shiftedCroppedRes(ii), fpath_output, fname_modified);
end
end