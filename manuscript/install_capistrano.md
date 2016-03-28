----
# CAPISTRANO
----
Capistrano is a remote server automation tool.It supports the scripting and execution of arbitrary tasks, and includes a set of sane-default deployment workflows.

## Installing Capistrano on Centos 6.7:-

Capistrano requires ruby version >=2.x.x to
be installed

### Installing Pre Requisites

```

yum install -y tar which


yum -y install patch libyaml-devel libffi-devel glibc-headers autoconf gcc-c++ glibc-devel readline-devel zlib-devel openssl-devel bzip2 automake libtool bison

```

### Installing Ruby with RVM

- #### Add rvm signature


command curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -
curl -L get.rvm.io | bash -s stable



- #### Load rvm

``` source  /etc/profile.d/rvm.sh ```


- #### Install Ruby using rvm

```rvm install 2.1.4```

- #### Verify ruby version

```ruby -v```

### Install  Capistrano using gem

- install capistrano

``` gem install capistrano ```

- deploy nonrail app with Capistrano

``` gem install railsless-deploy ```

- Install capistrano extensions

```gem install capistrano-ext```


#### Create ssh keypair

For secure login to production/staging server use ssh key pair. to generate ssh key use below command.

```
ssh-keygen -t rsa

```
