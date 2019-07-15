# docker-examples/Oracle Database/nodeClient

## Oracle Database Client 18c and node-oraceldb based on [A node-oracledb Web Service in Docker](https://blogs.oracle.com/opal/a-node-oracledb-web-service-in-docker) [@christopher.jones/oracle-blog-examples](https://blogs.oracle.com/author/christopher-jones)

The example Dockerfile builds from a slim Oracle Linux 7 and sets up repositories to obtain the Oracle Instant Client 18.3c as well as the node-oracledb databse driver.  If the versions are updated, then minor adjustments to the environment variable ORACLE_INSTANTCLIENT, the YUM Repo contents and possibly the Dynamic Library configuration may be requred.

### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and Configuration file(s)
1. Change to that directory in a  _Terminal or Shell window_.
1. By default, the image starts a nodeJS session allowing one to do interactive test connections
1. The Dockerfile can be adjusted to include the sample .js or other files and the CMD changed to start these instead

### Notes
1. For the example code, environment variables are set for user(schema), password and connect string.  The connect can be in the Quick form or can tie back to an entry in $ORACLE_INSTANTCLIENT/admin/network/tnsnames.ora (by default).
1. Details on node-oracledb are available at the [GITHUB Repository for node-oracledb](https://github.com/oracle/node-oracledb)

