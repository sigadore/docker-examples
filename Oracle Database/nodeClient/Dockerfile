FROM oraclelinux:7-slim
ADD *.repo /etc/yum.repos.d/.
RUN yum update -y \
 && yum install -y oracle-instantclient18.3-basic \
      oracle-instantclient18.3-devel \
      oracle-instantclient18.3-sqlplus \
 && yum install -y nodejs
RUN bash -c '(cd /usr/local/bin;ln -s /usr/lib/oracle/18.3/client64/bin/sqplus .)' \
&& echo '/usr/lib/oracle/18.3/client64/lib' > /etc/ld.so.conf.d/ol7_oracle_dynlib.conf
CMD ['node']
