**How to login using password instead of key-pair**
1. Login to the server ( using keypair)
2. sudo su root
3. passwd ec2-user     # here username: ec2-user
4. set password       # set the password
5. vim /etc/ssh/sshd_config    # PasswordAuthentication yes
6. service sshd restart
7. ssh ec2-user@public-ip   # relogin with username@public-ip

**How to give access to username sri to login into server** 
Create User(sri) and give WHEEl permisions
sudo su root #switch to root user
useradd sri   # adduser
usermod -aG wheel sri    # give wheel permissions to sri
groups sri   # check in which groups sri exists
passwd sri   #create password
ssh sri@public-ip    #relogin 


**How to give ssh-key permissions to user sri**
Login with ec2-user
sudo su root
vi /etc/ssh/sshd_config   # PasswordAuthentication no
ls -la 
cd .ssh
cat authorized_keys  # copy the content
su sri # switch user to sri
mkdir .ssh
touch authorized_keys
vi authorized_keys # paste the content copied from /home/ec2-user/.ssh/authorized_keys
chmod 600 .ssh
chmod 600 .ssh/authorized_keys
ssh -i key-pair.pem sri@public-ip 











