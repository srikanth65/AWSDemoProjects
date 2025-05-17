# Create Volume and attach to EC2; do the following commands on CLI level:

# Volume attached to EC2: 
- lsblk 
- df -hT
- Create Volume using UI in the same AZ as EC2 and attach it to the EC2 instance
- lsblk
- cd /dev
- ls 

cd ..

check whether the file system exists

file -s /dev/xvdf

file -s /dev/xvda1

# To create the file system

mkfs -t xfs /dev/xvdbp  # to create the XFS file system

file -s /dev/xvdbp   # to check the file system

Now need to mount to a directory

mkdir newvolume/

mount /dev/xvdbp  newvolume/

df -Th

# To make mount permanent

cat /etc/mtab

copy the /dev/xvdbp complete line and paste in /etc/fstab

vim /etc/fstab 

mount -all 


# To increase the existing volume

df -Th

lsblk

yum install xfsprogs

xfs_growfs -d <give_mount_path_/home/ec2-user/newvolume>

xfs_growfs -d /dev/xvdbp

df -Th


# To increase the root volume increase

Full Resize Steps (after increasing volume in AWS):

Grow the partition (if EBS was resized):

sudo growpart /dev/xvda 1

Grow the XFS filesystem:

sudo xfs_growfs -d /






















