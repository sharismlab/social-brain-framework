# Edit these
set :application, "killerapp"  # Your app name
set :node_file, "app.js" # js or coffee file
set :host, "xxx.xxx.xx.xx" # host IP address 
ssh_options[:keys] = [File.join(ENV["HOME"], ".ec2", "default.pem")]
set :repository, "git@github.com:*/*.git" #your git rep
set :branch, "master" # your git branch

set :user, "root" # your user
set :applicationdir, "/home/#{user}/#{application}"
set :deploy_to, applicationdir

set :deploy_via, :remote_cache
set :git_enable_submodules, false

set :admin_runner, ''
set :application_binary, '' # the full path of binary you want to use to launch your app. It could be sth like '/usr/local/bin/coffee' for coffeescript