
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

USER="vagrant"

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
packages = %W|aptitude emacs zsh git|
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

#############
# PostSetup #
#############
execute 'chsh zsh' do
  only_if "find /bin/ -name zsh"
  user "root"
  command "chsh #{USER} -s /bin/zsh"
end
