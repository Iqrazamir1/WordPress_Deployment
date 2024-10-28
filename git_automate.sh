#!/bin/bash

# Install Git 
sudo apt -y install git 
cd /root/
sudo git clone https://github.com/Iqrazamir1/EPA_WordPress_Website.git
sudo chmod -R 755 EPA_WordPress_Website
sudo bash EPA_WordPress_Website/lemp_stack_automate.sh
