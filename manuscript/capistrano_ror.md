###example 2

ruby rails application deployment using capistrano:-

**deployment server:-**

Preparing The Deployment Serve:-r



- Updating And Preparing The Operating System

- Setting Up Ruby Environment and Rails

- Downloading And Installing App. & HTTP Servers

- Creating The Nginx Management Script

- Configuring Nginx For Application Deployment

- Downloading And Installing Capistrano

- Creating A System User For Deployment

**development server:-**

- nstalling Capistrano Inside The Project Directory

- Working With config/deploy.rb Inside The Project Directory

- Working With config/deploy/production.rb Inside The Project Directory

- Deploying To The Production Server

- git repository

###deployment server

update system:-

**yum -y update**

Install the bundle containing development tools :


**yum groupinstall -y 'development tools'**

 EPEL repository:

**sudo su -c 'rpm -Uvh88 http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'**

**yum -y update**

install some additional libraries and tools:-

**yum install -y curl-devel nano sqlite-devel libyaml-devel**

Setting Up Ruby Environment and Rails:-

**curl -L get.rvm.io | bash -s stable**

**source /etc/profile.d/rvm.sh**

**rvm reload**

**rvm install 2.1.0**

Rails needs a JavaScript interpreter, run the following to download and install nodejs:-

**yum install -y nodejs**

using RubyGems' gem to download and install rails:-

**gem install bundler rails**

swaping ig server size less than 1GB:-

Create a 1024 MB SWAP space:

**sudo dd if=/dev/zero of=/swap bs=1M count=1024**

**sudo mkswap /swap**

**sudo swapon /swap**

download and install passenger:-


**gem install passenger**

Run the following to start compiling Nginx with native Passenger module:-

**passenger-install-nginx-module**

select language, then option 1 to download & continue

create nginx script:

**nano /etc/rc.d/init.d/nginx**

```
	#!/bin/sh

	./etc/rc.d/init.d/functions

	./etc/sysconfig/network

	[ "$NETWORKING" = "no" ] && exit 0

	nginx="/opt/nginx/sbin/nginx"

	prog=$(basename $nginx)

	NGINX_CONF_FILE="/opt/nginx/conf/nginx.conf"

	lockfile=/var/lock/subsys/nginx

	start() {

   	[ -x $nginx ] || exit 5

   	[ -f $NGINX_CONF_FILE ] || exit 6

   	echo -n $"Starting $prog: "

   	daemon $nginx -c $NGINX_CONF_FILE

   	retval=$?

   	echo

   	[ $retval -eq 0 ] && touch $lockfile

   	return $retval

	}

	stop() {

   	echo -n $"Stopping $prog: "

   	killproc $prog -QUIT

   	retval=$?

   	echo

   	[ $retval -eq 0 ] && rm -f $lockfile

   	return $retval

	}

	restart() {

   	configtest || return $?

   	stop

   	start

	}

	reload() {

   	configtest || return $?

   	echo -n $”Reloading $prog: ”

  	 killproc $nginx -HUP

  	RETVAL=$?

   	ech
	}

	force_reload() {

   	restart
	}

	configtest() {


  	$nginx -t -c $NGINX_CONF_FILE

	}

	rh_status() {

   	status $prog
	}

	rh_status_q() {

   	rh_status >/dev/null 2>&1


	}

	case "$1" in

	start)

	rh_status_q && exit 0

	$1

	;;

	stop)

	rh_status_q || exit 0

	$1

	;;

	restart|configtest)

	$1

	;;

	reload)

	rh_status_q || exit 7

	$1

	;;

	force-reload)

	force_reload
	;;
	status)

	rh_status

	;;

	condrestart|try-restart)

	rh_status_q || exit 0

	;;

	*)
	echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload|configtest}"
	exit 2


	esac

```

set permission:-

**chmod +x /etc/rc.d/init.d/nginx**

configure nginx for deployment:-

**nano /opt/nginx/conf/nginx.conf**

these line add in the file:-
```
	passenger_app_env development;

	location / {

    	  root   html;

          index  index.html index.htm;

        }


	root  /home/deployer/apps/my_app/public;

	passenger_enabled on;

```

restart nginx:-

**/etc/init.d/nginx restart**

###development server:-

Create a sample Rails application:-
**rails new my_app**

Enter the application directory:-

**cd my_app**

Create a sample resource:-

**rails generate scaffold Task title:string note:text**

Create a sample database:-

**RAILS_ENV=development rake db:migrate**

test application set correctly:

Enter the application directory

**cd my_app**

Run a simple server

**rails s**

You should now be able to access it by

**visiting: http://[your droplet's IP]:3000**

In order to terminate the server process

**Press CTRL+C**

create git repo:-

**git init**

**git add .**

**git commit -m "..."**

**git remote url add**

**git push origin master**


capistrano installation inside app dir:-

**cap install**

it will created following file structure for you

 **mkdir -p config/deploy**

 **create config/deploy.rb**

 **create config/deploy/staging.rb**

**create config/deploy/production.rb**

**mkdir -p lib/capistrano/tasks**

**Capifile**

configure deploy.rb:-

**nano config/deploy.rb**


```


	# Define the name of the application
	set :application, 'my_app'

	# Define where can Capistrano access the source repository
	# set :repo_url, 'https://github.com/[user name]/[application name].git'
	set :scm, :git
	set :repo_url, 'https://github.com/user123/my_app.git'

	# Define where to put your application code
	set :deploy_to, "/home/deployer/apps/my_app"

	set :pty, true

	set :format, :pretty

	# Set the post-deployment instructions here.
	# Once the deployment is complete, Capistrano
	# will begin performing them as described.
	# To learn more about creating tasks,
	# check out:
	# http://capistranorb.com/

	# namespace: deploy do

	#   desc 'Restart application'
	#   task :restart do
	#     on roles(:app), in: :sequence, wait: 5 do
	#       # Your restart mechanism here, for example:
	#       execute :touch, release_path.join('tmp/restart.txt')
	#     end
	#   end

	#   after :publishing, :restart

	#   after :restart, :clear_cache do
	#     on roles(:web), in: :groups, limit: 3, wait: 10 do
	#       # Here we can do anything such as:
	#       # within release_path do
	#       #   execute :rake, 'cache:clear'
	#       # end
	#     end
	#   end

	# end

```
configuration productio.rb:-

**nano config/deploy/production.rb**

```

	# Define roles, user and IP address of deployment server
	# role :name, %{[user]@[IP adde.]}
	role :app, %w{deployer@162.243.74.190}
	role :web, %w{deployer@162.243.74.190}
	role :db,  %w{deployer@162.243.74.190}

	# Define server(s)
	server '162.243.74.190', user: 'deployer', roles: %w{web}

	# SSH Options
	# See the example commented out section in the file
	# for more options.
	set :ssh_options, {
    forward_agent: false,
    auth_methods: %w(password),
    password: 'user_deployers_password',
    user: 'deployer',
	}

```

deploy now:-

**cap production deploy**
