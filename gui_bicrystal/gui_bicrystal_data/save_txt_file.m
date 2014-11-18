% Copyright 2013 Max-Planck-Institut für Eisenforschung GmbH
function save_txt_file(parent_directory, title_txt, data2save)
%% Function used to save results for comparison with data from papers
% Next step is to use this .txt file to generate latex barcharts

% parent_directory: Path where to save the .txt file
% title_txt: Title of the .txt file
% data@save: Data to save in the .txt file

% author: d.mercier@mpie.de

parent_directory_full = fullfile(parent_directory);
cd(parent_directory_full);

data_to_save = zeros(size(data2save,1), 1);
for ii = 1:size(data2save,1)
    data_to_save(ii,1) = ii;
end
data_to_save(:,2) = data2save(:, 2);
data_to_save(:,3) = data2save(:, 1);

fid = fopen(title_txt,'w+');
for ii = 1:size(data_to_save, 1)
    fprintf(fid, '%6.2f %6.2f %6.2f \n',...
        data_to_save(ii, 1), ...
        data_to_save(ii, 2),...
        data_to_save(ii, 3));
end
fclose(fid);

end