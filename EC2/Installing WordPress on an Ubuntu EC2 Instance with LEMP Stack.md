**Set up a WordPress website on an Amazon EC2 instance running Ubuntu. We’ll use the LEMP (Linux, Nginx, MySQL, PHP) stack to achieve this**

1. Launch an Amazon EC2 instance.
2. Install and configure Nginx, MySQL, and PHP.
3. Download and set up WordPress.
4. Configure Nginx to serve WordPress.

**Launch a new instance with Ubuntu Server**

Use SSH to connect to your EC2 instance using the key pair you specified during the launch.

ssh -i .pem_file ubuntu@ec2_instance_IPv4

**Install the NGINX web server.**

sudo apt update

sudo apt install nginx

**Install the MySQL**

sudo apt install mysql-server

To verify successful installation, type sudo mysql

**Install PHP and extensions:**

sudo apt install php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-zip

To verify successful installation, type php --version

**Configure Nginx to use PHP-FPM**

Create a Directory for Your WordPress Site:
sudo mkdir /var/www/demo
Set Permissions for the Directory:
sudo chown -R $USER:$USER /var/www/demo – It sets the owner and group to the current user (ubuntu).

**Create an Nginx Configuration File for Your Site:**

sudo vi /etc/nginx/sites-available/demo – This will generate a new empty file. Copy and paste the following bare-bones configuration:

server {
listen 80;
server_name your_IPv4;
root /var/www/demo;

index index.html index.htm index.php;

location / {
try_files $uri $uri/ /index.php?$args;
}

location ~ \.php$ {
include snippets/fastcgi-php.conf;
fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
}

location ~ /\.ht {
deny all;
}
}
Replace your_IPv4 with the Public IPv4 address of your instance.

Press ESC, then:wq! to save the changes.

**Link to the configuration file from Nginx’s sites-enabled directory to activate your setup**:

sudo ln -s /etc/nginx/sites-available/demo /etc/nginx/sites-enabled/

Then, under the /sites-enabled/ directory, unlink the default configuration file:

sudo unlink /etc/nginx/sites-enabled/default

You can test your configuration for syntax errors by typing:

sudo nginx -t

If any issues are reported, return to your configuration file and double-check its contents before proceeding.

When you’re finished, reload Nginx to make the changes take effect:

sudo systemctl reload nginx

**Creating a MySQL Database and User for WordPress**

Open the MySQL.

sudo mysql

Create Database:

CREATE DATABASE demo DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

Create User and Grant Permissions:

CREATE USER 'demo_user'@'localhost' IDENTIFIED BY 'demo123';

GRANT ALL ON demo.* TO 'demo_user'@'localhost';

Exit when done.

EXIT;

**Download WordPress:**

Navigate to the /tmp directory.

cd /tmp

Download the latest WordPress package, and extract it.

curl -LO https://wordpress.org/latest.tar.gz

sudo tar -xzvf latest.tar.gz

Configure WordPress: Create a wp-config.php file with your database details.
DB_NAME: demo
DB_USER: demo_user
DB_PASSWORD: demo123

Copy the sample configuration file to wp-config.php for customization.

sudo cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php

Copy WordPress files to the /var/www/demo directory.

sudo cp -a /tmp/wordpress/. /var/www/demo

Set the ownership to www-data

sudo chown -R www-data:www-data /var/www/demo

Edit wp-config.php to add database details:

sudo vi /var/www/demo/wp-config.php

**Generate security keys:**

curl -s https://api.wordpress.org/secret-key/1.1/salt/

Copy the generated security keys on a blank notepad.

Paste the keys into wp-config.php file.

sudo vi /var/www/demo/wp-config.php

Restart the PHP-FPM

sudo systemctl restart php8.3-fpm

**Access your domain in a web browser**.

http://IPv4/wordpress



