FROM oraclelinux:7-slim
  
ENV ORACLE_INSTANTCLIENT /usr/lib/oracle/18.3/client64

RUN curl -o /etc/yum.repos.d/public-yum-ol7.repo http://yum.oracle.com/public-yum-ol7.repo \
 && yum install -y yum-utils \
 && yum-config-manager --enable ol7_oracle_instantclient \
 && yum-config-manager --enable ol7_developer_nodejs8

RUN yum update -y \
 && yum install -y      node-oracledb-node8 \

# Configure Instant Client and Cloud Wallet at runtime
RUN echo "${ORACLE_INSTANTCLIENT}/lib" > /etc/ld.so.conf.d/ol7_oracle_dynlib.conf \
 && mkdir -p "${ORACLE_INSTANTCLIENT}/network" /oracle/network/admin \
 && bash -c "(cd ${ORACLE_INSTANTCLIENT}/network;ln -s /oracle/network/admin .)" \
 && ldconfig

VOLUME /oracle/network/admin

ENV TNS_ADMIN /oracle/network/admin
ENV LD_LIBRARY_PATH ${ORACLE_INSTANTCLIENT}/lib
ENV ORACLE_HOME ${ORACLE_INSTANTCLIENT}

VOLUME /code
WORKDIR /code

RUN npm install -G oracledb

CMD ["node"]
