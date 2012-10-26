# load 'deploy' if respond_to?(:namespace) # cap2 differentiator

##### Load server-specific variables
task :staging do
  load 'config/deploy/staging'
end

task :production do
  load 'config/deploy/production'
end


set :scm, :git
set :deploy_via, :remote_cache
role :app, host
set :use_sudo, true
default_run_options[:pty] = true
set :ssh_options, {:forward_agent => true}

desc "Echo the server's hostname"
task :echo_hostname do 
  run "echo `hostname`"
end

namespace :deploy do

  before 'deploy:start', 'deploy:npm_install'
  before 'deploy:restart', 'deploy:npm_install'
  before 'deploy:npm_install', 'deploy:symlink_node_folders'
  
  before 'deploy:restart', 'deploy:symlink_config_files'
  before 'deploy:restart', 'deploy:update_viz'
  
  after 'deploy:setup', 'deploy:node_additional_setup'
  
  task :start, :roles => :app, :except => { :no_release => true } do
    # run "#{try_sudo :as => 'root'} start #{application}"
    run "#{try_sudo :as => 'root'} start #{application}"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo :as => 'root'} stop #{application}"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo :as => 'root'} restart #{application}"
  end

  task :create_deploy_to_with_sudo, :roles => :app do
    run "#{try_sudo :as => 'root'} mkdir -p #{deploy_to}"
    run "#{try_sudo :as => 'root'} chown #{admin_runner}:#{admin_runner} #{deploy_to}"
  end

  task :symlink_node_folders, :roles => :app, :except => { :no_release => true } do
    run "ln -s #{applicationdir}/shared/node_modules #{applicationdir}/current/node_modules"
  end

 task :symlink_config_files do
    run "ln -s #{shared_path}/config/db.json #{release_path}/config/"
    run "ln -s #{shared_path}/config/apikeys.json #{release_path}/config/"
  end

  task :node_additional_setup, :roles => :app, :except => { :no_release => true } do
    run "mkdir -p #{applicationdir}/shared/node_modules"
  end
 
  task :npm_install, :roles => :app, :except => { :no_release => true } do
    run "cd #{applicationdir}/current/ #{try_sudo :as => 'root'} sudo npm install"
  end
 
  task :npm_update, :roles => :app, :except => { :no_release => true } do
    run "cd #{applicationdir}/current/ #{try_sudo :as => 'root'} sudo npm update"
  end

  task :update_viz, :roles => :app, :except => { :no_release => true } do
    run "cd #{shared_path}/submodules/seuron_viz && git pull origin master"
    run "ln -s #{shared_path}/submodules/seuron_viz #{release_path}/public/viz/"
  end

  task :write_upstart_script, :roles => :app do
    upstart_script = <<-UPSTART
  description "#{application}"

  start on startup
  stop on shutdown

  script
      # We found $HOME is needed. Without it, we ran into problems
      export HOME="/home/#{admin_runner}"

      cd #{current_path}
      # exec /somepath/myapp/app.js >> /var/log/myapp.log 2>&1

      exec sudo -u root sh -c "#{application_binary} #{current_path}/#{node_file} >> #{shared_path}/log/#{application}.log 2>&1"
  end script
  respawn
UPSTART
  put upstart_script, "/tmp/#{application}_upstart.conf"
    run "#{try_sudo :as => 'root'} mv /tmp/#{application}_upstart.conf /etc/init/#{application}.conf"
  end
end

before 'deploy:setup', 'deploy:create_deploy_to_with_sudo'
after 'deploy:setup', 'deploy:write_upstart_script'