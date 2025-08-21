# *enable password-based SSH login*

Create new user

sudo useradd srisri

verify
id srisri

Give sudo access (optional but common in tasks)

sudo usermod -aG wheel srisri   # On Amazon Linux / RHEL
sudo usermod -aG sudo srisri    # On Ubuntu/Debian

Enable password-based SSH login

Edit sshd config:

sudo vi /etc/ssh/sshd_config


Find and update:

PasswordAuthentication yes
PermitRootLogin no


Save and restart SSH service:

sudo systemctl restart sshd

Test login

From your local machine, try:

ssh srisri@<EC2-Public-IP>


Enter the password you set.
If login works

⚡ Pro tip: In real-time projects, we usually disable password login (only key-based) for security. This task is just to practice user management & SSH config.

