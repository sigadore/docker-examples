FROM oraclelinux:7-slim

ENV ORACLE_INSTANTCLIENT /usr/lib/oracle/19.3

RUN yum update -y \
 && yum install -y oracle-release-el7 \
 && yum install -y oracle-instantclient19.3-basic \
      oracle-instantclient19.3-devel \
      oracle-instantclient19.3-sqlplus

# ORACLE_HOME needs to be assigned relating to TNS_ADMIN in order to Oracle Cloud Wallets to operate properly.
ENV ORACLE_HOME /oracle
ENV TNS_ADMIN ${ORACLE_HOME}/network/admin

VOLUME ${TNS_ADMIN}

# Allow mapping of `pwd` (or location of .sql scripts to be run and output to be written) to make passed in files make sense.
WORKDIR /sqlwork
VOLUME /sqlwork

ENTRYPOINT [ "sqlplus" ]
