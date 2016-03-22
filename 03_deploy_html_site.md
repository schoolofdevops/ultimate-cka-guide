## Deploying a HTML Site

### Generating Deployment Configurations with Capistrano

Change into  directory where your application source code is located.

```

cd /path/to/myapp/

```

Create  index.html

```
<html>
   <h1> HTML Site v1.0 </h1>
</html>

```

Add and commit to git repo on Github
```
git add index.html

git commit -a -m "adding index page"

git push origin master
 or
git push github master (if your remote is called github)

```

### Capify your code

Change into  app directory/repo  and run the following

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


#### Configure Capistrano

edit **config/deploy.rb** and add the following content
```
# -*- coding: utf-8 -*-

set :log_level, :debug

set :application, 'myapp'

set :scm, :git

set :repo_url, '<REPLACE_THIS_WITH_YOUR_REPO_URL>'

set :branch, "master"

set :deploy_to, "/usr/share/nginx/html"

set :stages, [:staging, :production]
set :default_stage, :production


```

- Edit config/deploy/production.rb and add the following content :

```
	set :stage, :production

	server '<REPLACE_THIS_WITH_DEPLOY_SERVER_IP>', user: 'deployer', roles: %w{app}


```


Deployment to Production :

``` cap production deploy  ```
