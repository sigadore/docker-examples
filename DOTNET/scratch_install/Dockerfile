FROM --platform=arm64 ubuntu:jammy
RUN apt update -y \
 && apt install libicu70 \
 && mkdir /src
COPY dotnet*.tar.gz /src/
WORKDIR /usr/local/dotnet
RUN tar xzf /src/dotnet*.tar.gz \
    && ln -s /usr/local/dotnet/dotnet /usr/local/bin
CMD [ "dotnet", "--info" ]
