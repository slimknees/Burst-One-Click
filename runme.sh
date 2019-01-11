#!/bin/bash

#DEFINE VARS
GREETING="Hello! This script has been configured to download all requirements for the BURSTCOIN wallet and will help you configure it to your liking!"
SQLDONE="/var/log/sqldone.log"
JAVADONE="/var/log/javadone.log"
MARIADBDONE="/var/log/mariadbdone.log"
WGETDONE="/var/log/wgetbdone.log"
UNZIPDONE="/var/log/unzipbdone.log"


clear
#Say Hi
echo $GREETING
sleep 2
clear



#---------------------------------------------------------
#ADD UNIVERSE REPO AND APT UPDATE 

echo Adding Universe Repo and Updating!;
sleep 2

#Add Universe Repo to allow Java and MariaDB Install
add-apt-repository universe
apt-get update
sleep 2
clear






#---------------------------------------------------------
#JAVA INSTALLATION SECTION

if [ ! -f $JAVADONE ]

then

	#Install Java
	echo Installing Java!;
	sleep 1
	apt install default-jdk -y
	touch $JAVADONE
	sleep 2
	clear
else

	echo "Java has already been configured - checking to be sure."
		{
		apt install default-jdk -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
	clear
fi


#---------------------------------------------------------
#MARIADB INSTALLATION SECTION

if [ ! -f $MARIADBDONE ]

then

	# Install MariaDB
	echo Installing MariaDB!;
	sleep 1
	apt install mariadb-server -y
	touch $MARIADBDONE
	sleep 2
	clear
	
else
	echo "MariaDB has already been configured - Checking to be sure."
		{
		apt install mariadb-server -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
fi



#Show MariaDB and Java Versions
clear
echo Checking MariaDB and Java Version
mysql -V
java -version
sleep 2
clear


#---------------------------------------------------------
#SQL CONFIGURATION SECTION

if 
	[ ! -f $SQLDONE ]; 
then

	#Ask user to imput new ROOT password for MySQL
	clear
	echo "In this section you will be changing your root password for MySQL (mariadb) and this script will automate mysql_secure_installation for you to lock down the database server."
	echo "Please enter desired root password for MySQL:"
	read -s sqlrootpw

	#Lock down MySQL by emulating mysql_secure_installation
	echo "Thanks! Now I'm running the scripts to update your MySQL root password, remove temp users, remove test DB, remove remote access for root user."

	{	
		mysql -e "UPDATE mysql.user SET Password = PASSWORD('$sqlrootpw') WHERE User = 'root'"
		mysql -e "DROP USER ''@'localhost'"
		mysql -e "DROP USER ''@'$(hostname)'"
		mysql -e "DROP DATABASE test"
		mysql -e "FLUSH PRIVILEGES"
		mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
		touch $SQLDONE
	} &> /dev/null
	echo "Done! Your mysql root password has been changed, and MySql installation has been secured."

else
	echo "SQL Server has already been configured and secured with a root password. Continuing..."
	clear
fi
sleep 2


#------------------------------------------------------
#INSTALL WGET SECTION

if [ ! -f $WGETDONE ]

then

	#Install wget
	echo Installing wget!;
	sleep 1
	apt install wget -y
	touch $WGETDONE
	sleep 2
	clear
else

	echo "wget has already been installed - checking to be sure."
		{
		apt install wget -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
	clear
fi

#------------------------------------------------------
#INSTALL BRS SECTION

#install unzip
if [ ! -f $UNZIPDONE ]

then

	#Install wget
	echo Installing unzip!;
	sleep 1
	apt install unzip -y
	touch $UNZIPDONE
	sleep 2
	clear
else

	echo "unzip has already been installed - checking to be sure."
		{
		apt unzip unzip -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
fi


#download and unzip most recent version of BRS from Burst-Team-Apps repo
clear
echo "Now we are going to download BRS 2.2.7"
sleep 1

mkdir /etc/burstcoin/brs/






#Done



