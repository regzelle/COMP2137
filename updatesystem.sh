#!/bin/bash

# This a script to update the operating system
# It should not ask questions other than sudo password
# It will use commans like sudo,apt

# Update the local list of available software
sudo apt update

# Upgrade any out of date packages
sudo apt-get -qq upgrade

