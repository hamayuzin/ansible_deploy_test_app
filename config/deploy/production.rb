set :stage, :production
set :rails_env, 'production'
# server '13.113.100.45', user: 'webmaster', roles: %w[web app db batch ridgepole]
server 'ip address', user: 'webmaster', roles: %w[web app]
# sshでEC２に入るのに必要
set :ssh_options, keys: [File.expand_path('~/.ssh/hogehoge.pem')]
