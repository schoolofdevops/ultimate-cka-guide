#!/bin/bash

echo "I: Install Dependencies..."
yum install -y tar which
yum -y install patch libyaml-devel libffi-devel glibc-headers autoconf gcc-c++ glibc-devel readline-devel zlib-devel openssl-devel bzip2 automake libtool bison

echo "I: Install RVM ..."

command curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -
curl -L get.rvm.io | bash -s stable
source  /etc/profile.d/rvm.sh

echo "I: Install Ruby version 2.1.4 ..."

rvm install 2.1.4

echo "I: Display Ruby Version => "
ruby -v

echo "I: Install Capistrano ..."

gem install capistrano

gem install railsless-deploy

gem install capistrano-ext

echo "I: DONE"
exit 0
