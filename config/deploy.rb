lock '~> 3.11.0'

# TODO: replace app-api with your APP_NAME

set :application, 'map-experimenting-api'
set :repo_url, 'git@github.com:erikjohnmoreno/mapexperimenting-api.git'

set :bundle_without, [:development, :test]
set :ssh_options, { forward_agent: true }
set :log_level, :debug

set :linked_files, %w{puma.rb config/application.yml config/database.yml config/secrets.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

set :keep_releases, 1
set :rails_env, 'production'
set :deploy_to, '/home/deploy/api'
set :conditionally_migrate, true

namespace :deploy do
  desc 'Restarting app'
  task :restart do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute "pkill -9 -f 'rb-fsevent|rails|spring|puma' || echo FAILED"
          execute "cd #{current_path} && RAILS_ENV=production ~/.rvm/bin/rvm 2.6.5@map-experimenting-api do bundle exec puma -t 1:1 -w 1 -d"
        end
      end
    end
  end
  after 'finished', 'restart'

  desc 'Says a message when deployment is completed'
  task :say do
    system("\\say #{fetch(:application)} #{fetch(:stage)} deployment complete")
  end
  after 'finished', 'say'
end
