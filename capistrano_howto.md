
# Prepare Deploy Server
- Create one user and add it to group:

**sudo groupadd www**

- Create a new user and add it to this group.

**sudo adduser deployer**


- Add the user to an already existing group:

```sudo usermod -a -G nginx deployer```

Append the following right after

root ALL=(ALL) ALL in **/etc/sudoers file**.

**deployer ALL=(ALL:ALL) NOPASSWD:ALL**


- Install and configure php5, php5-fpm and nginx

**sudo yum install nginx**

**sudo yum install php5**

**sudo yum install php5-fpm**

- Set the directory permissions to make it access for the Nginx.
-
	 Set the ownership of the folder to members of `www` group

```chgrp -R nginx /usr/share/nginx/html```

  	Set folder permissions recursively

**sudo chmod -R g+rwX /usr/share/nginx/html**

	Ensure permissions will affect future sub-directories etc.

**sudo chmod g+s /usr/share/nginx/html**

- nginx configuration :

```

	server {

	listen 80 default_server;

	listen [::]:80 default_server ipv6only=on;

	root /usr/share/nginx/html/current;

	index index.html index.php index.htm;

	# Make site accessible from http://localhost/

	server_name localhost;


	location / {

	# First attempt to serve request as file, then

	# as directory, then fall back to displaying a 404.

	try_files $uri $uri/ =404;

	# Uncomment to enable naxsi on this location

	#include /etc/nginx/naxsi.rules

	}

	location ~ \.php$ {

	fastcgi_split_path_info ^(.+\.php)(/.+)$;

	fastcgi_pass unix:/var/run/php5-fpm.sock;

	fastcgi_index index.php;

	include fastcgi_params;

	}

```

- Set fix_path_info=0 in php.ini



###Now move back to Development Server.

- GoTo the directory where your application source code is located.

**cd /home/vagrant/myapp/**

- create a file index.php
-
```
<html>
 <body bgcolor="#E6E6FA">
  <h2> Sample PHP App <h2>
  <h3> Version 1.0 <h3>
	<?php
  	echo "<h4>Current date and time => " . date("r") . "</h4>";
	?>
	</body>
</html>

```

- Initiate Git

Initiate the repository

**git init**

Add the files to the repository and Commit the changes

**git add .**


**git commit -m "first commit"**

Add your Github repository link

Example: git remote add origin git@github.com:[user name]/[repo-name].git

**git remote add origin git@github.com:user1/myapp.git**

push changes

**git push origin master**

- Initiating Capistrano

move inside your app directory & hit command

```cap install```

Output:
```
mkdir -p config/deploy
create config/deploy.rb
create config/deploy/staging.rb
create config/deploy/production.rb
mkdir -p lib/capistrano/tasks
create Capfile
Capified
```


- Configure Capistrano :

edit **config/deploy.rb** and add the following content
```

	set :log_level, :debug

	set :application, 'myapp'

	set :scm, :git

	set :repo_url, 'https://github.com//.git'

	set :branch, "master"

	set :deploy_to, “/usr/share/nginx/html”

	set :pty, true
	set :format, :pretty
	set :stages, [:staging, :production]
	set :default_stage, :production

```

- Edit config/deploy/production.rb and add the following content :

```
	set :stage, :production

	role :app, %w{deployer@}

	server '', user: 'deployer', roles: %w{app}

	set :ssh_options, {

	forward_agent: false,

	user: 'deployer',

	keys: %w(/root/.ssh/id_rsa),

	auth_methods: %w(publickey password),


```

- Create a rake file for php5-fpm restart :


**cat lib/capistrano/tasks/php_restart.rake**

```
desc "php5-fpm"

task :php5fpm_restart do

on roles(:app) do |h|

if test("sudo service php5-fpm stop && sudo service php5-fpm start")

info "restarted #{h}"

else

error "not restarted #{h}"

end

end

end

```

- Deployment on Production :

**cap production deploy php5fpm_restart**

- We can see the output on browser by typing public ip of server.

- Now we want to deploy a new version of php app (say version 1.1)

repeat procedure for & deploy , see the output

- you can revert back changes using command

**cap production deploy:rollback php5fpm_restart**
