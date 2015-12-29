
# -*- coding: utf-8 -*-
# Author::    TAC (tac@tac42.net)

# Install ScalaSetup Apache Spark

USER="vagrant"
SH_PROFILE = "~/.zshrc.mine"

SCALA_VERSION = "scala-2.11.0"

############ JVM ############
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


############ Scala ############
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
    echo 'eval "$(scalaenv init -)"' >> #{SH_PROFILE}
  COMMANDS
  user "vagrant"
end

# Install scala
execute "install scala" do
  not_if "test -e ${HOME}/.scalaenv/versions/#{SCALA_VERSION}"
  command <<-COMMANDS
    ${HOME}/.scalaenv/bin/scalaenv install #{SCALA_VERSION}
    ${HOME}/.scalaenv/bin/scalaenv global #{SCALA_VERSION}
  COMMANDS
  user "vagrant"
end

############ sbt ############
# Install SbtEnv
git "\.sbtenv" do
  not_if "test -e ~/.sbtenv"
  repository "git://github.com/mazgi/sbtenv.git"
  user "vagrant"
end

execute "Set scalaenv path " do
  not_if "grep sbtenv #{SH_PROFILE}"
  command <<-COMMANDS
    echo 'export PATH="${HOME}/.sbtenv/bin:${PATH}"' >> #{SH_PROFILE}
    echo 'eval "$(sbtenv init -)"' >> #{SH_PROFILE}
  COMMANDS
  user "vagrant"
end

# Install sbt
SBT_VERSION = "sbt-0.13.9"
execute "install sbt" do
  not_if "test -e ${HOME}/.sbtenv/versions/#{SBT_VERSION}"
  command <<-COMMANDS
    ${HOME}/.sbtenv/bin/sbtenv install #{SBT_VERSION}
    ${HOME}/.sbtenv/bin/sbtenv global #{SBT_VERSION}
  COMMANDS
  user "vagrant"
end
