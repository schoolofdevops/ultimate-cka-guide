#Troubleshooting Method:-
###Which checks are performed If at primary level?
---
- checks that you're using git as a scm
- checks that ssh private key file exists locally
- checks if ssh-agent process is running locally
- checks that ssh-add process can communicate with ssh-agent
- checks that ssh private keys are loaded to ssh-agent
- checks that remote code repository is accessible from local machine
- checks passwordless ssh login is used for all servers
- checks forward_agent capistrano option is set to true for all servers
- checks ssh-agent is actually forwared to all the servers
- checks remote code repository is accessible from all the servers