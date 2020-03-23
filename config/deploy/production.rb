set :keep_releases, 1
set :branch, 'master'
set :deploy_to, '/home/deploy/api/production'
set :rvm_ruby_version, '2.6.5@mapexperimenting-api'
set :stage, "production"

server '13.250.18.85',
  user: 'deploy',
  roles: %w{web app db}
