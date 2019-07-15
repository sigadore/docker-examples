FROM oraclelinux:7-slim
ADD *.repo /etc/yum.repos.d/.
ENV ORACLE_INSTANTCLIENT /usr/lib/oracle/18.3
RUN yum update -y \
 && yum install -y oracle-instantclient18.3-basic \
      oracle-instantclient18.3-devel \
      oracle-instantclient18.3-sqlplus \
 && yum install -y nodejs
RUN bash -c "(cd /usr/local/bin;ln -s $ORACLE_INSTANTCLIENT/client64/bin/sqplus .)" \
&& echo "$ORACLE_INSTANTCLIENT/client64/lib" > /etc/ld.so.conf.d/ol7_oracle_dynlib.conf
CMD ['node']
