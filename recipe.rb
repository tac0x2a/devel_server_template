
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

USER="vagrant"
RBENV_GLOBAL_VER="2.2.0"

############
# PreSetup #
############
execute 'apt-get update' do
  user "root"
  command "apt-get -y update"
end

############
# Packages #
############
packages = %W|aptitude emacs zsh ruby git tmux|
packages.each {|p| package p }

############
# DotFiles #
############
dot_files = %W|zshrc zshrc.mine gitconfig gitignore_global tmux.conf|
dot_files.each do |f|
  remote_file "/home/#{USER}/.#{f}" do
    owner "#{USER}"
    group "#{USER}"
    source "templates/dot.#{f}"
  end
end

########
# Ruby #
########
RBENV_PATH="/home/#{USER}/.rbenv"

# rbenv
git "#{RBENV_PATH}" do
  only_if "find /usr/bin/ -name ruby"
  user "#{USER}"
  repository "git://github.com/sstephenson/rbenv.git"
end

# packages for ruby-build
rb_packages = %W|autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev|
rb_packages.each{|p| package p}

# rbenv-build
git "#{RBENV_PATH}/plugins/ruby-build" do
  only_if "find #{RBENV_PATH}"
  user "#{USER}"
  repository "git://github.com/sstephenson/ruby-build.git"
end

# build
RBENV='export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)" && rbenv'
execute "rbenv install #{RBENV_GLOBAL_VER}" do
  not_if  "#{RBENV} versions | grep '#{RBENV_GLOBAL_VER}'"
  user    "#{USER}"
  command "#{RBENV} install #{RBENV_GLOBAL_VER}"
end

execute "rbenv global #{RBENV_GLOBAL_VER}" do
  only_if "#{RBENV} versions | grep '#{RBENV_GLOBAL_VER}'"
  user    "#{USER}"
  command "#{RBENV} global #{RBENV_GLOBAL_VER}"
end

#############
# PostSetup #
#############
execute 'chsh zsh' do
  only_if "find /bin/ -name zsh"
  user "root"
  command "chsh #{USER} -s /bin/zsh"
end

##########
# Docker #
##########
packages = %W|docker.io|
packages.each {|p| package p }

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

package 'lxc-docker' do
  action :install
  options("-y")
end
