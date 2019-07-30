* Uses the following environment variables for connection
*/

/* For connection using the temp WORKSHOP_BASE schema
 * export NODE_ORACLEDB_USER='scott'
 * export NODE_ORACLEDB_PASSWORD='tiger'
 * export NODE_ORACLEDB_CONNECTIONSTRING='{server}/{sid_connection}'
 */

const oracledb=require('oracledb');
oracledb.createPool({
  user: process.env.NODE_ORACLEDB_USER,
  password: process.env.NODE_ORACLEDB_PASSWORD,
  connectString: process.env.NODE_ORACLEDB_CONNECTIONSTRING
 }, function(err) {
  if(err)
    console.error("createPool() error: " + err.message);
  else
    console.log("createPool() success");
});

function doGetConnection(cb) {
  oracledb.getConnection(function (err, connection) {
    if(err)
      console.error("Connection Failed\n",err.message);
    else
      cb(connection);
  });
}

function doRelease(connection, message) {
  connection.close(function(err) {
    if(err)
      console.error(err);
    else
      console.log(message + " : Connection released");

  });
}


// Example of a simple REPL //

function doQuery(statement, commit) {
 commit = typeof(commit) != 'boolean' ? false : commit;
 doGetConnection(function(connection) {
  console.log("Processing:\n"+statement+"\n");
  connection.execute(statement,
    function(err, result) {
      if(err)
        console.error("Connection Failed\n",err.message);
      else
      {
        console.log(result)
        if(commit) {
          connection.commit(function (err) {
            if(err)
              console.error(err);
            else
              console.log("Commit Complete");
          });
        }
      }
      doRelease(connection, "Release Complete");
    });
 });
}


doQuery('SELECT * FROM EMP',false);
