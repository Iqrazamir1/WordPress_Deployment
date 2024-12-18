#!/bin/bash

# Updates all the latest security patches and software packages to ensure the highest level of security for my deployment. 
sudo apt -y update
sudo apt -y upgrade
 
cd /root/
sudo git clone -b develop https://github.com/Iqrazamir1/EPA_WordPress_Website.git
sudo chmod -R 755 EPA_WordPress_Website
sudo bash EPA_WordPress_Website/lemp_stack_automate.sh
