FROM oraclelinux:7-slim
ADD *.repo /etc/yum.repos.d/.
ENV ORACLE_INSTANTCLIENT /usr/lib/oracle/18.3
RUN yum update -y \
 && yum install -y oracle-instantclient18.3-basic \
      oracle-instantclient18.3-devel \
      oracle-instantclient18.3-sqlplus \
RUN bash -c "(cd /usr/local/bin;ln -s $ORACLE_INSTANTCLIENT/client64/bin/sqlplus .)" \
 && echo "$ORACLE_INSTANTCLIENT/client64/lib" > /etc/ld.so.conf.d/ol7_oracle_dynlib.conf \
 && ldconfig
RUN mkdir -p "${ORACLE_INSTANTCLIENT}/network" /oracle/network/admin \
 && (cd "${ORACLE_INSTANTCLIENT}/network";ln -s /oracle/network/admin
VOLUME /oracle/network/admin
CMD ["sqlplus"]
