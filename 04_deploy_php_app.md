# Deploy PHP App with Capistrano

```
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm


```

#### Edit /etc/yum.repos.d/remi.repo
A dd the following to [remi] block

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



### Now move back to Development Server.

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

```
<del> Version 1.0 </del>

 Version 1.0
```

```
git commit -a -m "app v2.0"
git push origin master

```

#### Deploy new version


``` cap production deploy nginx_restart ```

#### Rollback to previous version

``` cap production deploy:rollback nginx_restart ```
