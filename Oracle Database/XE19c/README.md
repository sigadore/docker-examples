# docker-examples/Oracle Database/XE13c

## Source Materials

Oracle Database XE 19c originally based on [11.2 example](https://github.com/freneticdisc/oracle-blog-examples/tree/master/Docker%20-%20Oracle%20Database) @freneticdisc/oracle-blog-examples and [23c Dev Edition example](https://blogs.oracle.com/coretec/post/oracle-database-23c-development-edition-on-docker)

*An alternative is to follow the official instructions of the README.md at [GitHub](https://github.com/oracle/docker-images/tree/main/OracleDatabase/SingleInstance), which provides out of the box support into other editions.*

The example Dockerfile expects to have the downloaded rpm [@ Oracle.Com > Technologies](https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#db_free) for the XE 19c Database in the same directory.
*I am focused on the LTM support version here since ARM has been announced for it.  So, my Docker scripting is using .zip install rather than .rpm*

### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and downloaded RPM referenced above
1. Move the Dockerfile and RPM into that directory and change to that directory in a  _Terminal or Shell window_.
1. After choosing an installPassword _With at least one uppercased, one lowercased and one numeric composing at least 8 characters_ substitute it into the following command to  Build an Image
`docker build -t 19cXE --privileged=true --docker-build-arg PASSWORD=<installPassword> .`
1. Create a container using
`docker run -it -V <databaseFileAbsolutePath>:/oradata`

### Notes
1. You are going to want to choose the initial Password and then properly change it once the sample container and pluggable Databases are installed and created as a _History_ of the container will reveal the Password initially chosen.
1. Due to what you agreed to in the license for the download of the RPM, you will NOT be wanting to upload the Image to a public space _such as DockerHub_, thus it is not suggested to make the image name something that includes your DockerHub ID.  You need to control where the bits arrive of the Oracle Database software you have downloaded.  This is also why I did not download it for you into this GitHub repository.
1. It would be _sad_ to have the Database files being written to in the Copy-On-Write top Docker layer, thus, I have provided a means where you are able to specify the path `/oradata` this will be mapped to in you Docker Server OS filesystem.  This is merely a starting point, so I have not pulled out the other non-static pieces (start log files, etc.) into other volume or symbolic link techniques.  It is possible I will identify such locations in the future and provide updates to this initial example or explicit branches, however, at this moment, this exercise can be for others to consider and suggest.

