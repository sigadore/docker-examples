# docker-examples/Oracle Database/XE18c

## Oracle Database XE 18c based on [11.2 example](https://github.com/freneticdisc/oracle-blog-examples/tree/master/Docker%20-%20Oracle%20Database) @freneticdisc/oracle-blog-examples

The example Dockerfile expects to have the downloaded rpm [@ OTN](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) for the XE 18c Database in the same directory.
The latest version, at the time of this writing is explictly named in the Docker file, this may require adjustment if a newer version becomes available.

### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and downloaded RPM referenced above
1. Move the Dockerfile and RPM into that directory and change to that directory in a  _Terminal or Shell window_.
1. After choosing an installPassword _With at least one uppercased, one lowercased and one numeric composing at least 8 characters_ substitute it into the following command to  Build an Image
`docker build -t 18cXE --privileged=true --docker-build-arg PASSWORD=<installPassword> .`
1. Create a container using
`docker run -it -V <databaseFileAbsolutePath>:/oradata`

### Notes
1. You are going to want to choose the initial Password and then properly change it once the sample container and pluggable Databases are installed and created as a _History_ of the container will reveal the Password initially chosen.
1. Due to what you agreed to in the license for the download of the RPM, you will NOT be wanting to upload the Image to a public space _such as DockerHub_, thus it is not suggested to make the image name something that includes your DockerHub ID.  You need to control where the bits arrive of the Oracle Database software you have downloaded.  This is also why I did not download it for you into this GitHub repository.
1. It would be _sad_ to have the Database files being written to in the Copy-On-Write top Docker layer, thus, I have provided a means where you are able to specify the path `/oradata` this will be mapped to in you Docker Server OS filesystem.  This is merely a starting point, so I have not pulled out the other non-static pieces (start log files, etc.) into other volume or symbolic link techniques.  It is possible I will identify such locations in the future and provide updates to this initial example or explicit branches, however, at this moment, this exercise can be for others to consider and suggest.

