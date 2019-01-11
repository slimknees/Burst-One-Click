#!/bin/bash

#DEFINE VARS
GREETING="Hello! This script has been configured to download all\nrequirements for the BURSTCOIN wallet\nand will help you configure it to your liking!"
SQLDONE="/var/log/sqldone.log"
JAVADONE="/var/log/javadone.log"
MARIADBDONE="/var/log/mariaddone.log"
WGETDONE="/var/log/wgetdone.log"
UNZIPDONE="/var/log/unzipdone.log"
DOWNLOADDONE="/var/log/downloaddone.log"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
CYAN='\033[1;36m'

clear
#Say Hi
echo -e "${GREEN}$GREETING${NC}"
read -p 'Press Enter to Continue'
clear



#---------------------------------------------------------
#ADD UNIVERSE REPO AND APT UPDATE 
#---------------------------------------------------------
echo -e "${YELLOW}Adding Universe Repo and Updating!${NC}"
sleep 2

#Add Universe Repo to allow Java and MariaDB Install
add-apt-repository universe
apt-get update
sleep 2
clear






#---------------------------------------------------------
#JAVA INSTALLATION SECTION
#---------------------------------------------------------

if [ ! -f $JAVADONE ]

then

	#Install Java
	echo -e "${YELLOW}Installing Java!${NC}"
	sleep 1
	apt install default-jdk -y
	touch $JAVADONE
	sleep 2
	clear
else

	echo -e "${CYAN}Java has already been configured - checking to be sure.${NC}"
		{
		apt install default-jdk -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
	clear
fi


#---------------------------------------------------------
#MARIADB INSTALLATION SECTION
#---------------------------------------------------------

if [ ! -f $MARIADBDONE ]

then

	# Install MariaDB
	echo -e "${YELLOW}Installing MariaDB!${NC}"
	sleep 1
	apt install mariadb-server -y
	touch $MARIADBDONE
	sleep 2
	clear
	
else
	echo -e "${CYAN}MariaDB has already been configured - Checking to be sure.${NC}"
		{
		apt install mariadb-server -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
fi



#Show MariaDB and Java Versions
clear
echo -e "${YELLOW}Checking MariaDB and Java Version${NC}"
mysql -V
java -version
sleep 2
clear


#---------------------------------------------------------
#SQL CONFIGURATION SECTION
#---------------------------------------------------------

if 
	[ ! -f $SQLDONE ]; 
then

	#Ask user to imput new ROOT password for MySQL
	clear
	echo -e "${YELLOW}In this section you will be changing your root password for MySQL (mariadb)\nand this script will automate mysql_secure_installation\nfor you to lock down the database server.${NC}"
	echo -e "${GREEN}Please enter desired root password for MySQL:${NC}"
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
	echo -e "${CYAN}Done! Your mysql root password has been changed, and MySql installation has been secured.${NC}"

else
	echo -e "${CYAN}SQL Server has already been configured and secured with a root password. Continuing...${NC}"
	clear
fi
sleep 2


#---------------------------------------------------------
#INSTALL WGET SECTION
#---------------------------------------------------------

if [ ! -f $WGETDONE ]

then

	#Install wget
	echo -e "${YELLOW}Installing wget!${NC}"
	sleep 1
	apt install wget -y
	touch $WGETDONE
	sleep 2
	clear
else

	echo -e "${CYAN}wget has already been installed - checking to be sure.${NC}"
		{
		apt install wget -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
	clear
fi

#---------------------------------------------------------
#INSTALL BRS SECTION
#---------------------------------------------------------

#install unzip
if [ ! -f $UNZIPDONE ]

then

	#Install unzip
	echo -e "${YELLOW}Installing unzip!${NC}"
	sleep 1
	apt install unzip -y
	touch $UNZIPDONE
	sleep 2
	clear
else

	echo -e "${CYAN}unzip has already been installed - checking to be sure.${NC}"
		{
		apt unzip unzip -y
		} &> /dev/null
	echo "Moving to next section"
	sleep 2
fi


#download and unzip most recent version of BRS from Burst-Team-Apps repo
clear
echo -e "${YELLOW}Now we are going to download BRS 2.2.7${NC}"
sleep 1



if [ ! -f $DOWNLOADDONE ]

then

	#Create Directory
	mkdir /etc/burstcoin/brs/

	#Download and unpack BRS - Comment out old versions
	#wget -N https://github.com/burst-apps-team/burstcoin/archive/2.2.6.zip -P /etc/burstcoin/brs/
	wget -N https://github.com/burst-apps-team/burstcoin/archive/2.2.7.zip -P /etc/burstcoin/brs/
		
	#unzip etc/burstcoin/brs/2.2.6.zip /etc/burstcoin/brs/
	unzip -o /etc/burstcoin/brs/2.2.7.zip -d /etc/burstcoin/brs/
	cp -r /etc/burstcoin/brs/burstcoin-2.2.7/* /etc/burstcoin/brs/
	echo -e "${YELLOW}BRS Download and unpack finished${NC}"
	cp /etc/burstcoin/brs/conf/brs-default.properties /etc/burstcoin/brs/conf/brs.properties 
	sleep 2
	clear	
	touch $DOWNLOADDONE
else

	echo -e "${CYAN}BRS has already been downloaded and unpacked${NC}"
	echo -e "${CYAN}Moving to next section${NC}"
	sleep 2
fi




#Done



