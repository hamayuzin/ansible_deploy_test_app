set :stage, :production
set :rails_env, 'production'
server 'ip address', user: 'webmaster', roles: %w[web app]
set :ssh_options, keys: [File.expand_path('~/.ssh/hogehoge.pem')]
