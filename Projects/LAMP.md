# Create a wordpress website using EC2 and RDS

1. Launch an ec2 instance (Launch Amazon Linux 2)
2. Launch rds cluster 
3. Configure ec2 instance to connect to rds

update the server
sudo yum update -y

**Install mysql client in ec2 instance to connect to RDS cluster**

```bash
sudo dnf install -y mariadb105-server

sudo systemctl start mariadb

sudo systemctl enable mariadb
```

**Export mysql endpoint as MySQSL_HOST Variable**

```bash
export MYSQL_HOST=<your-RDS-endpoint>
```

Example : export MYSQL_HOST=wordpressnew.c6fgyakwuovp.us-east-1.rds.amazonaws.com


**Now Connect to mysql to create required user users that we are going to use**

*Connect to RDS using below command (Replace the host-info and user info)*

```bash
mysql -h wordpressnew.c6fgyakwuovp.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
```

Create required Database, user and provide permisisons to newsly created user on schema we created.

```bash
CREATE DATABASE wordpress;
CREATE USER 'wordpressuser' IDENTIFIED BY 'wordpressuser123';
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser;
FLUSH PRIVILEGES;
Exit
```

**Now Install and configure apache**

```bash
sudo yum install -y httpd
```
Start Apache Service

```bash
sudo service httpd start
```

**Download a wordpress template and unzip the wordpress**

```bash
wget https://wordpress.org/latest.tar.gz
```

```bash
tar -xzf latest.tar.gz
```

```bash
ls
```

When you enter ls it should deisplay these files and directory "latest.tar.gz" and "wordpress"

```bash
cd wordpress
```

**create a wp-config file from sample file already provided**

```bash
cp wp-config-sample.php wp-config.php
```

**edit the wp-config.php file to point to database**

```bash
vim wp-config.php
```

***Replace the Database_name_here , "username_here", "password_here" and "rds-endpoint-name" with valid info***

```bash
// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'database_name_here' );

/** MySQL database username */
define( 'DB_USER', 'username_here' );

/** MySQL database password */
define( 'DB_PASSWORD', 'password_here' );

/** MySQL hostname */
define( 'DB_HOST', 'rds-endpoint-name' );
```


Now go to below link and it provides some information to update the wp-config file. It looks like below shared one.

```bash
https://api.wordpress.org/secret-key/1.1/salt/
```

***Acquire the valid information and update wp-config file accordingly***

```bash
define('AUTH_KEY',         'Decl$qW98DnW 9: Wv&&6M>Aogu0pCVc`lG--B@ O|K_Co|N-~x/B;6-jz/I$S0/');
define('SECURE_AUTH_KEY',  'h1$7N|}]JRB95t8696+K}QHf[#<=YMFIAJ*P8R$>9D5+!^=.CTO(mE>XS*+rt|; ');
define('LOGGED_IN_KEY',    '1~qJ)L+AAd|8P?WBVbg-6X:TBM={0Vp@$S-D:W+8cQZ+4_70sgU+]L33 :uui*n(');
define('NONCE_KEY',        'u,` %S,KNj4xjp8-,/}P3r5FV<;V(ZG7yt.ClDl]A-D8?W?+q!#gk,PacCaAgvtB');
define('AUTH_SALT',        'mN]>hro6kj=rfD_nh@pS+;ZdwZ[~1vhonm$<E4gi|1B4[;-{i/#{E/.L0~64r%n:');
define('SECURE_AUTH_SALT', 'ZLLl?cWs}@yjmFGZcgH;AC@<e?l^M#A+73`%2B.R%0$ozp[2ycj,*B%g.WxLa/?2');
define('LOGGED_IN_SALT',   ']1o^u._l6Z?  zQxI63I^%1;;rW)[Sz6|)-oE7[n8.Ju3%gVOsG|+c0Qg9%[af=R');
define('NONCE_SALT',       'Oq5[SB`Ci9njH@Ec?hF<_GY4p]e>Nh8 81jR<wsGGbyyBBt@?NotM2l6`^]Mbmp:');
```

**Now install dependencies**

```bash
# Install MariaDB
sudo dnf install -y mariadb105-server

# Install PHP
sudo dnf install -y php php-mysqlnd

sudo systemctl start mariadb

sudo systemctl enable mariadb

Verify PHP works by placing a test file:

echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

Visit http://<EC2-PUBLIC-IP>/info.php in your browser
```

**come back to home directory and copy all content to /var/www/html, Then restart the service.**

```bash
cd /home/ec2-user
```

```bash
sudo cp -r wordpress/* /var/www/html/
```
```bash
sudo service httpd restart
```

**Get your instance public IP and Paste it in browser, It should give you wordpress initial configuration page.** 

Visit http://<EC2-PUBLIC-IP> in your browser

Visit http://<EC2-PUBLIC-IP>/wp-admin in your browser

