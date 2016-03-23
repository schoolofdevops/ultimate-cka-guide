## Deploying PHP App from Jenkins using  Capistrano

We have already learnt how to deploy a PHP application from CLI using cap commands. In this session, we would learn how to integrate capistrano with jenkins along with git repository. We will  take the same project, drop it on jenkins, and have it automatically deploy code every time there is a change in the source code, the way continuous deployment recommends.

We will take a step by step approach to do so.

### Pre Requisites

* Working Jenkins Installation
* Jenkins server should have access/connectivity to deploy server
* Key based SSH authentication should be setup and Jenkins server should have access to the private key to login as deploy user on deploy server
* Jenkins should have "Git Plugin" installed
* Capistrano should have been installed on the Jenkins Server
* "tree" utility should be installed on Jenkins Server

### Step 1 : Add Capistrano Configurations to Git repository

On the **development server** change into the

### Step 2 : Create a Job on Jenkins which pulls git repository  

### Step 3 : Smoke Test Capistrano Installation
Make sure jenkins user can run ```cap -T```

### Step 4 : Smoke Test Deployment
``` cap production check_permissions ```

### Step 5 : Deploy

### Step 6 : Set Triggers to Auto Deploy
