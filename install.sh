#!/bin/bash

# PATH
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Store the base dir
BASEDIR=$( cd $(dirname $0); pwd)

# Get all dependencies
sudo apt-get update
sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-dev libyaml-dev libcurl4-openssl-dev curl git-core python-software-properties libsqlite3-dev

# Stuff used by Ballistiq often
# ImageMagick (used by Paperclip gem)
sudo apt-get -y install zip unzip imagemagick
# MySQL headers. Required by mysql2 gem
sudo apt-get -y install libmysql++-dev

# Install Ruby
if ! type ruby > /dev/null; then
	curl -L https://get.rvm.io | bash -s stable --ruby
fi

# Install Bundler
if ! type bundle > /dev/null; then
	gem install bundler
fi

# Install Passenger - which will install Nginx

if [ ! -d /opt/nginx ]; then
	gem install passenger
	passenger-install-nginx-module --auto --prefix=/opt/nginx --auto-download
fi

# Install the control nginx control script
sudo cp $BASEDIR/nginx.initd /etc/init.d/nginx
sudo chmod +x /etc/init.d/nginx
sudo update-rc.d -f nginx defaults

# Add log rotation to nginx
sudo cp $BASEDIR/nginx.logrotate /etc/logrotate.d/nginx

sudo apt-get install mysql-server mysql-client
# Use service to start nginx
sudo service nginx start
