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

cat > /etc/sudoers.d/91-asterion-user <<"EOF"
asterion ALL=(ALL) NOPASSWD:ALL
EOF
```

**Remaining framework steps in Outline**
### Fuse plugin setup
edit `/etc/fuse.conf` to uncomment *user_allow*
``` bash
mkdir /mnt/dbObscuraOra
chown asterion:asterion /mnt/dbObscuraOra

```
### php-fpm configuration
*edit* `/etc/php.ini`, set the following properties

    upload_max_filesize = 1G
    post_max_size = 1G
    upload_tmp_dir = /var/php

*edit* `/etc/php-fpm.d/www.conf`, set the following properties

    user = php
    group = php
    listen = /var/php/run/php-fpm/php-fpm.sock
    listen.owner = php
    listen.group = php
    security.limit_extensions = .php
    env[HOSTNAME] = $HOSTNAME
    env[LD_LIBRARY_PATH] = /usr/lib/oracle/18.3/client64/lib
    env[ORACLE_HOME] = /usr/lib/oracle/18.3/client64/lib
#### Set up php-fpm as a Service
``` bash
mkdir /etc/systemd/system/php-fpm.service.d/
cat > /etc/systemd/system/php-fpm.service.d/php-fpm-oracle.conf <<"EOF"
[Service]
Environment=LD_LIBRARY_PATH=/usr/lib/oracle/18.3/client64/lib
Environment=TNS_ADMIN=/usr/lib/oracle/18.3/client64/lib/network/admin
EOF
```
#### Work around for `php-oci8` dependency on Oracle Client 12c
``` bash
ln -s /usr/lib/oracle/18.3/client64/lib/libclntsh.so.18.1 \
/usr/lib/oracle/18.3/client64/lib/libclntsh.so.12.1
```
#### Enable php-fpm Service
``` bash
systemctl enable php-fpm
systemctl start php-fpm
systemctl status php-fpm
```
### Build base video Database plugin hooks

*As asterion user, download libvpx-v1.7.0.tar.gz, nasm-2.13.02.tar.gz, last_x264.tar.bz, ffmpeg-4.1.3.tar.bz2 from AsterionDB distribution using `wget --content-disposition ...`*
``` bash
su - asterion
```
#### *create* `plugin.list`, add the Object IDs provided by AsterionDB
``` bash
cat >plugin.list <<EOF
...
EOF
```
#### *create* `dist.url`, place the URL provided by AsterionDB and create holding directory
``` bash
echo -n 'https://dist-sys.asteriondb.com/download/download_object?' > dist.url
mkdir plugin_download
```
#### Download the `plugin` archive
``` bash
for obj in `cat plugin.list`;do
  wget --content-disposition -P plugin_downloads `cat dist.url`"${obj}"
done
```
#### Exit back to root
    exit

#### Unpack the plugin open source components
``` bash
cd /usr/local/src
for a in ~asterion/plugin_downloads/*.tar.gz; do
  tar xvzf $a
done
for a in ~asterion/plugin_downloads/*.tar.bz*; do
  tar xvjf $a
done

export PATH=$PATH:/usr/local/bin
export LD_LIBRARY_PATH=/usr/local/lib
```
#### Compile and Install
While remaining in `/usr/local/src`
For each of the products
1. Change into product directory
2. ./configure [with product options]
3. make
4. make install

``` bash
cd /usr/local/src/nasm-2.13.02; ./configure
make; make install

cd /usr/local/src/x264-snapshot-20190610-2245;
./configure --enable-pic --enable-shared
make; make install

cd /usr/local/src/vpx;
./configure --enable-pic --enable-shared
make; make install

cd /usr/local/src/ffmpeg-4.1.3;
./configure --disable-doc --disable-network \
    --enable-gpl --enable-version3 --enable-shared
make; make install
```

### Disable SE Linux / Bounce the Compute Node
*Currently, `nginx` is unable to properly serve out the webpage contents owned by `asterion` while SE Linux is enabled.  Other services have not been validated with SE Linux enabled.*
Edit the file `/etc/selinux/config` and change the `SELINUX` variable to the value `disabled`.
Then, reboot --

    sync;sync;shutdown -rt 5 now
#### Take a break...
---

### Perform nginx configuration and activate HTTPS (SSL)
Sign back in as the root user via asterion account, which was set up for sudo access earlier.
#### Connect in as `asterion` user

    ssh -i keyfile asterion@${ipAddress}
    sudo -s
#### Configure nginx for AsterionDB services

First, we do a quick backup of the default nginx configuration and remove the default response.
``` bash
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf~
cat >/etc/nginx/nginx.conf <<"EOF"
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Changes from baseline install
    client_max_body_size 1G;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
}

EOF
```
Next, we provide the Asterion site configuration.
*Note: If other sites are to be configured, these should NOT be expressed in the base `nginx.conf` which we have replaced above. You can harvest these other "server" sections and place them in appropropriate site specific files located in a similar pattern to the one provided in the following as `asterion.conf`, notice that these reside in `/etc/nginx/conf.d` to allow the sites to be updated independently of one another.*
You will provide an Environment variable `EXTERNAL_NAME` with the value of the fully qualified domanin name(s) registered as you DNS entry in order to allow the subsitiutions to work properly.  Otherwise, you may need to do some manual editing of `/etc/nginx/conf.d/asterion.conf` to address corner cases.

`export EXTERNAL_NAME=`**fully-qualified-dns-external-name**
``` bash
sed "s@%EXTERNAL_NAME%@$EXTERNAL_NAME@g" <<"EOF" > /etc/nginx/conf.d/asterion.conf
server
{
  server_name %EXTERNAL_NAME%;
  listen 80;

    location /objectVault/installationGuide
    {
        # Removed Absolute Path to see if it works.
        return 301 https://cloud-eval.asteriondb.com/objectVault/installationGuide;
    }

    location /objectVault/usersGuide
    {
        # Removed Absolute Path to see if it works.
        return 301 https://cloud-eval.asteriondb.com/objectVault/usersGuide;
    }

    # Proxy dbStreamer
    # Example uri: https://cloud-eval.asteriondb.com/streaming/stream_object?AGVGYFVYXZN7MWJYKS2MZZXK53HCR1MN
    # TODO: remove extraneous path segments
    #
    location /download/ {
        proxy_pass http://127.0.0.1:6510/asterion_objvault/object_vault_pkg/;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

    location /streaming/ {
        proxy_pass http://127.0.0.1:6510/asterion_objvault/object_vault_pkg/;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

    location ~ ^/objVaultAPI/(.*)$
    {
          alias /home/asterion/asterion/oracle/objVault/php/objVaultAPI/public; 
          include         fastcgi_params;
          fastcgi_pass   unix:/var/php/run/php-fpm/php-fpm.sock;
          fastcgi_param SCRIPT_FILENAME $realpath_root/index.php;
          fastcgi_param DOCUMENT_ROOT $realpath_root;
          fastcgi_param REQUEST_URI $1;
    }

    location / 
    {
        try_files $uri /index.html =404;
        root   /home/asterion/asterion/oracle/objVault/javaScript/objVault-webApp/build;
        # index  index.html index.htm;
    }

}
EOF
```
**None of the product specific content has been put into place yet, so the webserver will not work at this point.**
#### Install certbot (secure traffic via SSL)
Shown here are the instructions to support HTTPS access (SSL) using the Free Certificates and Automatic configuration via CertBot - https://certbot.eff.org
If another strategy is to be employed within this Compute Node, then that should be applied now for the `asterion.conf` and loading (in the appropriate location for that strategy) of the required certificate and key assets needed.

It is not advised to have the asterion services mixed with other non-asterion services on the same site from a single nginx server.  If it is desired to have the asterion services "melt" into other services from a particular site, some front ending of another server which provides the (SSL) and appropriate proxy is a strongly suggested strategy.
*Remaining as the `root` user*
``` bash
mkdir /usr/local/src/certbot
cd /usr/local/src/certbot
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto
/usr/local/src/certbot/certbot-auto --nginx
```
**The script will ask various questions** and perform the appropriate changes needed in the configuration of the website, adjustments after it is complete may be needed if other sites were configured, besides the one in `asterion.conf`.  The script can be rerun if there are typos, etc. after corrections have been applied.
##### Set up Certbot Renewal
If Certbot is being used, then the certificates will need to be renewed from time to time.  The following will wake up periodically and will perform renewal of the assets when needed.
``` bash
cat /usr/local/src/certbot/renew.sh <<EOF
#!/bin/bash
export PATH=$PATH:/usr/sbin
/usr/local/src/certbot/certbot-auto renew
EOF
```
Test the renewal process

    /usr/local/src/certbot/certbot-auto renew --dry-run

Install as a cronjob action
``` bash
echo -n '0 0,12 * * * root python -c ' > /etc/cron.d/certbot
echo -n "'import random; import time; time.sleep(random.random() * 3600)'" \
  >> /etc/cron.d/certbot
echo ' && /usr/local/src/certbot/renew.sh' >> /etc/cron.d/certbot
```
___

## Software Download and install
### Identify the AsterionDB Software Bundles
*The softwate will either be provided as a list of Objects and will be able to be accessed from an Object Vault Instance provided by AsterionDB.*
    ssh -i keyfile asterion@${ipAddress}

#### Set up `asterion` user defaults
*For `TWO_TASK`, specify the **DBaliasName** retried from tnsnames.ora earlier.*
`TNS_ADMIN` can be set if the Wallet Location is different from the Default. If the location is differernt, then either `sqlnet.ora` needs to be adjusted from what is provided from what is initially included in the Oracle Wallet -or- ORACLE_HOME needs to be set to a directory structure `network/admin` which contains the expanded Wallet contents.
``` bash
cat >> .bash_profile <<EOF
export ORACLE_HOME=/usr/lib/oracle/18.3/client64/lib
export LD_LIBRARY_PATH=/usr/local/lib:/usr/lib/oracle/18.3/client64/lib
export PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/lib/oracle/18.3/client64/bin
export TWO_TASK="DBaliasName"
export SQLPATH=$HOME/orastuff
export ASTERION=$HOME/asterion/oracle
EOF
```
``` bash
cat >> .bashrc <<EOF
alias ufi='rlwrap sqlplus "$@"'
EOF
```

**The Following to be completed**

### Software Downloads from distribution source
Include the download for loops
Symbolic link for ObjVault WebApp

**Installation of AsterionDB Database Components:**
1. Database setup script

**Configuration and start of AsteironDB Compute Services:**
### Product Configuration
1. JavaScript for Web App
2. userid/password and connection for ObjVault API
3. userid/password and connection for dbStreamer, dbPlugin, dbObscura
4. service setup script
#### Webserver and content are now in place
Unix connectivity to port 80 and ensure that it redirects to 443, showing login page. An error may show due to the Database needing to be set up properly.
