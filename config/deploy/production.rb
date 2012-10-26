# Edit these
set :application, "social-brain-framework"
set :node_file, "sbf.coffee"
set :host, "106.187.52.150"
ssh_options[:keys] = [File.join(ENV["HOME"], ".ec2", "default.pem")]
set :repository, "git@github.com:sharismlab/social-brain-framework.git"
set :branch, "master"

set :user, "brain"
set :applicationdir, "/home/#{user}/#{application}"
set :deploy_to, applicationdir

set :deploy_via, :remote_cache
set :git_enable_submodules, false

set :admin_runner, 'brain'
set :application_binary, '/usr/local/bin/coffee'
