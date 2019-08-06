# docker-examples/asterionDB/objVault-RESTfulAPI

## AterionDB Brief and Project Overview

The AsterionDB product allows for streaming unstructured content into and out of an Oracle Database providing a secure
and manageable life-cycle for these unstructured assets.  Existing processes using advanced features, such as DataGuard, Replication,
Backup and Recovery pick up these Objects and their metadata allowing for robust delivery and asset safety.  Removal of the
traditional Filesystem model reduces the attack surface employed by malware.

This project was created to take the existing PHP (with Oracle Instant Client) to provide the PHP translation of the RESTful API
into the Oracle PL/SQL based AsterionDB API layer.


## Containerizing the PHP portion of the asterionDB RESTful API midtier

The example Dockerfile expects to have the downloaded objVault-API bundle of release XXXX or higher and expanded in a working directory.
There are currently no assumptions in the Dockerfile as to the version of the App or the expansion location.
The Dockerfile should be placed within the expanded bundle inside of the path:
${EXPAND_LOCATION}/<TBD>

Finally, the Dockerfile itself is fairly generic (assumes a directory 'src' for the NodeJS application and 'public' for the static and configuration content).

## Working towards a Production Ready Container

The PHP would be hooked in via specific paths defined in an nginx engine and may be combined with other phased of the midtier build delivering
static content as well as the "harvested" objVaultwebApp (the subject of a seperate example).

This can be accomplished by alerting the Dockerfile to include Multiple stages. See: https://docs.docker.com/develop/develop-images/multistage-build/


### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and expanded RESTful API product content
1. Change directory to the above path 
1. Move the Dockerfile from this repository to the current location 
1. For the asterionDB RESTful API, there may be some pieces to compose under the _ORACLE INSTANT CLIENT HOME_/network/admin in order to provide the contents of a Cloud Wallet or tnsnames.ora file
1. Use the following command to  Build an Image
_Steps to be determined_

### Notes
1. More information on this product is available at https://www.asteriondb.com
1. The project is starting as a simple gathering of the pieces (Oracle Linux, Oracle Client, PHP and fastPHP interface, nginx web server) as it evolves, some trim down may be possible in the final production content.

