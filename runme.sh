#!/bin/bash

clear
# What is Saying Hi?
STRING="Hello There!"
#Say Hi!
echo $STRING
echo "Let's get started!"
sleep 2
clear
echo Adding Universe Repo and Updating!;
sleep 2

#Add Universe Repo to allow Java and MariaDB Install
sudo add-apt-repository universe
sudo apt-get update
sleep 2
clear

#Install Java
echo Installing Java!;
sleep 1
sudo apt install default-jdk -y
sleep 2
clear

# Install MariaDB
echo Installing MariaDB!;
sleep 1
sudo apt install mariadb-server -y
sleep 2
clear

#Show MariaDB and Java Versions
echo Checking MariaDB and Java Version
mysql -V
java -version


#Done


