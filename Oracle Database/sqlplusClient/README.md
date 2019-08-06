# docker-examples/Oracle Database/sqlplusClient

## Oracle Database Client 18c including sqlplus

The simple example Dockerfile builds from a slim Oracle Linux 7 and sets up repositories to obtain the Oracle Instant Client 18.3c basic and sqlplus.  If the versions are updated, then minor adjustments to the environment variable ORACLE_INSTANTCLIENT, the YUM Repo contents and possibly the Dynamic Library configuration may be requred.

### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and Configuration file(s)
1. Change to that directory in a  _Terminal or Shell window_.
1. By default, the image starts the sqlplus executable.

### Notes
1. /oracle/network/admin path is precreated, pointed to by the Instant Client install and specified as a volume to allow simple configuration, including a Cloud Wallet during the run command.

