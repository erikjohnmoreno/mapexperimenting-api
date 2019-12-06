set :branch, 'master'

server '10.0.2.255',
  user: 'deploy',
  roles: %w{app db},
  ssh_options: {
    proxy: Net::SSH::Proxy::Command.new('ssh -W %h:%p ec2-user@18.216.194.212')
  }
