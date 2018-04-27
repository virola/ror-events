require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'events-cal'
set :domain, 'root@45.77.22.76'
set :deploy_to, '/root/wwwroot/ror.deploy'
set :repository, 'git@github.com:virola/ror-events.git'
set :branch, 'master'

set :shared_paths, ['config/database.yml', 'config/application.yml', 'log', 'tmp/sockets', 'tmp/pids', 'public/uploads']

task :remote do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use', 'ruby-2.5.1'
end

task :environment do
  queue! %[source /usr/local/rvm/scripts/rvm]
  queue! %[rvm use ruby-2.5.1]
end

desc "Shows logs."
task :logs do
  in_path("#{fetch(:deploy_to)}/current") do
    command %{tail -f log/production.log} # => cd some/new/path && ls -al
  end
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  
  # 在服务器项目目录的shared中创建log文件夹
  command %{mkdir -p "#{fetch(:shared_path)}/log"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"}

  # 在服务器项目目录的shared中创建config文件夹 下同
  command %{mkdir -p "#{fetch(:shared_path)}/config"}
  command %{chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"}

  command %{touch "#{fetch(:shared_path)}/config/database.yml"}
  command %{touch "#{fetch(:shared_path)}/config/secrets.yml"}

  # puma.rb 配置puma必须得文件夹及文件
  command %{mkdir -p "#{fetch(:deploy_to)}/shared/tmp/pids"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/pids"}

  command %{mkdir -p "#{fetch(:deploy_to)}/shared/tmp/sockets"}
  command %{chmod g+rx,u+rwx "#{fetch(:deploy_to)}/shared/tmp/sockets"}

  command %{touch "#{fetch(:deploy_to)}/shared/config/puma.rb"}
  comment  %{-----> Be sure to edit 'shared/config/puma.rb'.}

  # tmp/sockets/puma.state
  command %{touch "#{fetch(:deploy_to)}/shared/tmp/sockets/puma.state"}
  comment  %{-----> Be sure to edit 'shared/tmp/sockets/puma.state'.}

  # log/puma.stdout.log
  command %{touch "#{fetch(:deploy_to)}/shared/log/puma.stdout.log"}
  comment  %{-----> Be sure to edit 'shared/log/puma.stdout.log'.}

  # log/puma.stdout.log
  command %{touch "#{fetch(:deploy_to)}/shared/log/puma.stderr.log"}
  comment  %{-----> Be sure to edit 'shared/log/puma.stderr.log'.}

  comment  %{-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml'.}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end

    on :clean do
      command %{log "failed deployment"}
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs

# puma settings
set :forward_agent, true
set :app_path, lambda { "#{deploy_to}/#{current_path}" }
set :stage, 'production'

namespace :puma do 
  desc "Start the application"
  task :start do
    queue 'echo "-----> Start Puma"'  
    queue "cd #{app_path} && RAILS_ENV=#{stage} && bin/puma.sh start", :pty => false
  end

  desc "Stop the application"
  task :stop do
    queue 'echo "-----> Stop Puma"'
    queue "cd #{app_path} && RAILS_ENV=#{stage} && bin/puma.sh stop"
  end

  desc "Restart the application"
  task :restart do
    queue 'echo "-----> Restart Puma"'
    queue "cd #{app_path} && RAILS_ENV=#{stage} && bin/puma.sh restart"
  end
end

