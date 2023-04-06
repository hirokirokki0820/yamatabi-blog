server "13.114.24.138", user: "kobacchi0820", roles: %w{app db web}

set :ssh_options, {
  keys: %w(~/.ssh/yamatabi.pem),
  forward_agent: true,
  auth_methods: %w(publickey),
}
