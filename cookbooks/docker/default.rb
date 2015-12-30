
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

USER="vagrant"

##########
# Docker #
##########

###########################
# Update your apt sources #
###########################
execute "add gpg key" do
  not_if "sudo apt-key list | grep 'Docker Release Tool'"
  command <<-COMMANDS
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
                     --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
  COMMANDS
  user "#{USER}"
end

execute "clean docker source list for 14.04" do
  command <<-COMMANDS
    sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
  COMMANDS
end

# Verify that apt is pulling from the right repository.
execute "update source list" do
  command <<-COMMANDS
    sudo aptitude update
    sudo apt-cache policy docker-engine
  COMMANDS
  user "#{USER}"
end

execute "remove old package" do
  only_if "sudo aptitude search 'lxc-docker' | grep '^i'"
  command <<-COMMANDS
    sudo aptitude purge lxc-docker
  COMMANDS
  user "#{USER}"
end


###########
# Install #
###########
package "docker-engine"
service "docker" do
  action :start
end


##############
# SetupGroup #
##############
execute "add #{USER} to docker user group" do
  not_if "id #{USER} | grep docker"
  command "sudo usermod -aG docker #{USER}"
  user "#{USER}"
end
