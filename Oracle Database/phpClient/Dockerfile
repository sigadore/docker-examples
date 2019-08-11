FROM oraclelinux:7-slim

ENV ORACLE_INSTANTCLIENT /usr/lib/oracle/19.3/client64

RUN curl -o /etc/yum.repos.d/public-yum-ol7.repo http://yum.oracle.com/public-yum-ol7.repo \
 && yum install -y yum-utils \
 && yum-config-manager --enable ol7_developer_php72 \
 && yum-config-manager --enable ol7_oracle_instantclient

RUN yum update -y \
 && yum install -y oracle-instantclient19.3-basic \
      oracle-instantclient19.3-devel \
      php-fpm \
      php-oci8-12c \
      nginx

# Configure Instant Client for Cloud Wallet at runtime
RUN mkdir -p "${ORACLE_INSTANTCLIENT}/network" /oracle/network/admin \
 && bash -c "(cd ${ORACLE_INSTANTCLIENT}/network;ln -s /oracle/network/admin .)" \
 && ldconfig

VOLUME /oracle/network/admin

ENV TNSADMIN /oracle/network/admin
ENV LD_LIBRARY_PATH ${ORACLE_INSTANTCLIENT}/lib
ENV ORACLE_HOME ${ORACLE_INSTANTCLIENT}

# Configure nginx and php-fpm
ADD php-fpm_conf.sh /tmp
RUN chmod a+x /tmp/php-fpm_conf.sh \
 && /tmp/php-fpm_conf.sh



# Add in content
COPY code/ /var/www/html/
RUN chown -R nginx:nginx /var/www/html

CMD [ "bash", "-c", "php-fpm && nginx -g 'daemon off;'" ]
