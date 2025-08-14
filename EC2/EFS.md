**Create EFS-Security Group:**
EFS-SG VPC  inbound: type-NFS port-2049 source:securitygroupforwhichyouneedaccess/vpccidr  

**Create EFS**
With the security group you created earlier(EFS-SG)

**Attach/mount using below commands: using NFS client** on EC2 instance which you want to connect to the EFS

Using the EFS mount helper:
sudo mount -t efs -o tls fs-0313e79d562273a6b:/ efs

Using the NFS client:
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0313e79d562273a6b.efs.us-east-1.amazonaws.com:/ efs

*mount patch can be efs or anyother too

**how to check whether efs mounted or not**
df -hT

**how to make the mouting permenant?**
**cat /etc/mtab # copy below similar line related with efs DNS name**

fs-0313e79d562273a6b.efs.us-east-1.amazonaws.com:/ /home/ec2-user/dockerserver nfs4 rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,hard,noresvport,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=172.31.27.13,local_lock=none,addr=172.31.27.156 0 0

**vi /etc/fstab  # and paste here**
fs-0313e79d562273a6b.efs.us-east-1.amazonaws.com:/ /home/ec2-user/dockerserver nfs4 rw,relatime,vers=4.1,rsize=1048576,wsize=1048576,namlen=255,hard,noresvport,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=172.31.27.13,local_lock=none,addr=172.31.27.156 0 0

