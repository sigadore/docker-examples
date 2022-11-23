# DOTNET Base install

This project contains an example Docker File (using ubuntu) to get
dotnet installed in the "expected" location and available on
the default PATH in a Docker Container.

## Motivation
At the moment, it appears that arm64 has not been published for
ubuntu via the package manager content published by microsoft,
at least I have been running into problems getting things in place
with my new 2023 Windows Dev Kit.  Specifically, in a WSL Ubuntu
or Debian instance.  If this is done correctly, my hope is that
Visual Studio running in the Windows 11 Pro universe will be able
to interact with one or more of the WSL instances, allowing for
cross platform debugging.

Normally, one would follow the instructions (Microsoft Package Feed)
[https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu#2204-microsoft-package-feed](Dotnet on Ubuntu)
```bash
# As root ( i.e. sudo -s )
apt update &&\
apt upgrade -y &&\
apt install -y wget &&\
wget 'https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb' -O packages-microsoft-prod.deb &&\
dpkg -i packages-microsoft-prod.deb &&\
rm packages-microsoft-prod.deb &&\
apt update &&\
apt install -y dotnet-sdk-6.0 &&\
apt install -y dotnet-runtime-6.0
```

## Dockerfile
The Dockerfile included in this project current installs on the "jammy" release just the SDK and works
on my Mac M1 box, where the above instructions resulted in not being able to find an arm64 version of `dotnet-sdk-6.0`

## Next Steps
I will take the Dockerfile and use it as a pattern to get Dotnet SDK installed in one of my WSL instances in
the correct location and on the default PATH.  Hopefully, this will allow Visual Studio running on the Windows 11 Pro
OS to reach into the WSL and interact with it.
