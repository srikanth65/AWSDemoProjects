**Project Brief**
Deploying the MERN Stack app on AWS: Achieving High Scalability, high availability, and Fault Tolerance. In this project we are going to use multi-region deployment, one will be the primary region and the second will be for disaster recovery. here we are going to follow a Warm standby disaster recovery strategy.

**Project Overview:**
When a user requests the website, Route 53, the DNS service, handles the request and directs it to CloudFront, the CDN (Content Delivery Network), which serves the client. If CloudFront needs to access the web server (frontend) then it routes the request to the Application Load balancer of the web server and that redirects to the web servers. after successfully receiving static pages, the client's browser can make the API call for data. These API calls are routed through Route 53, which sends them to the ALB of the application server (backend server). The ALB then directs the requests to the application server, where data is processed. Additionally, the application server may store some data in the RDS database. and our database is only accessed by the application server. but there is a chance that where we have deployed infrastructure that region goes down because of some kind of disaster. in that case, CloudFront will do the failover for the web tire and Route 53 will do the failover for the application tire. and both start leveraging resources of the DR region. and this is how we will achieve resiliency.

**List of AWS Services:**
- AWS CloudFront
- AWS Route 53
- AWS EC2
- AWS AutoScaling
- AWS Certificate Manager
- AWS Backup Service
- AWS RDS
- AWS VPC
- AWS WAF
- AWS CloudWatch

  **3-tier Architecture:**
  - Presentation Layer: User Intercations
  - Application Layer (Backend Logic): Processes Business Logic and Data Processing
  - Data Layer (Database): For Data Storage and retrieval

 ![image](https://github.com/user-attachments/assets/51f00426-9df7-4fff-8cad-a406d4864eec)

**Steps:**
- Using two regions: US-EAST-1 and US-WEST-2 
- Create VPC in both regions

**US-EAST-1:**

VPC: Three-tier-app-vpc   172.20.0.0/16

VPC Settings -  Enable DNS hostname checkbox

AZ: us-east-1a 
- pub-sub-1a    172.20.1.0/24
- pri-sub-3a    172.20.3.0/24
- pri-sub-5a    172.20.5.0/24
- pri-sub-7a    172.20.7.0/24

AZ: us-east-1b
- pub-sub-2b    172.20.2.0/24
- pri-sub-4b    172.20.4.0/24
- pri-sub-6b    172.20.6.0/24
- pri-sub-8b    172.20.8.0/24

**Enable Public Assign Public IPV4 address:** Please go to the subnet page and select the public subnet and click on the action button and then choose the Edit subnet setting button from the drop-down list. Here you have to mark right on Enable public assign public IPV4 address. And then click on the save button


**IGW**: IGW-three-tier-app and attach to VPC- Three-tier-app-vpc

**NAT Gateway**: NAT-GW-three-tier-app on pub-sub-1a subnet and Allocate Elastic IP

**RouteTable**: 
Pub-RT: Select pub-RT -  Edit Routes - add route and in Destination filed give 0.0.0.0/0 , In Target select Internet Gateway and save changes.

**Pub-RT**: Subnet Assocations - add associations of pub-sub-1a and pub-sub-2b

**Pri-RT**: select pri-RT - Edit routes - add route in destination field 0.0.0.0/0 and select NAT gateway from the drop-down list of target.

**Pri-RT**: subnet association - add all the 6 private subnets

**Security Groups:** 
- bastion-jump-server-sg - select vpc Three-tier-app-vpc - inbound ssh - myIP
- ALB-frontend-sg - select vpc Three-tier-app-vpc - inbound HTTP & HTTPS from anywhere
- ALB-backend-sg - select vpc Three-tier-app-vpc - inbound HTTP & HTTPS from anywhere
- frontend-sg: select vpc Three-tier-app-vpc - inbound HTTP, SSH -  ALB-frontend-sg, bastion-jump-server-sg
- backend-sg: select vpc Three-tier-app-vpc - inbound HTTP, SSH - ALB-backend-sg, bastion-jump-server-sg
- book- rds-sg: select vpc Three-tier-app-vpc - inbound MYSQL - backend-sg

**Set up RDS:** 
- DB Subnet group: vpc Three-tier-app-vpc - us-east-1a and us-east-2b - pri-sub-7a, pri-sub-8b - create DB Subnet Group
- Create Database - MySQL - 
  ![image](https://github.com/user-attachments/assets/9fcb0370-94b6-44c3-9734-a925aaacc5f3)
![image](https://github.com/user-attachments/assets/b8764d59-fa27-4af4-81c7-b0d3d0c3c974)
![image](https://github.com/user-attachments/assets/2a6e3f57-1962-42b8-a4c5-82f75dbd9795)
![image](https://github.com/user-attachments/assets/a29d3638-d820-44df-8cef-46cc54400e7f)
![image](https://github.com/user-attachments/assets/e3d65ba5-cd04-4eb4-a918-42ae2300dd02)
![image](https://github.com/user-attachments/assets/39346572-15c6-4449-9351-fa1bfceaf72e)

Note: RDS take 15-20 minute because it creates a database and then take a snapshot. 

After your database is completely ready and you see the status Available then select the database and click on the Action button. There you can see the drop-down list. Please click on created read-replica.
![image](https://github.com/user-attachments/assets/917d3291-43bc-4aa6-bd9c-7c60a3df4d7c)

This page is similar to creating a database. In the AWS region select the region where you want to create the read replica. In this case, It is Oregon (us-west-2). Give a name to your read replica, and select all the necessary configurations that we did before while creating the database. For your reference, I have shown everything in the below images.
![image](https://github.com/user-attachments/assets/6926cb09-1538-454e-8082-934f9e51bfd4)
![image](https://github.com/user-attachments/assets/a7acf2cf-5ba3-4f4d-9293-b06bd52d053b)
![image](https://github.com/user-attachments/assets/29b0da6a-224f-4026-88a3-c15471ca114b)
![image](https://github.com/user-attachments/assets/77f36cb2-35b8-4adb-b5aa-056936e51dc1)

Note: we can’t write anything into a read replica. It is just read-only database. So when a disaster happens we just have to promote read replica so that it becomes the primary database in that region.

**Route53:**
Now we are going to utilize route 53 service and create two private hosted zone. One for north Virginia(us-east-1) and another one for Oregon region (us-west-2) with the same name.

![image](https://github.com/user-attachments/assets/0f9225bb-7ab9-430e-8326-2f7bbf38caaf)

Give any domain name because anyhow it will be private hosted zone but it would be great if you give the name same as mine (rds.com). Please select the private hosted zone and Select the region. In my case, it is us-east-1. And then select VPC ID. Make sure you select VPC that we created earlier. Because this hosted zone will resolve the record only in specified VPC. and then click on the Create hosted zone 

![image](https://github.com/user-attachments/assets/d05dad88-e79f-45f4-866c-ee826cdcf72b)

create a Record that points to our RDS instance which is in us-east-1. So click on create record button on the top right corner.
![image](https://github.com/user-attachments/assets/317c722b-aa65-4aa1-8bc4-cd0f55e249c1)
![image](https://github.com/user-attachments/assets/472aecb5-2a25-40d2-bb3e-392423ebd114)
![image](https://github.com/user-attachments/assets/588bfa3b-daea-41af-984e-125158d327d9)

Now we are going to create a new hosted zone with the same name. but for disaster recovery region and that is us-west-2 (Oregon). While creating hosted zone please keep in mind that you need to choose the us-west-2 region and select VPC that you have created in the the us-west-2 region. Again you can utilize the below image for reference
![image](https://github.com/user-attachments/assets/0fa73c99-a5aa-4469-a144-3cf8cbafe019)

set up a simple record that points to the read replica (database) which is in the us-west-2 (Oregon). So select the hosted zone that was created for us-west-2 and defined a simple record in that. Everything is the same as we defined the record in the us-east-1 hosted zone.
![image](https://github.com/user-attachments/assets/bc16697f-8059-46f5-a03c-ccb94d73f52c)

**Certificate Manager**

Note: create certificates in both regions us-east-1 and us-west-2.

Create Certificate - domain name field please type *.Your_Domain_Name.xyz. In the validation method select DNS validation and click on the request certificate.

Now we need to add a CNAME record in our domain. If you are not using route 53 then you need to add this CNAME record manually by going to your DOMAIN REREGISTER. And if you are using route 53 then click on the button create record in route 53 and click on the create record button

**Application Load balancer(ALB) and Route 53**

We need two load balancers, one point to the backend server, and another point to the frontend server.

Note: before we created ALB we need to create a Target group(TG). So first we will create TG for ALB-frontend and then create TG for ALB-backend.

**TG fro ALB-frontend-TG**
![image](https://github.com/user-attachments/assets/9a3a6adb-22f0-4c07-971b-cdeebd3cfd1b)
![image](https://github.com/user-attachments/assets/d850dc7c-b804-459b-960c-6d6cee0d9401)

**TG for ALB-backend-TG**
![image](https://github.com/user-attachments/assets/890b5957-5849-42a0-b168-b9946f0a2f72)
![image](https://github.com/user-attachments/assets/264b1c38-c441-4816-808d-20ac151854aa)

**Create Application Load Balancer:** 
![image](https://github.com/user-attachments/assets/af5870dd-5012-416c-ac52-b4c2faceeaf1)

ALB-frontend. Select the internet-facing option. In Network mapping select VPC that we have created. Select both availability zone us-east-1a and us-east-2b. and select subnet pub-sub-1a and pub-sub-2b respectively.
![image](https://github.com/user-attachments/assets/83457729-6f25-4274-926a-501a0ebee04d)

Select security group ALB-frontend-sg. This SG we have created for ALB-frontend. In the listener part select TG that we have just created ALB-frontend-TG
![image](https://github.com/user-attachments/assets/f47162e4-0108-4634-95fd-f30c9a6b510b)

**create ALB for backend**
![image](https://github.com/user-attachments/assets/b075d5bf-c3f9-4a68-a44c-a6d6fe0115e5)
Select both availability zone us-east-1a and us-east-2b. and select subnet pub-sub-1a and pub-sub2b. select security group ALB-backend-sg that we created for ALB-backend. And in the listner part select TG that we just created ALB-backend-TG.
![image](https://github.com/user-attachments/assets/5f28e06c-f334-4be1-8f7b-29a792fa5059)

Now we have two load balancers, ALB-frontend and ALB-backend. But we need to add one more listener in ALB-backend. So click on ALB-backend.
![image](https://github.com/user-attachments/assets/9ec641c4-95ee-4917-b183-f73e3db8df71)
Click on add listener the button that is located on the right side.
![image](https://github.com/user-attachments/assets/8dddf52b-4a31-4527-9711-de725cbcee49)

Here In listener details select HTTPS. Default Action should be Forward and select ALB-backend-TG. Now we need to select the certificate that we have created. So in the Secure Listener setting select the certificate. And click on the add button below.
![image](https://github.com/user-attachments/assets/d6e9563f-ae61-44f3-b88f-0ec9824d026f)

**EC2**

Now we are going to create a temporary frontend and backend server to do all the required setup, take snapshots and create Machine images from it. So that we can utilize it in the launch template. It is a long process so bear with me.

Note: we are doing this setup in the us-east-1 region and we don’t have to do this in the us-west-2 because we are going to leverage AWS backup service and copy it in the us-west-2 region.

**temp-frontend-server**
First, we are going to set up a frontend server. Give a name to your instance (temp-frontend-server). Select Ubuntu as the operating system. Choose the instance type as t2.micro. click on Create key pair if you don’t have it.

![image](https://github.com/user-attachments/assets/c0bc3b47-571d-4942-a535-b5b37c652aec)

![image](https://github.com/user-attachments/assets/e8546275-fd9c-4b14-bb15-554091460723)

Scroll down to the bottom of the page, here we can see one text box with the name USER DATA. Here in this text box, you can write your bash script file and that will be executed during the launch of the instance. I have given the bash script below. so please copy that script and paste it here. And lastly, click on the launch instance button.

#!/bin/bash

sudo apt update -y

sudo apt install apache2 -y

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs -y

sudo apt update -y

sudo npm install -g corepack -y

corepack enable

corepack prepare yarn@stable --activate --yes

sudo yarn global add pm2

**temp-backend-server**

![image](https://github.com/user-attachments/assets/974fba72-5afb-4422-9c0a-5399b688eed2)

Scroll down to the bottom of the page, and copy the bash script that I have given below. and paste it in the USER-DATA text box. This bash scripting installs some packages so that we don’t have to install them manually. And click on the launch instance.

#!/bin/bash

sudo apt update -y

curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - &&\
sudo apt-get install -y nodejs -y

sudo apt update -y

sudo npm install -g corepack -y

corepack enable

corepack prepare yarn@stable --activate --yes

sudo yarn global add pm2


Login to temp-frontend-server and temp-backend-server
ssh -i <name_of_key>.pem ubuntu@<Public_IP_add_of_Instance>

**temp-frontend-server** 
git clone https://github.com/AnkitJodhani/2nd10WeeksofCloudOps.git

cd 2nd10WeeksofCloudOps/client

Now, we need to change just one line in our frontend application that is built in React. So type the command
vim src/pages/config.js

use your OWN domain name. so your API_BASE_URL should be like https://api.<YOUR_DOMAIN_NAME>.XYZ

Now type the command npm install in the terminal to install all the required packages.
npm install
![image](https://github.com/user-attachments/assets/c2be1ed0-58c1-41ac-b422-1f43f90abedb)

Type the command npm run build to create the optimize static pages.
npm run build
![image](https://github.com/user-attachments/assets/b82d27b7-9b02-4015-a579-f01e63fc19b4)

Now type the very essential command sudo cp -r build/* /var/ww/html/
sudo cp -r build/* /var/www/html
The above command takes all the static files from the build folder and stores them in /var/www/html so that Apache can serve them.
![image](https://github.com/user-attachments/assets/37e4bbf3-053f-4ea1-a0b0-117cf4bfe23c)

**temp-backend-server**
ssh -i name_of_your_key>.pem ubuntu@<Public_IP_add>

first, we will clone the repo.

git clone https://github.com/AnkitJodhani/2nd10WeeksofCloudOps.git

cd 2nd10WeeksofCloudOps/backend 

vim .env

Please change your username and password according to whatever you kept while creating a database

Now type the below commands in terminal
- npm install
- npm install dotenv

Now, let's start the backend server. ( very IMP )

sudo pm2 start index.js --name "backendApi"

you can verify that by typing the command 

sudo pm2 list

Successfully completed our backend server configuration. You can close the terminal

So please select temp-frontend-server and click on the Action button in the top right corner. One drop-down menu will open. You have to select the images and template option and that will give one more drop-down menu from which we need to click on create image button.

Give the name you your image (img-frontend-server). just deselect that delete on the termination button and click on the create image button.
![image](https://github.com/user-attachments/assets/42cd5c8d-ab73-4154-905a-cf2f6fe175a6)

You have to do the same thing for the temp-backend-server as well. I have shown you each and every step in the below images.
![image](https://github.com/user-attachments/assets/355abfc5-4bbc-48e3-942d-9bb6233cf027)

Note: Again we did the above setup in us-east-1 and we don’t have to do this setup for us-west-2 we will leverage aws backup service to copy these machine images in us-west-2.

**Backup service**
We create machine images in N.virginia ( us-east-1) region and now let’s again create images and copy these images to the Oregon region (us-west-2 ). So please type Backup in the AWS console search bar. And click on the service. Currently, I’m in the N.virginia region.

Let's first create a backup vault. Backup value is a kind of bucket where you can store your backups. So click on the Backup Vault button on the left panel and then click on the create backup vault button on the top right corner.
![image](https://github.com/user-attachments/assets/269dcd7b-e880-4e67-ae77-69b373384d3d)
![image](https://github.com/user-attachments/assets/c420db6d-02e7-423b-894e-faec549db614)

Now our backup vault is ready. So let's create a backup plan. Click on the Backup Plan button on the left side and click on the create backup plan on the top right corner.
![image](https://github.com/user-attachments/assets/b69ad443-66b4-40d0-bbe4-58a02f224bd7)

Here we can configure our backup plan. So click on the build new plan and give a name to your backup plan. In the backup rule configuration, we can set up our backup rules. So give a name to your rule. Select the backup vault that we have created just now. And in the rest of the parameters select as I have shown you in the below image. Take note that in the backup window start time please select 10 minutes more than the current UTC time so that we can see the output of the backup quickly.
![image](https://github.com/user-attachments/assets/06555450-41c6-40ab-9c91-c1a15c11129f)

Scroll down, and select the destination region where you want to copy your resource. In my case, it is us-est-2 (Oregon region). And you can select the default backup vault if you don’t want to create a backup vault in Oregon. 
![image](https://github.com/user-attachments/assets/c290a32d-4cc8-4077-b713-baa1a1f7c358)
![image](https://github.com/user-attachments/assets/4d7d86fa-d194-4c2c-8679-d5896ec2af82)


**Launch Template**

Take note that we need to create a launch template in both regions primary and disaster recovery (secondary) us-east-1 and us-west-2. And now we have machine images in both regions.

First I will create a launch template in N.virginia (us-east-1). So click on the launch template button on the left panel and click on the create launch template button.

![image](https://github.com/user-attachments/assets/5e2a9a15-86db-4080-8e55-a175a3d2d2dd)

![image](https://github.com/user-attachments/assets/fe1169b2-5d05-438b-9e02-702925986788)

Scroll down to the bottom, and in the USER-DATA text box paste the code that I have given below. And then click on the Create launch template button.

#!/bin/bash

sudo apt update -y

sleep 90

sudo systemctl start apache2.service

![image](https://github.com/user-attachments/assets/a5fb6f49-e5b0-406c-a894-8b8860b5e2bf)

Give a name to your launch template (template-backend-server). Give version 1 in the version field, but make you select the correct AMIt that holding your backend application. And Select an instance type t2.micro

![image](https://github.com/user-attachments/assets/ef556f67-05eb-4562-aa15-628ef6898a9f)

![image](https://github.com/user-attachments/assets/46e2c7f1-6e1a-4885-9e13-dfd76ed7295c)

Scroll down to the bottom, and in the USER-DATA text box paste the code that I have given below. And then click on the Create launch template button.

#!/bin/bash

sudo apt update -y

sleep 150

sudo pm2 startup

sudo env PATH=$PATH:/usr/bin/usr/local/share/.config/yarn/global/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu

sudo systemctl start pm2-root

sudo systemctl enable pm2-root

![image](https://github.com/user-attachments/assets/0fb79074-e01f-4139-b62e-2a95c2ca8cdd)

We have created two launch templates, template-frontend-server and template-backend-server in N.virginia

**Auto scaling group (ASG)**

The auto-scaling group is the functionality of EC2 service that launches instances depending on your network traffic or CPU utilization or parameter that you set. It launches instances from the launch template.

Note: we need to set up an Auto Scaling group in both regions us-east-1 (N.virginia) and us-west-2 (Oregon, Disaster recovery region). First, we are going to set up ASG in us-east-1

Give a name to your ASG. E.g ASG-frontend . And select the launch template that we have created for frontend (e.g template-frontend-server ) in the launch template field. And click on the next button.
![image](https://github.com/user-attachments/assets/a3026dad-ffbb-4ff1-88fd-ee84fdac7262)

In the network field, you have to choose VPC that we created earlier. And in AZs and subnet filed choose pri-sub-3a and pri-sub-4b. these subnets we have created for frontend servers. And click on the next button.
![image](https://github.com/user-attachments/assets/3b150e10-42a6-475d-ae9e-76d791e17294)

On this page we need to attach ASG with ALB so select the Attach existing ALB option and select TG that we have created for frontend e.g ALB-frontend-TG. And then scroll down and click on the NEXT button

![image](https://github.com/user-attachments/assets/d70b1fc3-d0fe-4c7e-827b-69fd37623a5d)

Here you can set the capacity and scaling policy but I’m keeping 1,1,1 to save cost but in real projects, it depends on the traffic. Click on the NEXT->next->next-> and create ASG button.
![image](https://github.com/user-attachments/assets/648f85e4-a45f-4a79-a405-52c4a57f3223)

**ASG for the backend**

Give a name to your ASG. E.g ASG-backend. And select the launch template that we have created for the backend (e.g template-backend-server ) in the launch template field. And click on the next button.

![image](https://github.com/user-attachments/assets/1a4e185a-3f6a-4920-9b7a-3540be1ca34d)

In the network field, you have to choose VPC that we created earlier. And in AZ and subnet field choose pri-sub-5a and pri-sub-6b. these subnets we have created for backend servers. And click on the next button.

![image](https://github.com/user-attachments/assets/e6c3ce3d-1dbc-493f-a9c1-7a3d10456df0)

On this page we need to attach ASG with ALB so select the Attach existing ALB option and select TG that we have created for the backend e.g ALB-backend-TG. And then scroll down and click on the NEXT button.
![image](https://github.com/user-attachments/assets/71bc7fb3-8b03-444c-949e-1ce51e11ba04)
![image](https://github.com/user-attachments/assets/f80231c3-5d3d-48e6-8bc4-7e22fe722499)

**bastion host or jump-server**
Now before we go further one more thing we need to do. We need to initialize our database and need to create some tables. But we can’t access the RDS instance or backend server directly coz they are in a private subnet and the security group won’t let us login into it. So we need to launch an instance in the same VPC but in the public subnet that instance is called bastion host or jump-server. And through that instance, we will log in to the backend server, and from the backend server we will initialize our database.

Give a name to the instance (bastion-jump-server). Select Ubuntu as OS, instance typet2.micro, and select Key pair. In all the instance and launch template we have used only one key so it will be easy to login in any instance. And then click on the Edit button of the Network setting.

![image](https://github.com/user-attachments/assets/a5329066-1851-4630-8f6c-3af7a8124784)

In the network setting select VPC that we have created and in the subnet select pub-sub-1a, you can select any public subnet from the VPC. and then select security group. We already have a security group with the name bastion-jump-server-sg and click on the launch instance
![image](https://github.com/user-attachments/assets/8ae2defe-9234-4638-9177-13a554b4ca17)

Once the instance becomes healthy, we can SSH into it. so select the instance and copy its public IP. Open Git bash or terminal in which folder your key.pem file is present and hit the below command.

scp -i <name_of_your_key>.pem <name_of_your_key>.pem 

ubuntu@<Public_IP_add_of_instance>:/home/ubuntu/key.pem

The above command will copy our login secret key file into the bastion host.
Now type the below command to login into the Bastion host. And copy the public IP of the Bastion host.ssh -i <name_of_your_key>.pem ubuntu@<Public_IP_add_of_instance>

Now we want login into the backend server so select backend server and copy its private IP address. You can identify the backend server by the security group attached to the instance.

Type the below command to log in to the backend server.ssh -i key.pem 

ubuntu@<Private_IP_add_backend_server>

Now we are logged in inside the backend server. just go into 2nd10WeeksofCloudOps/backend directory 

cd 2nd10WeeksofCloudOps/backend

We need to install one package type below the command

sudo apt install mysql-server -y

And type the below command to initialize the database.

mysql -h book.rds.com -u <user_name_of_rds> -p<password_of_rds> test < test.db

**Route 53**

Amazon Route 53 is a highly available and scalable Domain Name System (DNS) web service.

If you try to access the web app using ALB-frontend DNS then you won’t see the website in functional mode because our frontend or loaded static pages try to call the API from your browser on the domain namehttps://api.<Your_Domain_name>.xyz

set up a Health check in route 53. So route 53 checks the health of the backend servers and if it is unhealthy ( hits by disaster ) then it will transfer the traffic to another region's (disaster recovery region, Oregon) backend server.

Head over to route 53 service. And click on the health check button on the left panel.
![image](https://github.com/user-attachments/assets/16962a5d-4c23-4590-99c3-ae92288c4084)

![image](https://github.com/user-attachments/assets/bd6de993-90c0-46a8-95b7-0ba9ee13f8de)

On this page, we can configure our Health check. Give a name to your health check, and select the endpoint to monitor it. select HTTP and in the Domain name field give the DNS of the ALB-backend which is in US-EAST-1 because us-east-1 is our primary region. And fill in all the details as I have shown you in the below image. And then click on the next button.
![image](https://github.com/user-attachments/assets/f726e924-ee17-4a73-98a4-acab167cff61)

In the next few minutes, it starts showing you the health of the ALB-backend (backend-servers).
![image](https://github.com/user-attachments/assets/6f109bc9-de15-4246-8805-c39a498705d1)

Now let's create a record in our domain name. click on the hosted zone and select your public hosted zone or your domain. I already have one. And click on the Create record button in the top right corner.
![image](https://github.com/user-attachments/assets/19c81937-0351-4be8-9887-32abcd374a84)

Select failover record. And click on the next button.
![image](https://github.com/user-attachments/assets/3c57032b-a3cc-4406-8eac-065924bef8f8)

Here in the record name field write api so that our record name becomes api.<Your_Domain_name>.xyz. in the record type field select “A” and then click on the define failover record button.
![image](https://github.com/user-attachments/assets/402f7167-2f19-4503-b69f-0490cb31e63a)

Firstly Select Alias to application and classic Load balancer from the drop-down list, secondly, select us-east-1 as a region. And in the below drop-down list select DNS of the ALB-backend. As you know that us-east-1 is our primary region so select primary in failover type. And in the health check ID select the health check that we have created just now. And click on the Define failover record button. Follow the below image for more clarity.

![image](https://github.com/user-attachments/assets/ec633ddb-fc64-433d-8158-d4b12c2a9fca)


Click on create record button.
![image](https://github.com/user-attachments/assets/4ded37f1-b089-4fbd-97b6-185d9d3d5908)

Now we need to set up one more failover record with the same domain name but for a secondary region. Firstly Select Alias to application and classic Load balancer from the drop-down list, secondly, select us-west-2 as the region. And in the below drop-down list select the DNS of the ALB-backend. As you know that us-west-2 is our secondary region so select secondary in failover type. Make sure you don’t select anything in health check ID. And click on the Define failover record button. Follow the below image for more clarity
![image](https://github.com/user-attachments/assets/14b93f90-767a-4704-9250-9330ef702a20)

So we have two failover type records with sathe e name but one is pointing to the backend load balancer which is in us-east-1 region and the second one is pointing to the backend load balancer of the secondary region Oregon(us-west-1).
![image](https://github.com/user-attachments/assets/7c61b803-3c4a-434e-87cf-7f3d8696b235)

**CloudFront**

AWS CloudFront is a CDN service provided and fully managed by AWS. By utilizing CloudFront we can do the caching of our website at every edge location of the world. The user of the website faces less latency and gets high performance.

let's create Cloudfront distribution for our website. Head over to CloudFront.

Click on the distribution button on the left panel and then click on the create distribution button on top right corner.

In the origin name field select ALB-frontend (us-east-1 primary region). Select Match Viewer in the protocol field. And scroll down

![image](https://github.com/user-attachments/assets/5d9841a9-1509-4820-9162-29f00bc94c96)

In viewer policy select Redirect HTTP to HTTPS and allow all the methods. But please make sure that you select CashingDisabled and in cache policy and select AllViewr in origin request policy.

![image](https://github.com/user-attachments/assets/4fcae467-c40f-43ea-8a21-bf7c1d3fdad0)

Click on the add item button and add an alternative domain name (threetier.ankitjodhani.club) and select the certificate that we have created in the Custom SSL certificate field.
![image](https://github.com/user-attachments/assets/e904687e-e181-48e5-ae5d-a5ddf6fdcf07)

Scroll down and click button create distribution.
![image](https://github.com/user-attachments/assets/68944dbf-7d12-42e1-b875-e8a0431f6dd5)

Now, click on the distribution that we have created just now and click on the Origin tab. Here you need to select create origin the button in the top right corner.
![image](https://github.com/user-attachments/assets/b7e9bc47-1046-463b-884a-b2368fbced94)

Click on the origin domain field and select the ALB-frontend ( us-west-2 secondary region ), select math view in protocol and the rest of the parameters are all the same so click on the create origin button.
![image](https://github.com/user-attachments/assets/dd2ce5e0-db9b-48cc-a63c-537895583671)

So now we have two Origins one is points to ALB-frontend which is in us-east-1 and the second one is pointing to ALB-frontend which is in the secondary region Oregon (us-west-2). Now click on the create origin group button.
![image](https://github.com/user-attachments/assets/fd76ea94-8528-446f-849b-b47cb4751020)

Here, In the Origins field select the first origin that is associated with us-east-1 and click on the add button. And again click on the origin field and select the origin that is associated with us-west-2 and click on the add button. Give any name to the origin group (frontend_failover_handler) and select all the failover criteria as I have shown in the below image. Hit the button created origin group.
![image](https://github.com/user-attachments/assets/b644b6f6-2e0e-4ccd-abfd-335adb524628)

Now, click on the behavior tab. And select the behavior and click on the edit button.
![image](https://github.com/user-attachments/assets/0afa020f-2b5c-4db7-8970-4180cc7e71d9)

Here we need to change the origin and origin group. Select the origin group that we have just created (frontend_failover_handler). Scroll down and click on the save button.
![image](https://github.com/user-attachments/assets/4c1cda25-1591-4bb9-b578-ccff2500bb4c)

We need to wait till the distribution become available. It takes around 5-8 minutes. And then we can access our website through the DNS name generated by CloudFront. But we want to access the web app custom domain name. so again head over to Route 53 and select your public hosted zone. or your domain name hosted zone. and click on create record button.
![image](https://github.com/user-attachments/assets/79e3975a-fac7-4326-bd8f-364658856e98)


Selectsimple record, and click on the button defined record. In the record name, add name threetier so our domain name becomes threetier.<Your_Domain_name>.XYZ, in my case, it is threetier.ankitjodhani.club. Select record type “A”. Select Alias to CloudFront distribution from the drop-down list in value/route traffic to field. And select the distribution that we have created just now. Lastly, hit the define simple record button. Route 53 takes sometime around 5-10 minutes to route traffic on the newly created record so please wait.

![image](https://github.com/user-attachments/assets/8bd94bdf-16cc-42a6-953d-f6f64d42543d)

Now, let's check the final endpoint. Please hit the record name that you have set up. In my case that is https://threetier.ankitjodhani.club. I am sure you can see the website in a running state.

We are almost done before we taste our application one small service but very essential service we want to utilize and that is WAF.

**AWS WAF (Web application firewall)**

AWS WAF is a web application firewall that helps protect apps and APIs against bots and exploits that consume resources.

Search WAF in the AWS console, and click on the service.

Click on the Web ACLs on the left panel and then click the button which is in the middle Create Web ACL
![image](https://github.com/user-attachments/assets/406e8798-24ed-4c54-a6b4-15cc49a84032)

Give some meaning full name to the ACL list, in resource type select the AWS CloudFront distribution. And then click on the Add AWS resource button and add the CloudFront distribution that we have just created.
![image](https://github.com/user-attachments/assets/781cad84-ca45-42b1-bade-679f723b8b8d)

Here, hit the add rule button on top and click Add manage rule group.
![image](https://github.com/user-attachments/assets/ab32c7b9-be29-4a18-b6e7-2a4ecb583265)

Over here we can add the rules to protect our web app front attackers. You can read the description and add the rules that suit your application security. Scroll down and save it.
![image](https://github.com/user-attachments/assets/f4f6fc2e-f9f9-4a21-89ed-5197ebe15269)

Select default action Allow and hit the next button and that’s it. we secured web application. You can see Web ACLs in the list.

![image](https://github.com/user-attachments/assets/167063a7-7d7e-4bd0-abe3-ff28b8baa6f7)

**Testing**

It's time to test our architecture. Let's see if it works as we expected. Can we call it Resilient architecture? Did we implement the Warm Standby strategy properly?

We are going to do manual failover by changing the rules of the security group of the ALB-frontend and ALB-backend. To make our frontend server and backend server inaccessible from the internet in US-EAST-1 region. So we can create a situation like a disaster.

Select ALB-frontend-sg. Click on the edit inbound rule. And remove all the HTTP and HTTPS rules from it. after doing this our CloudFront distribution won’t be able to access this ALB-frontend and it have to route traffic to another region (us-west-2) ALB-frontend.

Select ALB-backend-sg. Click on the edit inbound rule. And remove all the HTTP and HTTPS rules from it. after doing this route 53 will find it unhealthy and it have to route traffic to another region (us-west-2) ALB-backend.

So let's see if CloudFront and Route 53 are routing traffic to a secondary region's server. Take the domain name and try pasting it into the browser.

If we can see the website in fully functional mode, it means we have properly set up and configured our architecture.

**Note**: Please wait for at least 10 minutes so that Route 53 can identify the unhealthy resource. CloudFront takes 60 to 90 seconds for every request to route traffic. So, please don't drop the website immediately.

**Read Replica to Primary Database:**

architecture working as we designed. But you can see that you can’t add a book here. And it is because of read-replica. Read replica allows only read-only operation. We need to promote read-replica which is in the DR region(us-west-2). so that it becomes a database instance. And that allow read and write both operation.

![image](https://github.com/user-attachments/assets/e64ed272-d31a-4d65-be0d-e5f313858757)

I know it is taking a long time to open the website. But we can improve that by changing some configurations in CloudFront. Click on the origin tab. Select the first origin and click on the edit button.
![image](https://github.com/user-attachments/assets/453826fa-c834-4249-be37-bbedbbda1e7d)

Click on the additional settings tab. And decrease the number. So that CloudFront won’t wait too long for a response.
![image](https://github.com/user-attachments/assets/9d73648e-b103-40f3-a222-a0e21a1d83fc)

Now, if you try again you will feel very less latency compared to the previous one.


************
Project Source: https://www.showwcase.com/article/35459/building-a-resilient-three-tier-architecture-on-aws-with-deploying-mern-stack-application 
GitHubProject Source: https://github.com/AnkitJodhani/2nd10WeeksofCloudOps.git 
