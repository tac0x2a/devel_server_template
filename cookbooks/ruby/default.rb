
# -*- coding: utf-8 -*-

# Author::    TAC (tac@tac42.net)

RBENV_GLOBAL_VER="2.2.0"
RBENV_USER="vagrant"

package "ruby"

########
# Ruby #
########
RBENV_PATH="/home/#{RBENV_USER}/.rbenv"

# rbenv
git "#{RBENV_PATH}" do
  only_if "find /usr/bin/ -name ruby"
  user "#{RBENV_USER}"
  repository "git://github.com/sstephenson/rbenv.git"
end

# packages for ruby-build
rb_packages = %W|autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev|
rb_packages.each{|p| package p}

# rbenv-build
git "#{RBENV_PATH}/plugins/ruby-build" do
  only_if "find #{RBENV_PATH}"
  user "#{RBENV_USER}"
  repository "git://github.com/sstephenson/ruby-build.git"
end

# build
SH_FILE = '~/.zshrc.mine'
RBENV='export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)" && rbenv'
execute "rbenv install #{RBENV_GLOBAL_VER}" do
  not_if  "#{RBENV} versions | grep '#{RBENV_GLOBAL_VER}'"
  user    "#{RBENV_USER}"
  command "#{RBENV} install #{RBENV_GLOBAL_VER}"
end

execute "rbenv global #{RBENV_GLOBAL_VER}" do
  only_if "#{RBENV} versions | grep '#{RBENV_GLOBAL_VER}'"
  user    "#{RBENV_USER}"
  command "#{RBENV} global #{RBENV_GLOBAL_VER}"
end

execute "set rbenv path" do
  not_if  "grep rbenv '#{SH_FILE}'"
  user    "#{RBENV_USER}"
  command <<-COMMAND
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> #{SH_FILE}
    echo 'eval "$(rbenv init -)"' >> #{SH_FILE}
  COMMAND
end
