# AsterionDB Installation Guide

## Rough Overview
---
1. Prerequisites
1. Base Software Packages
1. Enable and validate connectivity to the Database
    1. Move the Cloud Wallet info into the default location
    2. Find out the first DB alias provided from the Wallet
    3. Validate connection with SQL\*Plus
1. Startup Validate Basic nginx Webserver
    1. Test Web Server
1. Add and configure unix users
    1. asterion (product owner)
    2. php (objValueAPI owner)
1. Fuse plugin setup (used by dbObscura)
1. php-fpm configuration (used by objVault API)
1. Build base video Databse plugin hooks (used by dbPlugin)
1. Disable SE Linux / Bounce the Compute Node
1. Perform nginx configuration and activate HTTPS (SSL)
1. Download / expand the AsterionDB software
1. Perform the Database product creation
    1. Choose schema names and passwords
    2. Configure and Run the installation script
1.  Configure the AsterionDB Services
1.  Start the AsterionDB Services

## Infrastructure Set up Step by Step
---
### Pre-req after starting a new Compute Instance
1. Publish DNS entry for the Compute's **Public** *ipAddress* which can be placed in a shell variable ipAddress for a local unix based client.  For example: `ipaddress=192.168.9.15`

1. Acquire an SSL Certificate for that DNS entry
Some of the steps *before testing nginx https access can be performed while DNS publish is happening*

1. Set up connectivity to the Database Instance,  
*Download ADB instance Wallet onto Laptop*
From Laptop / Client:

    scp -i keyfile Wallet_DBname.zip opc@${ipAddress}:.

1. Connect in as (oracle cloud user) `opc` and start a `root` shell.

    ssh -i keyfile opc@${ipAddress}
    sudo -s

### Install ol7 packages
``` bash
yum install -y \
    oracle-release-el7 oracle-php-release-el7 \
yum install -y \
    fuse rlwrap fuse-libs uriparser nginx \
    php php-oci8-12c php-mbstring php-json php-common php-fpm \
    oracle-instantclient19.3-basic \
    oracle-instantclient19.3-tools \
    oracle-instantclient19.3-sqlplus
```
### Enable and validate connectivity to the Database
#### Move the Cloud Wallet info into the default location
*Note: If the wallet is placed in a different location, `TNS_ADMIN` environment variable needs to be setup to point to the alternate location, these instructions assume the Oracle Instant Client Default location*
``` bash
mkdir -p /usr/lib/oracle/19.3/client64/lib/network/admin
unzip -d /usr/lib/oracle/19.3/client64/lib/network/admin \
      /home/opc/Wallet_DBname.zip
```
#### Find out the first DB alias provided from the Wallet
``` bash
head -1 /usr/lib/oracle/19.3/client64/lib/network/admin/tnsnames.ora
```
*Results in*
 **DBaliasName**`= (description= ...)`
___
Set `DBalias="`**DBaliasName**`"`
#### Validate connection with SQL\*Plus
*Note: `ORACLE_HOME` is being set due to the default assumptions currently made by Oracle Cloud Wallet generated.*
You will need to be able to connect in as the Oracle Automous (or Admin account who can perform SYSDBA on the target Database instance).
``` bash
export ORACLE_HOME='/usr/lib/oracle/19.3/client64/lib'
sqlplus ADMIN/@${DBalias}
```
You will be invited to provide the ADMIN password and you're looking for **connected**
...
Password: 
...
Connected.
SQL>

### Startup Validate Basic nginx Webserver
``` bash
systemctl enable nginx
systemctl start nginx
firewall-cmd --zone=public --permanent --add-port=80/tcp
firewall-cmd --zone=public --permanent --add-port=443/tcp
firewall-cmd --reload
```

#### Test Web Server 
Connect to port 80 of the `${ipAddress}` from your browser, ensure `nginx` test page.  The defaul nginx server reponds to any Port 80 request, so it is not yet required to have DNS published, however, if it is you can use the new fully qualified domain for this connection test. *You may need to make adjustments to the Compute Node's exposed Network to allow port 80 and 443 through to the instance.*


### Set up users and services
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

systemctl disable httpd

usermod -a -G asterion php
usermod -a -G asterion nginx
usermod -a -G php nginx
usermod -a -G fuse asterion
```

**Remaining framework steps in Outline**
### Fuse plugin setup
### php-fpm configuration
### Build base video Databse plugin hooks
### Disable SE Linux / Bounce the Compute Node
*Currently, `nginx` is unable to properly serve out the webpage contents owned by `asterion` while SE Linux is enabled.  Other services have not been validated with SE Linux enabled.*
Edit the file `/etc/selinux/config` and change the `SELINUX` variable to the value `disabled`.
Then, reboot --
    sync;sync;shutdown -rt 5 now
#### Take a break...

## Software Download and install
---
### Identify the AsterionDB Software Bundles
*The softwate will either be provided as a list of Objects and will be able to be accessed from an Object Vault Instance provided by AsterionDB.*
#### Connect in as `asterion` user
    ssh -i keyfile opc@${ipAddress}

- **nginx configuration**

Install certbot
---------------
Be sure to configure certbot/nginx for the DNS names assigned to the compute node
*This step requires the DNS publication and SSL certificate to validate, one can update their local /etc/hosts file
in order to fake the DNS entry, but after it is published, the testing needs to be performed again*

**CERTBOT INSTALL INSTRUCTIONS HERE**

### Test nginx connectivity to port 80 and ensure that it redirects to 443, showing login page.

- **Installation of AsterionDB Database Components**
- **Configuration and start of AsteironDB Compute Services**
