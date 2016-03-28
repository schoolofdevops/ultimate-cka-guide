# Deploy PHP App with Capistrano

Objective: Goal of this exercise is to configure  php application on the web server along with nginx, deploy two versions of a sample  php application and learn about rollback with capistrano.

## Prepare Deploy Host/Web Server to run  PHP

Lets setup PHP in addition to Nginx on the **Deploy Server**


Install Remi repository to enable php5-fpm installation

```
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm


```

Enable the above repository by editing  **/etc/yum.repos.d/remi.repo** and updating the  following to [remi] block

```  enabled=1  ```

#### Install PHP with FPM
```
yum install php55 php55-php-fpm
/etc/init.d/php55-php-fpm start

```


#### Edit Nginx Config

Backup Nginx' existing default config

```

mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.bak

```


Create a new  default.conf with following content

```

server {

       listen 80 default_server;
       listen [::]:80 default_server ipv6only=on;
       root /usr/share/nginx/html/current;
       index index.php index.html  index.htm;
       server_name localhost;

       location / {

         try_files $uri $uri/ =404;

       }

       location ~ \.php$ {
         include /etc/nginx/fastcgi_params;
         fastcgi_pass  127.0.0.1:9000;
         fastcgi_index index.php;
         fastcgi_param SCRIPT_FILENAME $document_root/$fastcgi_script_name;
       }

}

```

Restart Nginx

``` service nginx restart ```

Enable nginx and PHP5-fpm to start automatically at boot

```
chkconfig nginx on
chkconfig php55-php-fpm on
```

### Validate

Create a sample php file inside the webroot at

**/usr/share/nginx/html/current/info.php**

```
<?php
  phpinfo();
?>
```

To validate, open the web server's Ip/hostname followed by info.php

e.g. http://192.168.5.10/info.php

This should show you a sample PHP page. If not you will have to look at nginx logs or php5-php-fpm logs and debug the issue.

**Possible Issues: **

 * php5-php-fpm is not installed/started.

-  Logs for php5-php-fpm installed using remi are located in /opt/remi/php55/root/var/log/php-fpm/ directory

 * nginx is not configured properly to handle php requests or to hand off to php5-php-fpm. Check the configs inside /etc/nginx/sites-enabled/*.conf 

## Deploy PHP App

Now lets move back to Development Server.

Change into the working copy of the repository

```  cd /path/to/myapp ```


Create a file index.php

```

<html>
 <body bgcolor="#FFF66C">
  <h1> Version 1.0 <h1>
  <h2> Sample PHP App <h2>
  <h2> Deployed with Capistrano <h2>
	<?php
  	echo "<h4>Current date and time => " . date("r") . "</h4>";
	?>
	</body>
</html>


```

Add the file to  repository and Commit the changes

```
git add index.php
git commit -a -m "adding index.php"
git push origin master

```




Create a Capistrano Task to restart Nginx

Path: lib/capistrano/tasks/nginx_restart.rake

```

desc "nginx"
task :nginx_restart do
    on roles(:app) do |h|

      if test("sudo service nginx restart")
      info "Nginx Restart Successful #{h}"
    else
      error "Nginx Restart Failed #{h}"
    end
  end
end


```


### Deployment on Production :

Deploy the PHP code

``` cap production deploy nginx_restart ```

### Deploy New Version

Change into the repository and edit index.php

<del>  Version 1.0  </del>

``` Version 2.0 ```

```
git commit -a -m "app v2.0"
git push origin master

```

#### Deploy new version


``` cap production deploy nginx_restart ```

#### Rollback to previous version

``` cap production deploy:rollback nginx_restart ```

###Capistrano workflow model:-
![](https://github.com/ashwini9860/images/raw/master/cap-model.png)SS
