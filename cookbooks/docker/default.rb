
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

##########
# Docker #
##########
package "docker.io"
package 'lxc-docker' do
  action :install
  options("-y")
end

execute "enable tab-completion of Docker commands in BASH" do
  command <<-COMMANDS
#!/bin/bash
source /etc/bash_completion.d/docker.io
  end
end
execute "install apt-transport-https" do
  command <<-COMMANDS
[ -e /usr/lib/apt/methods/https ] || {
  apt-get update
  apt-get install apt-transport-https
}
  COMMANDS
  only_if "find /etc/bash_completion.d -name docker.io"
end

execute "install apt-transport-https" do
  command <<-COMMANDS
sudo sh -c "wget -qO- https://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
  COMMANDS
end
