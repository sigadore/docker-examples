# AsterionDB Installation Guide

Overview
--------

1. Prerequisites
1. Base Software Packages
1. Startup Validate Basic nginx Webserver
1. Add and configure asterion unix user
1. Fuse plugin setup
1. php-fpm configuration
1. Build base video Databse plugin hooks
1. Disable SE Linux
1. Bounce the server

Step by Step
------------

### Pre-req after starting a new Compute Instance
Publish DNS entry for the Compute's <ipAddress>
Acquire an SSL Certificate for that DNS entry
Some of the steps (before testing nginx can be performed while DNS publish is happening)

```bash
scp -i keyfile  opc@<ipAddress>
```
## Connected as `opc` and `sudo -s`

### Install ol7 packages
``` bash
yum install oracle-release-el7 fuse rlwrap fuse-libs uriparser nginx
yum install oracle-instantclient19.3-basic oracle-instantclient19.3-tools \
            oracle-instantclient19.3-sqlplus
```

### Set up connectivity to the Database Instance  
*Download ADB instance Wallet onto Laptop*
From Laptop:
``` bash
scp -i keyfile <wallet-file> opc@<ipAddress>:.
```

### Back on Compute Instance:
``` bash
mkdir -p /usr/lib/oracle/19.3/client64/network/admin
unzip -d /usr/lib/oracle/19.3/client64/network/admin /home/opc/Wallet_Asterion01test.zip
```
### Find out the first DB alias provided from the Wallet
``` bash
head -1 /usr/lib/oracle/19.3/client64/network/admin/tnsnames.ora
 <DBalias> = ...
```

### Validate connection with SQL*Plus
``` bash
export ORACLE_HOME='/usr/lib/oracle/19.3/client64'
sqlplus ADMIN/<ADMIN_PASSWORD>@<DBalias>
```

### Enable and test nginx connectivity 
``` bash
systemctl enable nginx
systemctl start nginx
firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --reload
```

### Test Web Server
Connect to port 80 of the `<ipAddress>` from your browser, ensure `nginx` test page.  *You may need to make
adjustments to the Compute's Network to allow port 80 and 443 through to the instance.*

Install certbot
---------------
Be sure to configure certbot/nginx for the DNS names assigned to the compute node
*This step requires the DNS publication and SSL certificate to validate, one can update their local /etc/hosts file
in order to fake the DNS entry, but after it is published, the testing needs to be performed again*
**CERTBOT INSTALL INSTRUCTIONS HERE**

### Test nginx connectivity to port 80 and ensure that it redirects to 443.

Set up services and users
-------------------------
``` bash
useradd asterion
mkdir /home/asterion/.ssh
cp /home/opc/.ssh/authorized_keys /home/asterion/.ssh/
chown asterion:asterion /home/asterion/.ssh/authorized_keys

useradd -m -U -r -d /var/php -s /bin/false/ php
cd /var/php
mkdir -p run/php-fpm
mkdir chunkedUploads
chown php:php -R run/ chunkedUploads/
chmod 700 chunkedUploads/

yum install oracle-php-release-el7
yum install php php-oci8-12c php-mbstring php-json php-common php-fpm

systemctl disable httpd

usermod -a -G asterion php
usermod -a -G asterion nginx
usermod -a -G php nginx
usermod -a -G fuse asterion
```

