# Node JS examples
This subset has been extracted from [GITHUB oracle/node-oracledb](https://github.com/oracle/node-oracledb/tree/master/examples)
These files are included here for your convience doing initial testing with the resulting container.  Please refer
to the above Repository for additional instructions, Usage and License Information.

## Usage

### Build
docker build -t nodetest .

### Run
Update the values for user, password, connectString directly in dbconfig.js or pass in the
appropiate values after seting Environment variables into the docker run of the container:
docker run -it -v "$(pwd)/examples:/code" \
               -e NODE_ORACLEDB_USER \
               -e NODE_ORACLEDB_PASSWORD \
               -e NODE_ORACLEDB_CONNECTIONSTRING \
               nodetest /code/connect.js

