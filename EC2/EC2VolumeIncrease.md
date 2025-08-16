**Increase the Volume Size:**

- Increase the volume on EC2 ( EC2 - Volumes - Modify volume - change to required volume size)
  
- on CLI:
  
df -h

lsblk 

sudo apt install cloud-guest-utils 

sudo growpart /dev/xvda 1 

sudo resize2fs /dev/xvda1

lsblk 

df -h 



**How to extend/increase/modify EBS volume size**

This can be done on the fly, without even stopping the EC2 instance. Just follow the steps given in the video. 

Do let me know in comments if you face any problem.

Increase EBS Volume Size in AWS
===========================================================

Step 1: Take Snapshot of EBS Volume (to be Safe).

Step 2: Increase EBS Volume Size in AWS Console.

Step 3: Extend a Linux file system after resizing a volume.


Command to Extend the file system:
===========================================================

df -hT

Check whether the volume has a partition:

sudo lsblk

Extend the partition:

sudo growpart /dev/xvda 1

Extend the file system on /:

[XFS file system]: sudo xfs_growfs -d /

[Ext4 file system]: sudo resize2fs /dev/xvda1
