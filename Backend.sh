#!/bin/bash

# Log file path
LOG_FILE="/var/log/backend_script_execution.log"

# Function to check the exit status of the last executed command
check_exit_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed." | tee -a $LOG_FILE
        exit 1
    else
        echo "$1 succeeded." | tee -a $LOG_FILE
    fi
}

# Clear the log file at the beginning of the script
> $LOG_FILE

# Update package lists
echo "Running apt update..." | tee -a $LOG_FILE
sudo apt -y update
check_exit_status "apt update"

# Upgrade installed packages
echo "Running apt upgrade..." | tee -a $LOG_FILE
sudo apt -y upgrade
check_exit_status "apt upgrade"

# Install MariaDB
echo "Installing MariaDB..." | tee -a $LOG_FILE
sudo apt -y install mariadb-server
check_exit_status "MariaDB installation"

# Start and enable MariaDB
sudo systemctl start mariadb && sudo systemctl enable mariadb
check_exit_status "MariaDB service start and enable"

# Secure MariaDB installation
echo "Securing MariaDB..." | tee -a $LOG_FILE
sudo mysql_secure_installation <<EOF
y
wordpress_password
wordpress_password
y
y
y
y
EOF
check_exit_status "MariaDB secure installation"

# Create WordPress database and user
echo "Creating WordPress database and user..." | tee -a $LOG_FILE
username=$(tr -dc 'A-Za-z' < /dev/urandom | head -c 25)
password=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 25)

sudo mysql -e "CREATE DATABASE IF NOT EXISTS $username"
sudo mysql -e "CREATE USER $username@'%' IDENTIFIED BY '$password'"
sudo mysql -e "GRANT ALL PRIVILEGES ON $username.* TO $username@'%'"
sudo mysql -e "FLUSH PRIVILEGES"
check_exit_status "Database and user creation"

# Save credentials to a file
echo "Saving database credentials..." | tee -a $LOG_FILE
echo "DB_NAME=$username" > /root/creds.txt
echo "DB_USER=$username" >> /root/creds.txt
echo "DB_PASSWORD=$password" >> /root/creds.txt
echo "DB_HOST=backend-elastic-ip" >> /root/creds.txt
check_exit_status "Credentials file creation"

# Allow remote access to MariaDB
echo "Configuring MariaDB for remote access..." | tee -a $LOG_FILE
sudo sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo systemctl restart mariadb
check_exit_status "MariaDB remote access configuration"
