<H1>Example Oracle SQL query</H1>

<i>In this example the hardcoded connection may need to be changed, or tnsnames.ora have an entry for myDB
and the example hr schema would need to be active in the target database.  Once connection is working,
it might be a good idea to change the SQL Query to something more meaningful, than <b>The Answer to
Life the Universe and Everything</b></i>

<p/>

<?php

$conn = oci_connect('hr', 'welcome', 'myDB');
if($conn) {

 $stid = oci_parse($conn, 'SELECT 42 FROM DUAL');

 if($stid) {
  $r = oci_execute($stid);

  if($r) {
   print "<table border='1'>\n";
   while ($row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS)) {
    print "<tr>\n";
    foreach ($row as $item) {
        print "    <td>" . ($item !== null ? htmlentities($item, ENT_QUOTES) : "&nbsp;") . "</td>\n";
    }
    print "</tr>\n";
   }
   print "</table>\n";

  } else {
  print("<H2>No Rows</H2>");
  } 
 } else {
  print("<H2>Error on execute</H2>");
   $m = oci_error();
   echo $m['message'], "\n";
 }
  oci_close($conn);
} else {
  print("<H2>Error on connect</H2>");
   $m = oci_error();
   echo $m['message'], "\n";
   exit;
}

?>

