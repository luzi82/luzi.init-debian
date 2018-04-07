#!/bin/bash

set -e

sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get autoclean

sudo shutdown -r now
