
# -*- coding: utf-8 -*-
# Author::    TAC (tac@tac42.net)

#Setup Apache Spark

USER="vagrant"
SBT_PATH="$HOME/.sbtenv/shims/"

# Download Spark
SPARK_VERSION = "1.2.0"
execute "Download Apache Spark" do
  not_if "test -e $HOME/spark-#{SPARK_VERSION}.tgz"
  command <<-COMMANDS
    wget http://d3kbcqa49mib13.cloudfront.net/spark-#{SPARK_VERSION}.tgz
  COMMANDS
  user "vagrant"
end

# Install Spark
execute "Install Apache Spark" do
  not_if "test -e $HOME/spark-#{SPARK_VERSION}"
  command <<-COMMANDS
    tar xf spark-#{SPARK_VERSION}.tgz
    cd spark-#{SPARK_VERSION}
    #{SBT_PATH}/sbt assembly
  COMMANDS
  user "vagrant"
end
