FROM oraclelinux:7
MAINTAINER Tim Robertson <sigadore@icloud.com>

ARG _SCRATCH=/downloads
ARG DBFILE_VOLUME=/oradata
ARG PASSWORD

VOLUME ${DBFILE_VOLUME}

COPY oracle-database-xe-18c-1.0-1.x86_64.rpm ${_SCRATCH}/

RUN yum update -y -q && \
	yum install -y ${_SCRATCH}/oracle-database-xe-18c-1.0-1.x86_64.rpm && \
	echo "ORACLE_PASSWORD=${PASSWORD}" >> /etc/sysconfig/oracle-xe-18c.conf && \
	sed -i~ 's@DBFILE_DEST=.*@'"DBFILE_DEST=${DBFILE_VOLUME}@g" \
	/etc/sysconfig/oracle-xe-18c.conf && \
	rm -rf ${_SCRATCH}


CMD /etc/init.d/oracle-xe start && /bin/bash