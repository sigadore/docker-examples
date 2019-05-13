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

## Working towards a Production Ready Container

As it turns out, the actual Web UI is built using React JavaScript Library from https://reactjs.org which, by it's nature,
is able to run the JavaScript within modern browsers.  During actual production execution, there is no need for a NodeJS
Server to be running.  The key is to harvest the content of the build subdirectory after the _npm run build_ stage in
the Dockerfile and deliver the then static content to the browsers via a web server, such as _nginx_.

This can be accomplished by alerting the Dockerfile to include Multiple stages. See: https://docs.docker.com/develop/develop-images/multistage-build/


### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and expanded webApp content
1. Change directory to the above path (substituting the expand_location and webapp version) -OR- above the NodeJS app to be placed in a docker image _Terminal or Shell window_
`cd ${EXPAND_LOCATION}/asterion/oracle/objVault/javaScript/objVault-webApp-${VERSION}/`
1. Move the Dockerfile from this repository to the current location 
1. For the asterionDB WebApp, copy the file public/assets/asteriondb_config.example to public/assets/asteriondb_config.js _Changing the assignment for `asterionRestAPI` to an appropriate URL.
1. Use the following command to  Build an Image
`docker build --target=build -t objvault-webapp:build .`
1. For Development, Create a container using the image containing the _build_ tag.
`docker rm webapp 2>/dev/null;docker run -d -p 3000:3000 --name webapp objvault-webapp:build && docker logs webapp`
_After development / testing is completed, the final Production Image (harvesting the fruits of the ReactJS Library_
1. For Production, Build the Production Image using:
`docker build -t objvault-webapp:latest .`
1. Now a Production deployment from a lightweight image can be started
`docker run -d -p8080:80 --name webapp-prod objvault:latest && docker logs webapp-prod`

### Notes
1. More information on this product is available at https://www.asteriondb.com
1. The project has gone from a simple nodejs application deployment to development / production packaging options.

