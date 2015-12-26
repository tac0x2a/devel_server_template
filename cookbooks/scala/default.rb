
# -*- coding: utf-8 -*-
# Author::    TAC (tac@tac42.net)

# Install ScalaSetup Apache Spark

USER="vagrant"
SH_PROFILE = "~/.zshrc.mine"

# Install Java
JAVA_VERSION = "java7"
execute "Add Java Repos" do
  not_if  "sudo aptitude search oracle-#{JAVA_VERSION}-installer | grep '^i.*oracle-#{JAVA_VERSION}-installer'"
  user "vagrant"
  command <<-COMMAND
    sudo apt-add-repository ppa:webupd8team/java -y
    sudo apt-get update
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
  COMMAND
end
package "oracle-#{JAVA_VERSION}-installer"


# Install ScalaEnv
git "\.scalaenv" do
  not_if "test -e ~/.scalaenv"
  repository "git://github.com/mazgi/scalaenv.git"
  user "vagrant"
end
execute "Set scalaenv path " do
  not_if "grep scalaenv #{SH_PROFILE}"
  command <<-COMMANDS
    echo 'export PATH="${HOME}/.scalaenv/bin:${PATH}"' >> #{SH_PROFILE}
  COMMANDS
  user "vagrant"
end

# Install SvtEnv
git "\.sbtenv" do
  not_if "test -e ~/.sbtenv"
  repository "git://github.com/mazgi/sbtenv.git"
  user "vagrant"
end
execute "Set scalaenv path " do
  not_if "grep sbtenv #{SH_PROFILE}"
  command <<-COMMANDS
    echo 'export PATH="${HOME}/.sbtenv/bin:${PATH}"' >> #{SH_PROFILE}
  COMMANDS
  user "vagrant"
end


# Install scala
SCALA_VERSION = "scala-2.11.0"
execute "install scala" do
  not_if "scalaenv versions | grep #{SCALA_VERSION}"
  command <<-COMMANDS
    scalaenv install #{SCALA_VERSION}
  COMMANDS
  user "vagrant"
end


# Install sbt


# execute "Install Scala" do
#   not_if "scala -version"
#   command <<-COMMANDS
#     wget http://www.scala-lang.org/files/archive/scala-2.10.4.tgz
#     sudo mkdir /usr/local/src/scala
#     sudo tar xvf scala-2.10.4.tgz -C /usr/local/src/scala/
#     echo 'export SCALA_HOME=/usr/local/src/scala/scala-2.10.4' >> .zshrc.mine
#     echo 'export PATH=$SCALA_HOME/bin:$PATH' >> .zshrc.mine
#   COMMANDS
#   user "vagrant"
# end

# #install sbt


# execute "Install sbt" do
#   not_if "sbt"
#   command <<-COMMANDS
#     wget http://dl.bintray.com/sbt/debian/sbt-0.13.5.deb
#     sudo dpkg -i sbt-0.13.5.deb
#     sudo aptitude install sbt
#   COMMANDS
#   user "vagrant"
# end


# # Download Spark
# SPARK_VERSION = "1.2.0"
# execute "Install Apache Spark" do
# #  not_if "test spark-#{SPARK_VERSION}.tgz"
#   command <<-COMMANDS
#     wget http://d3kbcqa49mib13.cloudfront.net/spark-#{SPARK_VERSION}.tgz
#     tar xf spark-#{SPARK_VERSION}.tgz
#     cd spark-#{SPARK_VERSION}
#     sbt assembly
#   COMMANDS
#   user "vagrant"
# end


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
