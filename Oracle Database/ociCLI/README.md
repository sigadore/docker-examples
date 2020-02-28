# docker-examples/Oracle Database/ociCLI

## Oracle Cloud OCI Command Line Interface Shell

Builds out (with the Database Option) an image containing the OCI Command Line Interface.

### Instructions
1. [Install Docker](https://www.docker.com/get-started) from here for your platform. 
1. Create a directory to hold the Dockerfile and Configuration file(s)
1. Change to that directory in a  _Terminal or Shell window_.
1. By default, the image starts in a `Bash Shell` in `Oracle Linux 7`

### Notes
1. Optional Feature DB is included
1. `/root` contains the executable and required libraries in the container as well as the `install.log`

### Running

For example:

```bash
$ docker build -t oracle_oci .
...
```
If an error happens during the install, the `install.log` will be printed, otherwise it will be available
for review in `root`.
```bash
$ docker run -it --rm oracle_oci:latest
bash-4.2# oci -v  
2.9.4

bash-4.2# oci --help
```

## Tutorial

[Getting started with the OCI CLI](https://oracle.github.io/learning-library/oci-library/DevOps/OCI_CLI/OCI_CLI_HOL.html)  
*NOTE:* With this container, you can bypass **Step 2 : Create a Compute Node and install oci CLI**
