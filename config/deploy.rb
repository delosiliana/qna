# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, 'qna'
set :repo_url, 'git@github.com:delosiliana/qna.git'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/qna'
set :deploy_user, 'deploy'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', '.env', 'config/secrets.yml', 'config/cable.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
      #execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
