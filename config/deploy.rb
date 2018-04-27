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
set :keep_releases, 3

set :shared_paths, ['log', 'tmp/sockets', 'tmp/pids', 'public/uploads']
set :shared_files, ['config/database.yml', 'config/secrets.yml']

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
      # puma
      invoke :'puma:restart'

      # it's for passenger
      # in_path(fetch(:current_path)) do
      #   command %{mkdir -p tmp/}
      #   command %{touch tmp/restart.txt}
      # end
    end

    on :clean do
      command %{log "failed deployment"}
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

task :test do 
  comment %{----->testing...}
  deploy do
    invoke :'puma:start'
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs

# puma settings
set :forward_agent, true
set :stage, 'production'

namespace :puma do 
  desc "Start the application"
  task :start do
    comment %{-----> Start Puma'} 
    in_path("#{fetch(:current_path)}") do
      command %{RAILS_ENV=#{fetch(:stage)} && bin/puma.sh start}
    end
    
  end

  desc "Stop the application"
  task :stop do
    comment %{-----> Stop Puma}
    in_path("#{fetch(:current_path)}") do
      command %{RAILS_ENV=#{fetch(:stage)} && bin/puma.sh stop}
    end
  end

  desc "Restart the application"
  task :restart do
    comment %{-----> Restart Puma}
    in_path("#{fetch(:current_path)}") do
      command %{RAILS_ENV=#{fetch(:stage)} && bin/puma.sh restart}
    end
    
  end
end

