#!/bin/bash

sudo apt -y update && sudo apt -y upgrade

# Install the AWS CLI tool using Snap for managing AWS resources
snap install aws-cli --classic

apt -y install mariadb-server mariadb-client

sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

mysqladmin ping && systemctl restart mariadb

# Database username and password variables
username=DB_USERNAME
password=DB_PASSWORD

echo $username > creds.txt
echo $password >> creds.txt

# Connect to S3 Bucket
aws s3 cp s3://mariadbdatabase/wordpress_dump.sql.gz /tmp/wordpress_dump.sql.gz
sudo gunzip /tmp/wordpress_dump.sql.gz
sudo mysql -e "CREATE DATABASE IF NOT EXISTS $username"
sudo mysql -e "CREATE USER IF NOT EXISTS '$username'@'FRONTEND_IP' IDENTIFIED BY '$password'"
sudo mysql -e "GRANT ALL PRIVILEGES ON $username.* TO '$username'@'FRONTEND_IP'"
sudo mysql -e "FLUSH PRIVILEGES"
sudo mysql $username < /tmp/wordpress_dump.sql
sudo rm /tmp/wordpress_dump.sql

# This securely stores the credentials file in AWS S3 for later use or backup
aws s3 cp creds.txt s3://mariadbdatabase
