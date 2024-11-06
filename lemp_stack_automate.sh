#!/bin/bash

# Updates all the latest security patches and software packages to ensure the highest level of security for my deployment.
sudo apt -y update 
sudo apt -y upgrade 

# This file will contain the output of my LEMP Stack unit tests.
sudo touch /root/testing.txt

# Setup Nginx. Starts and enables nginx on a server reboot. The second command will only run if the first command is successful. 
sudo apt -y install nginx 
sudo systemctl start nginx && sudo systemctl enable nginx 
sudo systemctl status nginx > /root/testing.txt

# Install/Start MariaDB
sudo apt -y install mariadb-server
sudo systemctl start mariadb && sudo systemctl enable mariadb 
sudo systemctl status mariabd >> /root/testing.txt

# Install PHP 
sudo apt -y install php-fpm php php-cli php-common php-imap  php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl
sudo php -v >> /root/testing.txt

# Run the wordpress_install script
sudo bash /EPA_WordPress_Website/wordpress_automate.sh  
