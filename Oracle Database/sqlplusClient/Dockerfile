FROM oraclelinux:7-slim

ENV ORACLE_INSTANTCLIENT /usr/lib/oracle/19.3

RUN curl -o /etc/yum.repos.d/public-yum-ol7.repo http://yum.oracle.com/public-yum-ol7.repo \
 && yum install -y yum-utils \
 && yum-config-manager --enable ol7_oracle_instantclient

RUN yum update -y \
 && yum install -y oracle-instantclient19.3-basic \
      oracle-instantclient19.3-devel \
      oracle-instantclient19.3-sqlplus

ENV ORACLE_HOME ${ORACLE_INSTANTCLIENT}
ENV TNS_ADMIN /oracle/network/admin

# Magic to allow the Oracle Cloud Wallet defaults and Oracle Instant Client to work
# and still have the Wallet arrive in a different directory.
RUN mkdir -p "${ORACLE_INSTANTCLIENT}/network" ${TNS_ADMIN} \
 && bash -c "(cd ${ORACLE_INSTANTCLIENT}/network;ln -s ${TNS_ADMIN} .)"
VOLUME ${TNS_ADMIN}

# Allow mapping of `pwd` (or location of .sql scripts to be run and output to be written) to make passed in files make sense.
WORKDIR /sqlwork
VOLUME /sqlwork

ENTRYPOINT [ "sqlplus" ]
