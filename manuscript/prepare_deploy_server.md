# Prepare Deploy Server


### Create a new user

```
sudo adduser deployer


```

### Update sudoers file

Edit /etc/sudoers and append the content right after

root ALL=(ALL) ALL in


```
visudo

deployer ALL=(ALL:ALL) NOPASSWD:ALL

```


### Install and configure  Nginx

``` sudo yum install nginx ```

Add deployer to nginx group

```sudo usermod -a -G nginx deployer```


Set the ownership of the folder to members of `nginx` group and set permissions


```

chgrp -R nginx /usr/share/nginx/html

sudo chmod -R g+rwX /usr/share/nginx/html

sudo chmod g+s /usr/share/nginx/html

```
