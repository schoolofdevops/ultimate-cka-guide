## Adding checks

Its a common mistake to not set the permissions or access correctly on the deploy directory for the deploy user that you have created.  A lot of us might have faced this issue while deploying the application for the first time.

Instead of assuming  pre requisites have been met, we could enforce it by making part of the capistrano deployment workflow by writing tasks to check for it before applying the code.  

Following is an example of writing a task to check whether the deploy user has write permissions to deploy path.

To create this check, add a task at the following path

File: lib/capistrano/tasks/check_permissions.rake

```
desc "Check that we can access everything"
task :check_permissions do
  on roles(:all) do |host|
    if test("[ -w #{fetch(:deploy_to)} ]")
      info "#{fetch(:deploy_to)} is writable on #{host}"
    else
      error "#{fetch(:deploy_to)} is not writable on #{host}"
    end
  end
end

```

The name of the task we created above is **check_permissions** as mentioned on the following line
``` task :check_permissions do ```


As soon as you create this file, Capistrano would start picking up automatically. To check whether its been added to the tasks, you could run the following command,

```

[root@master myapp]# cap -T
cap check_permissions              # Check that we can access everything
cap deploy                         # Deploy a new release
cap deploy:check                   # Check required files and

```

If you have already noticed, the new task is already available.  You could run it with a stage name added to the command  as,

```

[root@master myapp]# cap production check_permissions
INFO /usr/share/nginx/html is writable on 192.168.5.10

````

My deploy host is 192.168.5.10 and the check tells me I have the correct permissions.
