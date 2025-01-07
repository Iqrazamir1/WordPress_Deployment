#!/bin/bash

# Log file path
LOG_FILE="/var/log/script_execution.log"

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

# Clone the GitHub repository
echo "Cloning GitHub repository..." | tee -a $LOG_FILE
sudo git clone -b develop https://github.com/Iqrazamir1/EPA_WordPress_Website.git /root/EPA_WordPress_Website
check_exit_status "git clone"

# Change permissions of the cloned repository
echo "Changing permissions of the cloned repository..." | tee -a $LOG_FILE
sudo chmod -R 755 /root/EPA_WordPress_Website
check_exit_status "chmod"

# Run the setup script
echo "Running lemp-setup.sh script..." | tee -a $LOG_FILE
sudo bash /root/EPA_WordPress_Website/lemp_stack_automate.sh
check_exit_status "lemp-setup.sh"

##########################################################################################################################

#!/bin/bash

# Updates all the latest security patches and software packages to ensure the highest level of security for my deployment. 
#sudo apt -y update
#sudo apt -y upgrade
 
#cd /root/
#sudo git clone -b develop https://github.com/Iqrazamir1/EPA_WordPress_Website.git
#sudo chmod -R 755 /root/EPA_WordPress_Website
#sudo bash /root/EPA_WordPress_Website/lemp_stack_automate.sh
