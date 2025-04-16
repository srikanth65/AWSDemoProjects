**What Is SSH Agent Forwarding?**

SSH Agent Forwarding lets you use your local machine's private key to authenticate on remote servers, without copying the key to those servers.

In simple terms: You log into a bastion/jump host, and from there, you SSH into other internal servers using the key stored on your local machine.

**How SSH Agent Forwarding Works**

**Start an SSH agent on your local machine:**

eval "$(ssh-agent -s)"

ssh-add ~/.ssh/id_rsa

**SSH into the bastion host with forwarding enabled:**

ssh -A ec2-user@bastion-host

**Now from the bastion, you can SSH into internal servers:**

ssh ec2-user@internal-server

The internal-server thinks the request is signed with a key, but that key is still on your laptop.

 **Sample ~/.ssh/config**

Host bastion

  HostName bastion.mycompany.com
  
  User ec2-user
  
  IdentityFile ~/.ssh/id_rsa
  
  ForwardAgent yes


Host private-server

  HostName 10.0.1.10
  
  User ec2-user
  
  ProxyJump bastion
