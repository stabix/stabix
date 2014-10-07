function config_username = get_username
%% Function to get username
% author : d.mercier@mpie.de

if ismac
    username = getenv('USER');
else
    username = getenv('USERNAME');
end

config_username = username;

end