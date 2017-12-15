# config valid only for current version of Capistrano
lock '3.10.1'

set :application, 'hogehoge'
set :repo_url, 'git@github.com:hamayuzin/ansible_deploy_test_app.git'
set :branch, 'master'
set :deploy_to, '/var/www/hogehoge'
set :keep_releases, 3
set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'
set :rbenv_map_bins, %w[rake gem bundle ruby rails]
set :rbenv_roles, :all
append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'tmp/uploads', 'vendor/bundle', 'public/assets', 'public/uploads/tmp', 'public/sitemaps'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Upload secret files'
  task :upload_secret do
    on roles(:app) do
      execute :mkdir, '-p', shared_path.join('config')

      upload!('config/database.yml', "#{shared_path}/config/database.yml")
      upload!('config/secrets.yml', "#{shared_path}/config/secrets.yml")
    end
  end
  $LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../lib')
end
