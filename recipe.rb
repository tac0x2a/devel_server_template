
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
packages = %W|aptitude emacs zsh ruby git|
packages.each {|p| package p }

############
# DotFiles #
############
dot_files = %W|zshrc zshrc.mine gitconfig gitignore_global|
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
