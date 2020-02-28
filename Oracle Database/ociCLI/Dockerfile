FROM oraclelinux:7-slim AS build

WORKDIR /root

RUN yum -y update

RUN curl --location --remote-name https://raw.githubusercontent.com/oracle/oci-cli/master/scripts/install/install.sh \
 && chmod a+x ./install.sh

ENV PYTHONIOENCODING=utf-8:surrogateescape

RUN ./install.sh --optional-features db --accept-all-defaults > ./install.log 2>&1 \
 && rm ./install.sh \
 || cat ./install.log

FROM oraclelinux:7-slim

WORKDIR /root

RUN yum -y update

COPY --from=build /root/. .
ENTRYPOINT [ "/bin/bash" ]
