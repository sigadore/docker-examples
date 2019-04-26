# docker-examples/asterionDB/objVault-webApp

## AterionDB Brief and Project Overview

The AsterionDB product allows for streaming unstructured content into and out of an Oracle Database providing a secure
and manageable life-cycle for these unstructured assets.  Existing processes using advanced features, such as DataGuard, Replication,
Backup and Recovery pick up these Objects and their metadata allowing for robust delivery and asset safety.  Removal of the
traditional Filesystem model reduces the attack surface employed by malware.

This project was created to take the existing NodeJS Application providing a Web Interface into the AsterionDB and break it out into
a Docker Container with a minimum of changes to the Application itself.  The goal is to leverage this to allow for more complex
toplogies of deployment where multiple WebApp containers can be managed to address load changes and minimize downtime during upgrades.


## Containerizing the nodeJS portion of the asterionDB lightweight content management Web Interface

The example Dockerfile expects to have the downloaded objVault-webApp bundle of release 1.5.1 or higher downloaded and expanded in a working directory.
There are currently no assumptions in the Dockerfile as to the version of the App or the expansion location.
The Dockerfile should be placed within the expanded bundle inside of the path:
${EXPAND_LOCATION}/asterion/oracle/objVault/javaScript/objVault-webApp-${VERSION}/

Finally, the Dockerfile itself is fairly generic (assumes a directory 'src' for the NodeJS application and 'public' for the static and configuration content).

### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and expanded webApp content
1. Change directory to the above path (substituting the expand_location and webapp version) -OR- above the NodeJS app to be placed in a docker image _Terminal or Shell window_
`cd ${EXPAND_LOCATION}/asterion/oracle/objVault/javaScript/objVault-webApp-${VERSION}/`
1. Move the Dockerfile from this repository to the current location 
1. For the asterionDB WebApp, copy the file public/assets/asteriondb_config.example to public/assets/asteriondb_config.js _Changing the assignment for `asterionRestAPI` to an appropriate URL.
1. Use the following command to  Build an Image
`docker build -t objvault-webapp:latest .`
1. Create a container using
`docker rm webapp 2>/dev/null;docker run -d -p 3000:3000 --name webapp objvault-webapp && docker logs webapp`

### Notes
1. More information on this product is available at https://www.asteriondb.com

