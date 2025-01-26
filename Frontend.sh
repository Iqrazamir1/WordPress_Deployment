#!/bin/bash

# Log file path
LOG_FILE="/var/log/frontend_script_execution.log"

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

# Install Nginx
echo "Installing Nginx..." | tee -a $LOG_FILE
sudo apt -y install nginx
check_exit_status "Nginx installation"

# Start and enable Nginx
sudo systemctl start nginx && sudo systemctl enable nginx
check_exit_status "Nginx service start and enable"

# Install PHP and required extensions
echo "Installing PHP and extensions..." | tee -a $LOG_FILE
sudo apt -y install php-fpm php php-cli php-common php-imap php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl
check_exit_status "PHP installation"

# Move the Nginx configuration file
echo "Configuring Nginx..." | tee -a $LOG_FILE
sudo mv /root/WordPress_Deployment/nginx.conf /etc/nginx/conf.d/nginx.conf
check_exit_status "Nginx configuration file move"

# Generate DNS record for the EC2 instance
dns_record=$(curl -s icanhazip.com | sed 's/^/ec2-/; s/\./-/g; s/$/.compute-1.amazonaws.com/')

# Update the Nginx config file with the server name of the EC2 instance
sed -i "s/SERVERNAME/$dns_record/g" /etc/nginx/conf.d/nginx.conf

# Disable the default Nginx configuration
sudo rm /etc/nginx/sites-enabled/default

# Reload Nginx if the configuration test is successful
nginx -t && sudo systemctl reload nginx
check_exit_status "Nginx reload"

# Install Certbot for SSL
echo "Installing Certbot..." | tee -a $LOG_FILE
sudo apt -y install certbot python3-certbot-nginx
check_exit_status "Certbot installation"

# Define your email and domain
EMAIL="zamiriqra0@outlook.com"
DOMAIN="ua92.yourdev.uk"

# Obtain and install SSL certificate
echo "Obtaining SSL certificate..." | tee -a $LOG_FILE
sudo certbot --nginx --non-interactive --agree-tos --email $EMAIL -d $DOMAIN
check_exit_status "SSL certificate installation"

# Reload Nginx to apply SSL changes
sudo systemctl reload nginx
check_exit_status "Nginx reload after SSL"

# Run WordPress installation script
echo "Running WordPress installation script..." | tee -a $LOG_FILE
sudo bash /root/WordPress_Deployment/wordpress_automate.sh
check_exit_status "WordPress installation script"
