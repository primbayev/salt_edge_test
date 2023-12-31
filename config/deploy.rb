# config valid for current version and patch releases of Capistrano
lock "~> 3.17.3"

set :application, "salt_edge_test"
set :repo_url, "git@github.com:primbayev/salt_edge_test.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/#{fetch :application}"
set :ssh_options,     { forward_agent: false, keys: %w(~/.ssh/id_rsa.pub) }
set :branch,        :main
# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

#
# namespace :puma do
#   desc 'Create Directories for Puma Pids and Socket'
#   task :make_dirs do
#     on roles(:app) do
#       execute "mkdir #{shared_path}/tmp/sockets -p"
#       execute "mkdir #{shared_path}/tmp/pids -p"
#     end
#   end
#
#   before 'deploy:starting', 'puma:make_dirs'
# end
#
# namespace :deploy do
#   desc 'Make sure local git is in sync with remote.'
#   task :check_revision do
#     on roles(:app) do
#       unless `git rev-parse HEAD` == `git rev-parse origin/main`
#         puts 'WARNING: HEAD is not the same as origin/main'
#         puts 'Run `git push` to sync changes.'
#         exit
#       end
#     end
#   end
#
#   desc 'Initial Deploy'
#   task :initial do
#     on roles(:app) do
#       before 'deploy:restart', 'puma:start'
#       invoke 'deploy'
#     end
#   end
#
#   before :starting,     :check_revision
#   after  :finishing,    :compile_assets
#   after  :finishing,    :cleanup
# end
#
# namespace :docker do
#   desc 'run docker'
#   task :compose do
#     on roles(:app) do
#       within "compose" do
#         with rails_env: "#{fetch(:stage)}" do
#           execute "docker-compose -f docker-compose.yml up"
#         end
#       end
#     end
#   end
# end

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
