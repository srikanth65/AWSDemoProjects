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
