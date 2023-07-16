FROM oraclelinux:8

ARG _SCRATCH=/downloads
ARG DBFILE_VOLUME=/oradata
ARG PASSWORD
ARG DOWNLOAD_FILE=oracle-database-free-23c-1.0-1.el8.x86_64.rpm

VOLUME ${DBFILE_VOLUME}

COPY  . ${_SCRATCH}/

RUN yum update -y -q ${DOWNLOAD_FILE} && \
	yum install -y ${_SCRATCH}/${DOWNLOAD_FILE} && \
	echo "ORACLE_PASSWORD=${PASSWORD}" >> /etc/sysconfig/oracle-xe-23c.conf && \
	sed -i~ 's@DBFILE_DEST=.*@'"DBFILE_DEST=${DBFILE_VOLUME}@g" \
	/etc/sysconfig/oracle-xe-23c.conf && \
	rm -rf ${_SCRATCH}


CMD /etc/init.d/oracle-xe start && /bin/bash