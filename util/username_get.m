function config_username = username_get
%% Function to get username
% author : d.mercier@mpie.de

if ismac || isunix
    username = getenv('USER');
else
    username = getenv('USERNAME');
end

config_username = username;

end