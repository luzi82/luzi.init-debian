#!/bin/bash

set -e

apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y
apt-get autoclean

shutdown -r now
