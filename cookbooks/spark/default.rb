
# -*- coding: utf-8 -*-
# Author::    TAC (tac@tac42.net)

#Setup Apache Spark

USER="vagrant"
execute "Add Java Repos" do
  not_if  "java -version"
  command "apt-add-repository ppa:webupd8team/java -y"
  command "apt-get update"
  user    "root"
end

package "oracle-java7-installer"


# Install Scala
execute "Install Scala" do
  not_if "scala -version"
  command <<-COMMANDS
    wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz
    sudo mkdir /usr/local/src/scala
    sudo tar xvf scala-2.10.4.tgz -C /usr/local/src/scala/
    echo 'export SCALA_HOME=/usr/local/src/scala/scala-2.10.4' >> .zshrc.mine
    echo 'export PATH=$SCALA_HOME/bin:$PATH' >> .zshrc.mine
  COMMANDS
  user "vagrant"
end

#install sbt


execute "Install sbt" do
  not_if "sbt"
  command <<-COMMANDS
    wget http://dl.bintray.com/sbt/debian/sbt-0.13.5.deb
    sudo dpkg -i sbt-0.13.5.deb
    sudo aptitude install sbt
  COMMANDS
  user "vagrant"
end


# Download Spark
SPARK_VERSION = "1.2.0"
execute "Install Apache Spark" do
#  not_if "test spark-#{SPARK_VERSION}.tgz"
  command <<-COMMANDS
    wget http://d3kbcqa49mib13.cloudfront.net/spark-#{SPARK_VERSION}.tgz
    tar xf spark-#{SPARK_VERSION}.tgz
    cd spark-#{SPARK_VERSION}
    sbt assembly
  COMMANDS
  user "vagrant"
end


# execute "install scala" do
#   not_if  "java -version"
#   command "apt-add-repository ppa:webupd8team/java -y"
#   user    "root"
# end



# exit



# RBENV_GLOBAL_VER="2.2.0"


# package "ruby"

# ########
# # Ruby #
# ########
# RBENV_PATH="/home/#{RBENV_USER}/.rbenv"

# # rbenv
# git "#{RBENV_PATH}" do
#   only_if "find /usr/bin/ -name ruby"
#   user "#{RBENV_USER}"
#   repository "git://github.com/sstephenson/rbenv.git"
# end

# # packages for ruby-build
# rb_packages = %W|autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev|
# rb_packages.each{|p| package p}

# # rbenv-build
# git "#{RBENV_PATH}/plugins/ruby-build" do
#   only_if "find #{RBENV_PATH}"
#   user "#{RBENV_USER}"
#   repository "git://github.com/sstephenson/ruby-build.git"
# end

# # build
# RBENV='export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)" && rbenv'
# execute "rbenv install #{RBENV_GLOBAL_VER}" do
#   not_if  "#{RBENV} versions | grep '#{RBENV_GLOBAL_VER}'"
#   user    "#{RBENV_USER}"
#   command "#{RBENV} install #{RBENV_GLOBAL_VER}"
# end

# execute "rbenv global #{RBENV_GLOBAL_VER}" do
#   only_if "#{RBENV} versions | grep '#{RBENV_GLOBAL_VER}'"
#   user    "#{RBENV_USER}"
#   command "#{RBENV} global #{RBENV_GLOBAL_VER}"
# end
