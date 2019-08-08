# phpClient - Docker Container with Oracle Instant Client, php-fpm and nginx

## Overview

The goal is to get the basic scaffolding in place to laverage a php based web facing interface to access an Oracle Database bundled in
a Docker container.  The current RESTful API tier for AsterionDB relies on exactly this type of scaffolding and prebuilt containers
were missing some of the control needed in order to perform assisted configuratio at Image Build time to wire together php-fpm and nginx
tightly coupled (via socket) within the container and have it respond to request no matter what "host server URL" was being used upstream.
In addition, in order to provide a lightweight access for the php layer to an Oracle Database (given it is the target of the RESTful API)
it was best to have the installation happen in an Oracle Linux container, ensuring the best possible chance for the Client to operate
in a manor supportable in the Oracle Cloud Infrastructure (where the AsterionDB product is certified).

Some of the consideratins were to make the adjustment of the "default" installations of php-fpm and nginx specified during the construction
of the Image and to provide a means that an Oracle Cloud Wallet (or simply tnsnames.ora) could be easily injected during the runing of the
container based on the image.

## Resources Used

* (Optimizing PHP-FPM for High Performance)[https://geekflare.com/php-fpm-optimization/]
* (Serve PHP with PHP-FPM and NGINX)[https://www.linode.com/docs/web-servers/nginx/serve-php-php-fpm-and-nginx/]
* (Oracle Docker Images - Oracle Instant Client on GITHUB)[https://github.com/oracle/docker-images/tree/master/OracleInstantClient]

## Installation and usage steps

1. Place Docker on the target system
1. Place the php code and static files to be serviced by the php-fpm / nginx combination into the code subdirectory.
1. Adjust the variables at the top of the file _php-fpm_conf.sh_ for tuning parameters.
1. Changes to the Dockerfile may be required if a different version of Oracle Instant Client is used or there is a change to the path used for the root directory.
1. Build the Image by changeing to the directory containing the contents from this repository and issue:
_docker build -t php-fpm-oracle ._
Note: the expectation is that all of the web content will reside in the image itself, it is possible to override the internal contents thru passing
a volume in from the Host, but that defeats the original goal of a RESTful API fully contained within the Image and deployed on one or more containers with
the container itself relying on the state fully from the Oracle Database.

A quick sample index.html (processed as a static file by nginx) and index.php (forward to and processed by the php-fpm engine) are provided to ensure 
that the configuration is all working for both of these pieces, once this is proven,

## Running a container
Without use of a specialized tnsnames.ora or the contents of an Oracle Cloud Wallet, the image can be run as a container with:
_docker run -d -p 8080:80 php-fpm-oracle_

If you want to use an Oracle Cloud Wallet or just specify networking configuration (such as tnsnames.ora), simply includ a volume clause,
for example:
_docker run -d -p 8080:80 -v walletdir:/oracle/network/admin php-fpm-oracle_

The port being mapped in the examples and even the image name itself can be altered as needed.


